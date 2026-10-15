// 홈 — 숫자 요약, 최근 수정한 캐릭터, 진행 중인 프로젝트.
import { api } from '../api.js';
import { bindFavorites, charactersGrid, emptyState, projectRow } from '../parts.js';
import { html, render as put } from '../ui.js';

export async function render(el) {
  const h = await api.get('/api/home');
  const n = h.counts;
  const stat = (num, label, icon, tone, href) =>
    html`<a class="card stat" href="${href}"><div class="sq" style="background:var(--${tone}-soft);color:var(--${tone})">${icon}</div><div><div class="n">${num}</div><div class="l">${label}</div></div></a>`;

  put(
    el,
    html`<h1>안녕하세요, ${h.user.display_name}님</h1>
    <div class="sub">${h.recent_characters[0] ? html`마지막 작업: ${h.recent_characters[0].name}` : '첫 캐릭터를 만들어 볼까요?'}</div>
    <div class="grid stats">
      ${stat(n.characters, '캐릭터', '☺', 'accent', '#/characters')}
      ${stat(n.projects, '프로젝트', '▣', 'warn', '#/projects')}
      ${stat(n.library_characters, '서재 캐릭터', '☰', 'ok', '#/characters?scope=library')}
      ${stat(n.public_items, '공개 중', '◐', 'rose', '#/characters')}
    </div>
    <div class="home-layout">
      <section>
        <div class="sec-head"><h2>최근 수정한 캐릭터</h2><a href="#/characters">전체 보기 →</a></div>
        ${h.recent_characters.length
          ? charactersGrid(h.recent_characters)
          : emptyState('아직 캐릭터가 없어요', '게임·챗봇 캐릭터를 하나씩 모아 보세요.', ['#/characters/new', '+ 첫 캐릭터 만들기'])}
      </section>
      <section>
        <div class="sec-head"><h2>프로젝트</h2><a href="#/projects/new">+ 추가</a></div>
        ${h.projects.length
          ? html`<div class="card" style="padding:6px 18px">${h.projects.map(projectRow)}</div>`
          : emptyState('프로젝트가 없어요', '게임이나 챗봇 단위로 캐릭터를 묶을 수 있어요.', ['#/projects/new', '+ 프로젝트 만들기'])}
      </section>
    </div>`,
  );
  bindFavorites(el);
}
