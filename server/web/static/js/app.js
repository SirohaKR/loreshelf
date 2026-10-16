// 작업실 시작점 — 로그인 확인, 전체 틀(사이드바·상단·하단 탭바), 주소(#/...)에 따라 페이지 바꾸기, 테마.
import { api, setUnauthorizedHandler } from './api.js';
import { $, $$, attempt, html, openMenu, render, toast } from './ui.js';
import * as home from './pages/home.js';
import * as characters from './pages/characters.js';
import * as character from './pages/character.js';
import * as characterEdit from './pages/character_edit.js';
import * as worlds from './pages/worlds.js';
import * as projects from './pages/projects.js';
import * as search from './pages/search.js';
import * as trash from './pages/trash.js';
import * as settings from './pages/settings.js';
import * as genTools from './pages/gen_tools.js';
import * as chatbot from './pages/chatbot.js';
import * as chatbotNode from './pages/chatbot_node.js';
import { renderAuth } from './pages/auth.js';

// 주소 → 페이지. :id 는 숫자.
const ROUTES = [
  ['/', home.render, '홈'],
  ['/characters', characters.render, '캐릭터'],
  ['/characters/new', characterEdit.render, '캐릭터'],
  ['/characters/:id', character.render, '캐릭터'],
  ['/characters/:id/edit', characterEdit.render, '캐릭터'],
  ['/chatbot/:id', chatbot.renderRoadmap, '캐릭터'],
  ['/chatbot/:id/nodes/:nid', chatbotNode.render, '캐릭터'],
  ['/worlds', worlds.renderList, '세계관'],
  ['/worlds/new', worlds.renderEdit, '세계관'],
  ['/worlds/:id', worlds.renderDetail, '세계관'],
  ['/worlds/:id/edit', worlds.renderEdit, '세계관'],
  ['/projects', projects.renderList, '프로젝트'],
  ['/projects/new', projects.renderEdit, '프로젝트'],
  ['/projects/:id', projects.renderDetail, '프로젝트'],
  ['/projects/:id/edit', projects.renderEdit, '프로젝트'],
  ['/search', search.render, ''],
  ['/trash', trash.render, '휴지통'],
  ['/settings', settings.render, '설정'],
  ['/gen', genTools.render, '생성 도구'],
];

function match(path) {
  for (const [pattern, fn, nav] of ROUTES) {
    const keys = [];
    const re = new RegExp(`^${pattern.replace(/:(\w+)/g, (_, k) => (keys.push(k), '(\\d+)'))}$`);
    const m = re.exec(path);
    if (m) return { fn, nav, params: Object.fromEntries(keys.map((k, i) => [k, Number(m[i + 1])])) };
  }
  return null;
}

export const app = {
  user: null,
  settings: {},
  navigate(path) {
    location.hash = `#${path}`;
  },
  /** 사이드바 숫자 다시 읽기 */
  async refreshNav() {
    try {
      const h = await api.get('/api/home');
      $('[data-cnt=characters]').textContent = h.counts.characters;
      $('[data-cnt=projects]').textContent = h.counts.projects;
    } catch {
      /* 숫자는 못 읽어도 화면은 그대로 */
    }
  },
  setTheme(theme) {
    app.settings.theme = theme;
    applyTheme();
  },
};

// ───── 테마 ─────
const darkQuery = matchMedia('(prefers-color-scheme: dark)');
function applyTheme() {
  const t = app.settings.theme || 'system';
  const dark = t === 'dark' || (t === 'system' && darkQuery.matches);
  document.documentElement.classList.toggle('dark', dark);
  try {
    localStorage.setItem('ls-theme', t);
  } catch {
    /* 저장 못 해도 동작에는 문제없음 */
  }
}
darkQuery.addEventListener('change', applyTheme);

// ───── 전체 틀 ─────
const NAV = [
  ['/', '⌂', '홈'],
  ['/characters', '☺', '캐릭터', 'characters'],
  ['/projects', '▣', '프로젝트', 'projects'],
  ['/gen', '✦', '생성 도구'],
];

function newMenuItems() {
  return [
    { label: '☺ 새 캐릭터', onClick: () => app.navigate('/characters/new') },
    { label: '▣ 새 프로젝트', onClick: () => app.navigate('/projects/new') },
  ];
}

function renderShell() {
  const initial = [...(app.user.display_name || '?')][0];
  render(
    $('#root'),
    html`<div class="app">
      <aside class="side">
        <div class="brand"><div class="brand-mark">L</div><div><b>LoreShelf</b><small>내 캐릭터 서재</small></div></div>
        <div class="menu-wrap"><button class="new-btn" style="width:100%" data-new>+ <span>새로 만들기</span></button></div>
        <nav class="nav">
          ${NAV.map(([path, ic, label, cnt]) => html`<a href="#${path}" data-nav="${label}"><span class="ic">${ic}</span><span>${label}</span>${cnt ? html`<span class="cnt" data-cnt="${cnt}"></span>` : ''}</a>`)}
        </nav>
        <div class="side-foot nav">
          <a href="#/trash" data-nav="휴지통"><span class="ic">🗑</span><span>휴지통</span></a>
          <a href="#/settings" data-nav="설정"><span class="ic">⚙</span><span>설정</span></a>
        </div>
      </aside>
      <main class="main">
        <div class="top">
          <a href="#/" class="m-only brand-mark">L</a>
          <form class="search" data-search role="search">⌕ <input type="search" name="q" placeholder="캐릭터, 설정, 대사 검색…" aria-label="검색"><kbd class="d-only">/</kbd></form>
          <div class="sp"></div>
          <button class="icon-btn" data-theme-toggle title="밝게/어둡게">☾</button>
          <a href="#/settings" class="avatar-me" title="${app.user.display_name}">${initial}</a>
        </div>
        <div id="view"></div>
      </main>
    </div>
    <nav class="tabbar">
      <a href="#/" data-nav="홈"><span class="ic">⌂</span>홈</a>
      <a href="#/characters" data-nav="캐릭터"><span class="ic">☺</span>캐릭터</a>
      <span class="menu-wrap" style="display:grid"><button data-new-m><span class="fab">+</span></button></span>
      <a href="#/projects" data-nav="프로젝트"><span class="ic">▣</span>프로젝트</a>
      <button data-more><span class="ic">≡</span>더보기</button>
    </nav>`,
  );

  $('[data-new]').onclick = (e) => {
    e.stopPropagation();
    openMenu(e.currentTarget, newMenuItems(), { left: true });
  };
  $('[data-new-m]').onclick = () => openSheet(newMenuItems());
  $('[data-more]').onclick = () =>
    openSheet([
      { label: '✦ 생성 도구', onClick: () => app.navigate('/gen') },
      { label: '🗑 휴지통', onClick: () => app.navigate('/trash') },
      { label: '⚙ 설정', onClick: () => app.navigate('/settings') },
    ]);
  $('[data-search]').onsubmit = (e) => {
    e.preventDefault();
    const q = e.currentTarget.q.value.trim();
    if (q) app.navigate(`/search?q=${encodeURIComponent(q)}`);
  };
  $('[data-theme-toggle]').onclick = () => {
    const next = document.documentElement.classList.contains('dark') ? 'light' : 'dark';
    app.setTheme(next);
    api.put('/api/settings', { theme: next }).catch(() => {});
  };
  app.refreshNav();
}

/** 모바일 아래에서 올라오는 메뉴 */
function openSheet(items) {
  const back = document.createElement('div');
  back.className = 'modal-back';
  back.style.placeItems = 'end stretch';
  back.style.padding = '0';
  const sheet = document.createElement('div');
  sheet.className = 'sheet';
  for (const it of items) {
    const b = document.createElement('button');
    b.textContent = it.label;
    b.onclick = () => {
      back.remove();
      it.onClick();
    };
    sheet.append(b);
  }
  back.append(sheet);
  back.onclick = (e) => e.target === back && back.remove();
  document.body.append(back);
}

// ───── 페이지 바꾸기 ─────
let cleanup = null;
let renderSeq = 0;
async function route() {
  if (!app.user) return;
  const [path, qs = ''] = (location.hash.slice(1) || '/').split('?');
  const query = Object.fromEntries(new URLSearchParams(qs));
  const found = match(path);
  const view = $('#view');
  cleanup?.();
  cleanup = null;
  $$('[data-nav]').forEach((a) => a.classList.toggle('on', !!found && a.dataset.nav === found.nav));
  if (path !== '/search') $('[data-search] input').value = '';
  if (!found) {
    render(view, html`<div class="empty-state"><b>없는 페이지예요</b><a class="btn" href="#/">홈으로</a></div>`);
    return;
  }
  const seq = ++renderSeq;
  render(view, html`<div class="loading">불러오는 중…</div>`);
  window.scrollTo(0, 0);
  try {
    const r = await found.fn(view, found.params, query, app);
    if (seq === renderSeq) cleanup = typeof r === 'function' ? r : null;
  } catch (e) {
    if (seq !== renderSeq) return;
    if (e.status === 404) render(view, html`<div class="empty-state"><b>${e.message}</b><a class="btn" href="#/">홈으로</a></div>`);
    else if (e.status !== 401) render(view, html`<div class="empty-state"><b>화면을 불러오지 못했어요</b>${e.message}</div>`);
  }
}
window.addEventListener('hashchange', route);

// '/' 키로 검색칸
document.addEventListener('keydown', (e) => {
  if (!app.user || e.key !== '/' || ['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement?.tagName)) return;
  e.preventDefault();
  $('[data-search] input')?.focus();
});

// ───── 시작 ─────
async function start() {
  const me = await attempt(() => api.get('/api/auth/me'));
  if (!me.user) {
    renderAuth($('#root'), me.needs_setup, start);
    return;
  }
  app.user = me.user;
  app.settings = await api.get('/api/settings').catch(() => ({}));
  applyTheme();
  renderShell();
  route();
}

setUnauthorizedHandler(() => {
  if (!app.user) return;
  app.user = null;
  toast('다시 로그인해 주세요', 'error');
  start();
});

app.logout = async () => {
  await api.post('/api/auth/logout');
  app.user = null;
  location.hash = '#/';
  start();
};

start();
