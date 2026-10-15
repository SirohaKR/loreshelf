// 프로젝트 — 목록, 상세(전용 + 연결 캐릭터, 서재에서 연결), 만들기·고치기.
import { api, assetUrl } from '../api.js';
import { bindFavorites, charactersGrid, emptyState, options, projectRow } from '../parts.js';
import { $, $$, KIND, KIND_CHIP, VISIBILITY, attempt, confirmDialog, html, markdown, openMenu, openModal, pickFiles, portrait, render as put, toast, visibilityChip } from '../ui.js';

export async function renderList(el) {
  const list = await api.get('/api/projects');
  put(
    el,
    html`<div class="page-head"><div><h1>프로젝트</h1><div class="sub">게임 · 챗봇 · 기타 작품 단위로 캐릭터를 묶어요</div></div><div class="sp"></div><a class="btn pri" href="#/projects/new">+ 새 프로젝트</a></div>
    ${list.length ? html`<div class="card" style="padding:6px 18px">${list.map(projectRow)}</div>` : emptyState('프로젝트가 없어요', '게임이나 챗봇을 하나 만들어 보세요.', ['#/projects/new', '+ 새 프로젝트'])}`,
  );
}

export async function renderDetail(el, { id }, _query, app) {
  let p = await api.get(`/api/projects/${id}`);

  const draw = () => {
    const own = p.characters.filter((c) => c.membership === 'own');
    const linked = p.characters.filter((c) => c.membership === 'linked');
    put(
      el,
      html`<div class="crumb"><a href="#/projects">프로젝트</a> / <b>${p.name}</b></div>
      <div class="page-head">
        ${p.cover_asset_id ? html`<img src="${assetUrl(p.cover_asset_id)}" alt="" style="width:64px;height:64px;border-radius:16px;object-fit:cover">` : ''}
        <div><h1>${p.name}</h1>
          <div class="sub">${[p.summary, p.world_name && `세계관 '${p.world_name}' 연결`].filter(Boolean).join(' · ')}</div>
          <div class="chips" style="margin-top:8px"><span class="chip ${KIND_CHIP[p.kind]}">${KIND[p.kind]}</span><span class="chip">기획 ${p.progress_percent}%</span>${visibilityChip(p.visibility)}</div></div>
        <div class="sp"></div>
        <a class="btn pri" href="#/projects/${p.id}/edit">✎ 편집</a>
        <span class="menu-wrap"><button class="btn" data-more>⋯</button></span>
      </div>
      <div class="bar" style="margin-bottom:18px"><i style="width:${Number(p.progress_percent)}%"></i></div>
      ${p.body_md ? html`<div class="card prose">${markdown(p.body_md)}</div>` : ''}
      <div class="sec-head"><h2>캐릭터 <span class="sub" style="font-weight:400">· 전용 ${own.length} · 서재에서 연결 ${linked.length}</span></h2>
        <div style="display:flex;gap:8px"><button class="btn" data-link>⇄ 서재에서 연결</button><a class="btn pri" href="#/characters/new?project=${p.id}">+ 이 프로젝트에 새 캐릭터</a></div></div>
      ${p.characters.length ? charactersGrid(p.characters) : html`<div class="card empty-state"><b>아직 캐릭터가 없어요</b>이 프로젝트 전용으로 새로 만들거나, 공용 서재의 캐릭터를 연결하세요.</div>`}
      ${linked.length ? html`<div class="card" style="margin-top:16px"><h3>연결된 서재 캐릭터 <small>연결을 끊어도 캐릭터는 서재에 남아요</small></h3>${linked.map(
        (c) => html`<div class="list-row">${portrait(c, { cls: 'round', initial: false })}<div class="grow"><b>${c.name}</b><span class="sub">${c.role || '역할 없음'}</span></div>
          <button class="btn sm" data-role="${c.id}">역할</button><button class="btn sm danger" data-unlink="${c.id}">연결 끊기</button></div>`,
      )}</div>` : ''}
      <p class="sub" style="margin-top:14px">전용 = 이 프로젝트 안에만 저장 · 연결 = 공용 서재 캐릭터를 불러와 씀 (고치면 원본도 바뀜. 따로 바꾸고 싶으면 캐릭터 화면에서 '분기')</p>`,
    );
    $$('.list-row .pt', el).forEach((x) => (x.style.cssText += ';width:36px;height:36px;flex:none'));
    bindFavorites(el);
    $('[data-link]', el).onclick = linkModal;
    $$('[data-unlink]', el).forEach(
      (b) =>
        (b.onclick = async () => {
          p = await attempt(() => api.del(`/api/projects/${p.id}/characters/${b.dataset.unlink}`), '연결을 끊었어요');
          draw();
        }),
    );
    $$('[data-role]', el).forEach(
      (b) =>
        (b.onclick = async () => {
          const c = p.characters.find((x) => x.id === Number(b.dataset.role));
          const role = await openModal(
            html`<h2>${c.name}의 역할</h2><input type="text" data-r value="${c.role ?? ''}" maxlength="30" placeholder="주인공, NPC, 보스 …">
            <div class="acts"><button class="btn" data-no>취소</button><button class="btn pri" data-yes>저장</button></div>`,
            (m, close) => {
              m.querySelector('[data-no]').onclick = () => close(undefined);
              m.querySelector('[data-yes]').onclick = () => close(m.querySelector('[data-r]').value);
            },
          );
          if (role === undefined) return;
          p = await attempt(() => api.post(`/api/projects/${p.id}/characters`, { character_id: c.id, role }));
          draw();
        }),
    );
    $('[data-more]', el).onclick = (e) => {
      e.stopPropagation();
      openMenu(e.currentTarget, [{ label: '🗑 휴지통으로', danger: true, onClick: remove }]);
    };
  };

  const linkModal = async () => {
    const library = (await api.get('/api/characters?scope=library')).filter((c) => !p.characters.some((x) => x.id === c.id));
    if (!library.length) return toast('연결할 서재 캐릭터가 없어요. 서재 캐릭터는 저장 위치가 "공용 서재"인 캐릭터예요', 'error');
    const picked = await openModal(
      html`<h2>서재에서 연결</h2>
      <input type="search" data-filter placeholder="이름으로 찾기" style="margin-bottom:10px">
      <div data-list style="max-height:320px;overflow:auto">${library.map(
        (c) => html`<label class="list-row" data-name="${c.name.toLowerCase()}" style="cursor:pointer"><input type="radio" name="pick" value="${c.id}">
          <div class="grow"><b>${c.name}</b><span class="sub">${c.tagline || ''}</span></div></label>`,
      )}</div>
      <label class="f" style="margin-top:12px">역할 <small>선택</small><input type="text" data-role-input maxlength="30" placeholder="주인공, NPC, 보스 …"></label>
      <div class="acts"><button class="btn" data-no>취소</button><button class="btn pri" data-yes>연결</button></div>`,
      (m, close) => {
        m.querySelector('[data-filter]').oninput = (e) => {
          const q = e.target.value.trim().toLowerCase();
          $$('[data-name]', m).forEach((row) => (row.hidden = q && !row.dataset.name.includes(q)));
        };
        m.querySelector('[data-no]').onclick = () => close(undefined);
        m.querySelector('[data-yes]').onclick = () => {
          const v = m.querySelector('input[name=pick]:checked')?.value;
          if (!v) return toast('캐릭터를 골라 주세요', 'error');
          close({ character_id: Number(v), role: m.querySelector('[data-role-input]').value });
        };
      },
    );
    if (!picked) return;
    p = await attempt(() => api.post(`/api/projects/${p.id}/characters`, picked), '연결했어요');
    draw();
  };

  const remove = async () => {
    const own = p.characters.filter((c) => c.membership === 'own').length;
    const msg = `'${p.name}'을(를) 휴지통으로 옮길까요?${own ? `\n이 프로젝트 전용 캐릭터 ${own}명도 같이 숨겨져요 (되살리면 돌아와요).` : ''}`;
    if (!(await confirmDialog(msg, { okText: '휴지통으로', danger: true }))) return;
    await attempt(() => api.del(`/api/projects/${p.id}`), '휴지통으로 옮겼어요');
    app.refreshNav();
    app.navigate('/projects');
  };

  draw();
}

export async function renderEdit(el, params, query, app) {
  const editing = params.id != null;
  const [p, worlds] = await Promise.all([
    editing ? api.get(`/api/projects/${params.id}`) : Promise.resolve({ name: '', kind: 'game', visibility: 'private', progress_percent: 0, world_id: query.world ? Number(query.world) : null }),
    api.get('/api/worlds'),
  ]);
  let coverId = p.cover_asset_id ?? null;
  put(
    el,
    html`<div class="crumb"><a href="#/projects">프로젝트</a> / ${editing ? html`<a href="#/projects/${p.id}">${p.name}</a> / 편집` : '새 프로젝트'}</div>
    <h1 style="margin-bottom:18px">${editing ? `${p.name} 편집` : '새 프로젝트'}</h1>
    <form class="form" data-form novalidate><div class="card"><div class="form-grid">
      <label class="f">이름 *<input type="text" name="title" value="${p.name}" maxlength="60" required></label>
      <label class="f">종류<select name="kind">${options(Object.entries(KIND), p.kind)}</select></label>
      <label class="f">세계관<select name="world_id"><option value="">없음</option>${options(worlds.map((w) => [w.id, w.name]), p.world_id)}</select></label>
      <label class="f">공개 범위<select name="visibility">${options(Object.entries(VISIBILITY), p.visibility)}</select></label>
      <label class="f full">한 줄 소개<input type="text" name="summary" value="${p.summary ?? ''}" maxlength="200" placeholder="2D 턴제 RPG"></label>
      <label class="f full">기획 진행도 <small data-pct>${p.progress_percent}%</small><input type="range" name="progress_percent" min="0" max="100" step="5" value="${p.progress_percent}"></label>
      <div class="f full" style="display:flex;gap:12px;align-items:center;font-size:13px;font-weight:700">대표 이미지
        <span data-cover></span><button type="button" class="btn sm" data-pick>⇪ 고르기</button><button type="button" class="btn sm" data-unpick>빼기</button></div>
      <label class="f full">설명 <small>마크다운</small><textarea name="body_md" rows="10" maxlength="50000">${p.body_md ?? ''}</textarea></label>
    </div></div>
    <div class="err" data-err hidden></div>
    <div class="form-actions"><a class="btn" href="${editing ? `#/projects/${p.id}` : '#/projects'}">취소</a><button class="btn pri">${editing ? '저장' : '만들기'}</button></div>
    </form>`,
  );
  const form = $('[data-form]', el);
  form.progress_percent.oninput = (e) => ($('[data-pct]', el).textContent = `${e.target.value}%`);
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
    const payload = {
      name: form.title.value, kind: form.kind.value, world_id: form.world_id.value || null, visibility: form.visibility.value,
      summary: form.summary.value, progress_percent: Number(form.progress_percent.value), body_md: form.body_md.value, cover_asset_id: coverId, sort_order: p.sort_order ?? 0,
    };
    try {
      const saved = editing ? await api.put(`/api/projects/${p.id}`, payload) : await api.post('/api/projects', payload);
      toast(editing ? '저장했어요' : '프로젝트를 만들었어요');
      app.refreshNav();
      app.navigate(`/projects/${saved.id}`);
    } catch (ex) {
      err.textContent = ex.message;
      err.hidden = false;
    }
  };
}
