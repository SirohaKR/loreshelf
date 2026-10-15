// 세계관 — 목록, 상세(속한 캐릭터·프로젝트), 만들기·고치기.
import { api, assetUrl } from '../api.js';
import { bindFavorites, charactersGrid, emptyState, options, projectRow } from '../parts.js';
import { $, VISIBILITY, attempt, confirmDialog, html, markdown, openMenu, pickFiles, render as put, toast, visibilityChip } from '../ui.js';

export async function renderList(el) {
  const list = await api.get('/api/worlds');
  put(
    el,
    html`<div class="page-head"><div><h1>세계관</h1><div class="sub">${list.length}개</div></div><div class="sp"></div><a class="btn pri" href="#/worlds/new">+ 새 세계관</a></div>
    ${list.length
      ? html`<div class="grid" style="grid-template-columns:repeat(auto-fill,minmax(280px,1fr))">${list.map(
          (w) => html`<a class="card" href="#/worlds/${w.id}" style="display:flex;gap:14px;align-items:center">
            ${w.cover_asset_id ? html`<img src="${assetUrl(w.cover_asset_id)}" alt="" style="width:72px;height:72px;border-radius:12px;object-fit:cover">` : html`<div class="pt empty" style="width:72px;height:72px;flex:none;--pt:var(--ok-soft)"></div>`}
            <div style="min-width:0"><b>${w.name}</b> ${visibilityChip(w.visibility)}
              <div class="sub" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${w.summary || ''}</div>
              <div class="chips" style="margin-top:6px"><span class="chip">캐릭터 ${w.character_count}</span><span class="chip">프로젝트 ${w.project_count}</span></div></div></a>`,
        )}</div>`
      : emptyState('세계관이 없어요', '캐릭터와 프로젝트가 사는 무대를 만들어 보세요.', ['#/worlds/new', '+ 새 세계관'])}`,
  );
}

export async function renderDetail(el, { id }, _query, app) {
  const w = await api.get(`/api/worlds/${id}`);
  put(
    el,
    html`<div class="crumb"><a href="#/worlds">세계관</a> / <b>${w.name}</b></div>
    <div class="page-head">
      ${w.cover_asset_id ? html`<img src="${assetUrl(w.cover_asset_id)}" alt="" style="width:88px;height:88px;border-radius:16px;object-fit:cover">` : ''}
      <div><h1>${w.name}</h1><div class="sub">${w.summary || ''}</div><div class="chips" style="margin-top:8px">${visibilityChip(w.visibility)}</div></div>
      <div class="sp"></div>
      <a class="btn pri" href="#/worlds/${w.id}/edit">✎ 편집</a>
      <span class="menu-wrap"><button class="btn" data-more>⋯</button></span>
    </div>
    ${w.body_md ? html`<div class="card prose">${markdown(w.body_md)}</div>` : ''}
    <div class="sec-head"><h2>캐릭터 ${w.characters.length}</h2><a href="#/characters/new?world=${w.id}">+ 이 세계관에 캐릭터</a></div>
    ${w.characters.length ? charactersGrid(w.characters) : html`<div class="card empty-state">아직 이 세계관의 캐릭터가 없어요.</div>`}
    <div class="sec-head"><h2>프로젝트 ${w.projects.length}</h2><a href="#/projects/new?world=${w.id}">+ 이 세계관에 프로젝트</a></div>
    ${w.projects.length ? html`<div class="card" style="padding:6px 18px">${w.projects.map(projectRow)}</div>` : html`<div class="card empty-state">아직 이 세계관의 프로젝트가 없어요.</div>`}`,
  );
  bindFavorites(el);
  $('[data-more]', el).onclick = (e) => {
    e.stopPropagation();
    openMenu(e.currentTarget, [
      {
        label: '🗑 휴지통으로',
        danger: true,
        onClick: async () => {
          if (!(await confirmDialog(`'${w.name}'을(를) 휴지통으로 옮길까요?\n속한 캐릭터·프로젝트는 그대로 남아요.`, { okText: '휴지통으로', danger: true }))) return;
          await attempt(() => api.del(`/api/worlds/${w.id}`), '휴지통으로 옮겼어요');
          app.refreshNav();
          app.navigate('/worlds');
        },
      },
    ]);
  };
}

export async function renderEdit(el, params, _query, app) {
  const editing = params.id != null;
  const w = editing ? await api.get(`/api/worlds/${params.id}`) : { name: '', visibility: 'private' };
  let coverId = w.cover_asset_id ?? null;
  put(
    el,
    html`<div class="crumb"><a href="#/worlds">세계관</a> / ${editing ? html`<a href="#/worlds/${w.id}">${w.name}</a> / 편집` : '새 세계관'}</div>
    <h1 style="margin-bottom:18px">${editing ? `${w.name} 편집` : '새 세계관'}</h1>
    <form class="form" data-form novalidate><div class="card"><div class="form-grid">
      <label class="f">이름 *<input type="text" name="title" value="${w.name}" maxlength="60" required></label>
      <label class="f">공개 범위<select name="visibility">${options(Object.entries(VISIBILITY), w.visibility)}</select></label>
      <label class="f full">한 줄 소개<input type="text" name="summary" value="${w.summary ?? ''}" maxlength="200"></label>
      <div class="f full" style="display:flex;gap:12px;align-items:center;font-size:13px;font-weight:700">대표 이미지
        <span data-cover></span><button type="button" class="btn sm" data-pick>⇪ 고르기</button><button type="button" class="btn sm" data-unpick>빼기</button></div>
      <label class="f full">설명 <small>마크다운</small><textarea name="body_md" rows="12" maxlength="50000">${w.body_md ?? ''}</textarea></label>
    </div></div>
    <div class="err" data-err hidden></div>
    <div class="form-actions"><a class="btn" href="${editing ? `#/worlds/${w.id}` : '#/worlds'}">취소</a><button class="btn pri" data-save>${editing ? '저장' : '만들기'}</button></div>
    </form>`,
  );
  const form = $('[data-form]', el);
  const drawCover = () =>
    put($('[data-cover]', el), coverId ? html`<img src="${assetUrl(coverId)}" alt="" style="width:56px;height:56px;border-radius:10px;object-fit:cover">` : html`<span class="sub">없음</span>`);
  drawCover();
  $('[data-pick]', el).onclick = async () => {
    const [f] = await pickFiles();
    if (!f) return;
    coverId = (await attempt(() => api.upload(f))).id;
    drawCover();
  };
  $('[data-unpick]', el).onclick = () => {
    coverId = null;
    drawCover();
  };
  form.onsubmit = async (e) => {
    e.preventDefault();
    const err = $('[data-err]', el);
    const payload = { name: form.title.value, summary: form.summary.value, body_md: form.body_md.value, visibility: form.visibility.value, cover_asset_id: coverId, sort_order: w.sort_order ?? 0 };
    try {
      const saved = editing ? await api.put(`/api/worlds/${w.id}`, payload) : await api.post('/api/worlds', payload);
      toast(editing ? '저장했어요' : '세계관을 만들었어요');
      app.refreshNav();
      app.navigate(`/worlds/${saved.id}`);
    } catch (ex) {
      err.textContent = ex.message;
      err.hidden = false;
    }
  };
}
