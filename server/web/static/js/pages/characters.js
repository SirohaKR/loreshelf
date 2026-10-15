// 캐릭터 목록 — 전체 / 서재 / 프로젝트별, 태그, 즐겨찾기, 이름 검색.
import { api } from '../api.js';
import { bindFavorites, charactersGrid, emptyState } from '../parts.js';
import { $, html, render as put } from '../ui.js';

export async function render(el, _params, query, app) {
  const [projects, tags] = await Promise.all([api.get('/api/projects'), api.get('/api/tags')]);
  const state = { scope: query.scope || '', project: query.project || '', tag: query.tag || '', fav: query.fav === '1', q: query.q || '' };

  const qs = (patch) => {
    const s = { ...state, ...patch };
    const p = new URLSearchParams();
    if (s.scope) p.set('scope', s.scope);
    if (s.project) p.set('project', s.project);
    if (s.tag) p.set('tag', s.tag);
    if (s.fav) p.set('fav', '1');
    if (s.q) p.set('q', s.q);
    const str = p.toString();
    return `#/characters${str ? `?${str}` : ''}`;
  };

  const apiQs = new URLSearchParams();
  if (state.scope === 'library') apiQs.set('scope', 'library');
  if (state.project) apiQs.set('project_id', state.project);
  if (state.tag) apiQs.set('tag', state.tag);
  if (state.fav) apiQs.set('favorite', '1');
  if (state.q) apiQs.set('q', state.q);
  const list = await api.get(`/api/characters?${apiQs}`);

  const all = !state.scope && !state.project;
  const chip = (on, label, href) => html`<a class="chip ${on ? 'a' : ''}" href="${href}">${label}</a>`;

  put(
    el,
    html`<div class="page-head"><div><h1>캐릭터</h1><div class="sub">${list.length}명</div></div><div class="sp"></div>
      <a class="btn pri" href="#/characters/new${state.project ? `?project=${state.project}` : ''}">+ 새 캐릭터</a></div>
    <div class="filters">
      ${chip(all, '전체', qs({ scope: '', project: '' }))}
      ${chip(state.scope === 'library', '공용 서재', qs({ scope: 'library', project: '' }))}
      ${projects.map((p) => chip(String(p.id) === state.project, p.name, qs({ scope: '', project: String(p.id) })))}
      ${chip(state.fav, '★ 즐겨찾기', qs({ fav: !state.fav }))}
    </div>
    ${tags.length ? html`<div class="filters">${chip(!state.tag, '모든 태그', qs({ tag: '' }))}${tags.slice(0, 20).map((t) => chip(t.name === state.tag, `#${t.name}`, qs({ tag: t.name })))}</div>` : ''}
    <form class="search" data-q style="max-width:360px;margin-bottom:16px">⌕ <input type="search" name="q" value="${state.q}" placeholder="이름·소개로 찾기"></form>
    ${list.length
      ? charactersGrid(list, { showWhere: !state.project })
      : emptyState(state.q || state.tag || state.fav ? '조건에 맞는 캐릭터가 없어요' : '아직 캐릭터가 없어요', '', ['#/characters/new', '+ 새 캐릭터'])}`,
  );
  bindFavorites(el);
  $('[data-q]', el).onsubmit = (e) => {
    e.preventDefault();
    location.hash = qs({ q: e.currentTarget.q.value.trim() });
  };
}
