// 통합 검색 결과 — 캐릭터(어디서 찾았는지 표시), 세계관, 프로젝트.
import { api } from '../api.js';
import { $, KIND, KIND_CHIP, html, portrait, render as put } from '../ui.js';

const MATCHED = { name: '이름', tagline: '소개·대사', tag: '태그', field: '기본 정보', quote: '대표 대사', body: '배경 이야기' };

export async function render(el, _params, query) {
  const q = (query.q || '').trim();
  $('[data-search] input').value = q;
  const r = await api.get(`/api/search?q=${encodeURIComponent(q)}`);
  const total = r.characters.length + r.worlds.length + r.projects.length;
  put(
    el,
    html`<h1>‘${q}’ 검색 결과</h1><div class="sub" style="margin-bottom:18px">${total}건</div>
    ${!total ? html`<div class="card empty-state"><b>찾은 게 없어요</b>다른 말로 찾아보세요. 캐릭터 이름·소개·태그·기본 정보·대사·배경 이야기를 찾아요.</div>` : ''}
    ${r.characters.length
      ? html`<div class="sec-head"><h2>캐릭터 ${r.characters.length}</h2></div><div class="card" style="padding:6px 18px">${r.characters.map(
          (c) => html`<a class="list-row" href="#/characters/${c.id}">${portrait(c, { cls: 'round', initial: false })}
            <div class="grow"><b>${c.name}</b><span class="sub">${c.tagline || c.name_en || ''}</span></div>
            <span class="chip">${MATCHED[c.matched_in]}에서 찾음</span>${c.project_name ? html`<span class="chip a d-only">${c.project_name}</span>` : ''}</a>`,
        )}</div>`
      : ''}
    ${r.worlds.length
      ? html`<div class="sec-head"><h2>세계관 ${r.worlds.length}</h2></div><div class="card" style="padding:6px 18px">${r.worlds.map(
          (w) => html`<a class="list-row" href="#/worlds/${w.id}"><div class="grow"><b>${w.name}</b><span class="sub">${w.summary || ''}</span></div></a>`,
        )}</div>`
      : ''}
    ${r.projects.length
      ? html`<div class="sec-head"><h2>프로젝트 ${r.projects.length}</h2></div><div class="card" style="padding:6px 18px">${r.projects.map(
          (p) => html`<a class="list-row" href="#/projects/${p.id}"><div class="grow"><b>${p.name}</b><span class="sub">${p.summary || ''}</span></div><span class="chip ${KIND_CHIP[p.kind]}">${KIND[p.kind]}</span></a>`,
        )}</div>`
      : ''}`,
  );
  el.querySelectorAll('.list-row .pt').forEach((x) => (x.style.cssText += ';width:40px;height:40px;flex:none'));
}
