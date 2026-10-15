// 여러 페이지가 같이 쓰는 화면 조각 — 캐릭터 카드, 프로젝트 줄, 빈 화면, 장르·세계관 태그 고르기.
import { api } from './api.js';
import { $, $$, KIND, KIND_CHIP, KIND_ICON, attempt, html, openModal, portrait, render, toast, visibilityChip } from './ui.js';

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
      <div class="chips"><span class="chip ${KIND_CHIP[p.kind]}">${KIND[p.kind]}</span><span class="chip">캐릭터 ${count}</span>${genreChips((p.genres || []).slice(0, 3))}</div>
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

// ───── 장르·세계관 태그 ─────
export const GENRE_CATEGORY = { genre: '장르', setting: '배경·무대', mood: '분위기·관계', trope: '소재·설정', game: '게임·형식', custom: '직접 추가' };

export function genreChips(genres, { link = false } = {}) {
  return genres.map((g) =>
    link ? html`<a class="chip genre" href="#/projects?genre=${g.id}">${g.name}</a>` : html`<span class="chip genre">${g.name}</span>`,
  );
}

/** 태그 고르기 팝업 → 고른 태그 목록 [{id, category, name}] (취소하면 undefined) */
export async function pickGenres(selected = []) {
  let all = await api.get('/api/genres');
  const chosen = new Set(selected.map((g) => g.id));
  return openModal(
    html`<h2>장르 · 세계관 태그</h2>
    <p class="sub" style="margin:-6px 0 12px">눌러서 고르고, 다시 누르면 빠져요. 없는 건 아래에서 직접 추가해요.</p>
    <input type="search" data-filter placeholder="태그 찾기 (예: 로판, 학원, 복수)" style="margin-bottom:12px">
    <div data-cats class="genre-cats"></div>
    <form data-add style="display:flex;gap:8px;margin-top:12px"><input type="text" name="name" maxlength="20" placeholder="직접 추가할 태그"><button class="btn">+ 추가</button></form>
    <div class="acts"><span class="sub" data-count style="margin-right:auto;align-self:center"></span><button class="btn" data-no>취소</button><button class="btn pri" data-yes>넣기</button></div>`,
    (m, close) => {
      m.classList.add('wide');
      const draw = () => {
        const q = $('[data-filter]', m).value.trim().toLowerCase();
        const groups = Object.keys(GENRE_CATEGORY)
          .map((cat) => [cat, all.filter((g) => g.category === cat && (!q || g.name.toLowerCase().includes(q)))])
          .filter(([, list]) => list.length);
        render(
          $('[data-cats]', m),
          groups.length
            ? groups.map(
                ([cat, list]) => html`<div class="genre-cat"><h4>${GENRE_CATEGORY[cat]}</h4><div class="chips">${list.map(
                  (g) => html`<button type="button" class="chip pick ${chosen.has(g.id) ? 'on' : ''}" data-g="${g.id}">${g.name}${g.is_custom ? html` <span data-del="${g.id}" title="이 태그 지우기">✕</span>` : ''}</button>`,
                )}</div></div>`,
              )
            : html`<div class="sub">찾는 태그가 없어요. 아래에서 직접 추가해 보세요.</div>`,
        );
        $('[data-count]', m).textContent = `${chosen.size}개 고름`;
      };
      $('[data-filter]', m).oninput = draw;
      $('[data-cats]', m).onclick = async (e) => {
        const del = e.target.closest('[data-del]');
        if (del) {
          e.stopPropagation();
          const id = Number(del.dataset.del);
          await attempt(() => api.del(`/api/genres/${id}`));
          all = all.filter((g) => g.id !== id);
          chosen.delete(id);
          return draw();
        }
        const b = e.target.closest('[data-g]');
        if (!b) return;
        const id = Number(b.dataset.g);
        if (chosen.has(id)) chosen.delete(id);
        else if (chosen.size >= 30) return toast('태그는 30개까지예요', 'error');
        else chosen.add(id);
        draw();
      };
      $('[data-add]', m).onsubmit = async (e) => {
        e.preventDefault();
        const input = e.currentTarget.elements.namedItem('name');
        if (!input.value.trim()) return;
        const g = await attempt(() => api.post('/api/genres', { name: input.value }));
        if (!all.some((x) => x.id === g.id)) all.push({ ...g, is_custom: 1 });
        chosen.add(g.id);
        input.value = '';
        $('[data-filter]', m).value = '';
        draw();
      };
      $('[data-no]', m).onclick = () => close(undefined);
      $('[data-yes]', m).onclick = () => close(all.filter((g) => chosen.has(g.id)));
      draw();
    },
  );
}
