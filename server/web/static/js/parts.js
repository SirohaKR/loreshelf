// 여러 페이지가 같이 쓰는 화면 조각 — 캐릭터 카드, 프로젝트 줄, 빈 화면.
import { api } from './api.js';
import { $$, KIND, KIND_CHIP, KIND_ICON, attempt, html, portrait, visibilityChip } from './ui.js';

/** 캐릭터 카드. opts.membership: 프로젝트 화면에서 전용/연결 표시 */
export function characterCard(c, { showWhere = true } = {}) {
  const where = c.membership
    ? html`<span class="member ${c.membership}">${c.membership === 'own' ? '전용' : '연결'}</span>${c.role ? html` <span class="chip">${c.role}</span>` : ''}`
    : showWhere
      ? c.project_name
        ? html`<span class="chip a">${c.project_name}</span>`
        : html`<span class="chip">서재</span>`
      : '';
  return html`<a class="card ch" href="#/characters/${c.id}">
    <button class="fav ${c.is_favorite ? 'on' : ''}" data-fav="${c.id}" title="즐겨찾기" aria-label="즐겨찾기">★</button>
    ${portrait(c, { badge: c.visibility !== 'private' ? visibilityChip(c.visibility) : null })}
    <b>${c.name}</b>
    <p>${c.tagline || c.name_en || ''}</p>
    <div class="chips">${where}${(c.tags || []).slice(0, 2).map((t) => html`<span class="chip">#${t}</span>`)}</div>
  </a>`;
}

/** 카드의 ★ 버튼 연결 (페이지를 다시 그리지 않고 그 자리에서 바꿈) */
export function bindFavorites(root) {
  for (const b of $$('[data-fav]', root)) {
    b.onclick = async (e) => {
      e.preventDefault();
      e.stopPropagation();
      const on = !b.classList.contains('on');
      await attempt(() => api.put(`/api/characters/${b.dataset.fav}/favorite`, { is_favorite: on }));
      b.classList.toggle('on', on);
    };
  }
}

export function charactersGrid(list, opts) {
  return html`<div class="grid chars">${list.map((c) => characterCard(c, opts))}</div>`;
}

export function projectRow(p) {
  const count = (p.own_character_count || 0) + (p.linked_character_count || 0);
  return html`<a class="proj" href="#/projects/${p.id}">
    <div class="ico" style="background:var(--${KIND_CHIP[p.kind]}-soft);color:var(--${KIND_CHIP[p.kind]})">${KIND_ICON[p.kind]}</div>
    <div class="meta"><b>${p.name}</b>
      <span class="chip ${KIND_CHIP[p.kind]}">${KIND[p.kind]}</span> <span class="chip">캐릭터 ${count}</span>
      <div class="bar"><i style="width:${Number(p.progress_percent) || 0}%"></i></div>
    </div>
  </a>`;
}

export function emptyState(title, text, action) {
  return html`<div class="card empty-state"><b>${title}</b>${text}${action ? html`<br><a class="btn pri" href="${action[0]}">${action[1]}</a>` : ''}</div>`;
}

/** 선택 상자 옵션 (value, label, selected) */
export function options(list, selected) {
  return list.map(([v, label]) => html`<option value="${v}" ${String(v) === String(selected ?? '') ? 'selected' : ''}>${label}</option>`);
}
