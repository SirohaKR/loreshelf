// 캐릭터 상세 — 프로필 / 갤러리 탭, 즐겨찾기, 편집, 옮기기·분기·휴지통.
import { api, assetUrl } from '../api.js';
import { options } from '../parts.js';
import { $, $$, KIND, attempt, confirmDialog, html, markdown, openMenu, openModal, pickFiles, portrait, render as put, toast, visibilityChip } from '../ui.js';

export async function render(el, { id }, query, app) {
  let c = await api.get(`/api/characters/${id}`);
  let tab = query.tab === 'gallery' ? 'gallery' : 'profile';

  const draw = () => {
    const where = c.project_id
      ? html`<span class="member own">전용</span> <a href="#/projects/${c.project_id}"><b>${c.project_name}</b></a> 프로젝트에 저장`
      : html`<span class="chip">공용 서재</span>`;
    put(
      el,
      html`<div class="crumb d-only"><a href="#/characters">캐릭터</a>${c.project_id ? html` / <a href="#/projects/${c.project_id}">${c.project_name}</a>` : ''} / <b>${c.name}</b></div>
      <div class="hero">
        ${portrait(c)}
        <div class="info">
          <h1>${c.name}</h1>
          ${c.name_en || c.world_name ? html`<div class="en">${[c.name_en, c.world_name && `세계관 ${c.world_name}`].filter(Boolean).join(' · ')}</div>` : ''}
          ${c.quote ? html`<div class="one">“${c.quote}”</div>` : c.tagline ? html`<div class="one">${c.tagline}</div>` : html`<div style="height:10px"></div>`}
          <div class="where">${where}
            ${c.linked_projects.map((p) => html`<span class="member linked">연결</span><a href="#/projects/${p.id}">${p.name}</a>${p.role ? ` (${p.role})` : ''}`)}
            ${c.source_character_id ? html`<span>· 분기 원본 <a href="#/characters/${c.source_character_id}"><b>${c.source_character_name || '(삭제됨)'}</b></a></span>` : ''}
            ${visibilityChip(c.visibility)}
          </div>
          ${c.tags.length ? html`<div class="chips" style="margin-bottom:14px">${c.tags.map((t) => html`<a class="chip" href="#/characters?tag=${encodeURIComponent(t)}">#${t}</a>`)}</div>` : ''}
          <div class="acts">
            <button class="btn" data-fav>${c.is_favorite ? '★ 즐겨찾기 해제' : '☆ 즐겨찾기'}</button>
            <a class="btn pri" href="#/characters/${c.id}/edit">✎ 편집</a>
            <span class="menu-wrap"><button class="btn" data-more>⋯ 더보기</button></span>
          </div>
        </div>
      </div>
      <div class="tabs" role="tablist">
        <a class="${tab === 'profile' ? 'on' : ''}" data-tab="profile">프로필</a>
        <a class="${tab === 'gallery' ? 'on' : ''}" data-tab="gallery">갤러리 ${c.gallery.length}</a>
        <a class="off" title="2단계에서 만들어요">이미지·프롬프트</a>
        <a class="off" title="3단계에서 만들어요">챗봇 설정</a>
      </div>
      <div data-body>${tab === 'profile' ? profile() : gallery()}</div>`,
    );
    bind();
  };

  const profile = () => {
    const empty = !c.fields.length && !c.traits.length && !c.quotes.length && !c.body_md && !c.tagline;
    if (empty) {
      return html`<div class="card empty-state"><b>아직 프로필이 비어 있어요</b>기본 정보, 성격, 대표 대사, 배경 이야기를 채워 보세요.<br><a class="btn pri" href="#/characters/${c.id}/edit">✎ 프로필 쓰기</a></div>`;
    }
    return html`<div class="cols">
      <div class="grid">
        ${c.tagline && c.quote ? html`<div class="card"><h3>한 줄 소개</h3>${c.tagline}</div>` : ''}
        ${c.fields.length
          ? html`<div class="card"><h3>기본 정보</h3><dl class="kv">${c.fields.map(
              (f) => html`<dt>${f.label}${f.is_secret ? html`<span class="secret-mark" title="블로그에 안 보여요">🔒</span>` : ''}</dt><dd>${f.value || '—'}</dd>`,
            )}</dl></div>`
          : ''}
        ${c.traits.length
          ? html`<div class="card"><h3>성격 축</h3>${c.traits.map(
              (t) => html`<div class="trait"><div class="row"><span>${t.left_label}</span><span>${t.right_label}</span></div><div class="track"><i style="left:${Number(t.value_percent)}%"></i></div></div>`,
            )}</div>`
          : ''}
      </div>
      <div class="grid">
        ${c.body_md ? html`<div class="card prose"><h3>배경 이야기</h3>${markdown(c.body_md)}</div>` : ''}
        ${c.quotes.length
          ? html`<div class="card"><h3>대표 대사 <small>3단계에서 챗봇 예시 대화로 재사용</small></h3>${c.quotes.map(
              (q) => html`<div class="quote">${q.body}${q.is_secret ? html`<span class="secret-mark">🔒</span>` : ''}${q.situation ? html`<small>${q.situation}</small>` : ''}</div>`,
            )}</div>`
          : ''}
      </div>
    </div>`;
  };

  const gallery = () => html`<div class="page-head"><div class="sub">PNG · JPG · GIF · WEBP, 한 장에 20MB까지. 같은 파일은 한 번만 저장돼요.</div><div class="sp"></div>
      <button class="btn pri" data-upload>⇪ 이미지 올리기</button></div>
    ${c.gallery.length
      ? html`<div class="gal">${c.gallery.map(
          (a) => html`<div class="item">
            <a href="${assetUrl(a.id, false)}" target="_blank" rel="noopener"><img src="${assetUrl(a.id)}" alt="${a.original_name}" loading="lazy"></a>
            ${a.id === c.portrait_asset_id ? html`<span class="star">★ 대표</span>` : ''}
            <div class="ops">
              ${a.id !== c.portrait_asset_id ? html`<button class="btn sm" data-portrait="${a.id}">대표로</button>` : ''}
              <button class="btn sm danger" data-remove="${a.id}">빼기</button>
            </div></div>`,
        )}</div>`
      : html`<div class="card empty-state"><b>갤러리가 비어 있어요</b>이미지를 올리면 여기에 모여요.</div>`}`;

  const bind = () => {
    $$('[data-tab]', el).forEach((a) =>
      a.addEventListener('click', () => {
        tab = a.dataset.tab;
        history.replaceState(null, '', `#/characters/${c.id}${tab === 'gallery' ? '?tab=gallery' : ''}`);
        draw();
      }),
    );
    $('[data-fav]', el).onclick = async () => {
      await attempt(() => api.put(`/api/characters/${c.id}/favorite`, { is_favorite: !c.is_favorite }));
      c.is_favorite = c.is_favorite ? 0 : 1;
      draw();
    };
    $('[data-more]', el).onclick = (e) => {
      e.stopPropagation();
      openMenu(e.currentTarget, [
        c.project_id
          ? { label: '⇱ 공용 서재로 꺼내기', onClick: () => move(null) }
          : { label: '⇲ 프로젝트 전용으로 옮기기', onClick: () => pickProject('어느 프로젝트로 옮길까요?', move) },
        ...(c.project_id ? [{ label: '⇄ 다른 프로젝트로 옮기기', onClick: () => pickProject('어느 프로젝트로 옮길까요?', move) }] : []),
        { label: '⑂ 프로젝트용으로 분기(복사)', onClick: () => pickProject('분기한 캐릭터를 어디에 둘까요?', fork, true) },
        'sep',
        { label: '🗑 휴지통으로', danger: true, onClick: remove },
      ]);
    };
    const up = $('[data-upload]', el);
    if (up) up.onclick = upload;
    $$('[data-portrait]', el).forEach((b) => (b.onclick = () => addAsset(Number(b.dataset.portrait), true)));
    $$('[data-remove]', el).forEach(
      (b) =>
        (b.onclick = async () => {
          c = await attempt(() => api.del(`/api/characters/${c.id}/assets/${b.dataset.remove}`), '갤러리에서 뺐어요');
          draw();
        }),
    );
  };

  const addAsset = async (assetId, setPortrait = false) => {
    c = await attempt(() => api.post(`/api/characters/${c.id}/assets`, { asset_id: assetId, set_portrait: setPortrait }));
    draw();
  };

  const upload = async () => {
    const files = await pickFiles({ multiple: true });
    if (!files.length) return;
    const btn = $('[data-upload]', el);
    btn.disabled = true;
    let done = 0;
    for (const f of files) {
      btn.textContent = `올리는 중… ${done + 1}/${files.length}`;
      try {
        const a = await api.upload(f);
        c = await api.post(`/api/characters/${c.id}/assets`, { asset_id: a.id, set_portrait: !c.portrait_asset_id });
        done++;
      } catch (e) {
        toast(`${f.name}: ${e.message}`, 'error');
      }
    }
    if (done) toast(`${done}장 올렸어요`);
    draw();
  };

  /** 프로젝트 고르기 모달 (분기는 서재도 고를 수 있음) */
  const pickProject = async (title, then, allowLibrary = false) => {
    const projects = (await api.get('/api/projects')).filter((p) => p.id !== c.project_id || allowLibrary);
    if (!projects.length && !allowLibrary) return toast('옮길 프로젝트가 없어요. 프로젝트를 먼저 만들어 주세요', 'error');
    const choice = await openModal(
      html`<h2>${title}</h2>
      <select data-p>${allowLibrary ? html`<option value="">공용 서재</option>` : ''}${options(projects.map((p) => [p.id, `${p.name} (${KIND[p.kind]})`]))}</select>
      <div class="acts"><button class="btn" data-no>취소</button><button class="btn pri" data-yes>확인</button></div>`,
      (m, close) => {
        m.querySelector('[data-no]').onclick = () => close(undefined);
        m.querySelector('[data-yes]').onclick = () => close(m.querySelector('[data-p]').value);
      },
    );
    if (choice !== undefined) then(choice === '' ? null : Number(choice));
  };

  const move = async (projectId) => {
    c = await attempt(() => api.post(`/api/characters/${c.id}/move`, { project_id: projectId }), projectId ? '프로젝트 전용으로 옮겼어요' : '공용 서재로 꺼냈어요');
    draw();
  };

  const fork = async (projectId) => {
    const copy = await attempt(() => api.post(`/api/characters/${c.id}/fork`, { project_id: projectId }), '분기했어요. 복사본을 열었어요');
    app.refreshNav();
    app.navigate(`/characters/${copy.id}`);
  };

  const remove = async () => {
    if (!(await confirmDialog(`'${c.name}'을(를) 휴지통으로 옮길까요?\n휴지통에서 되살릴 수 있어요.`, { okText: '휴지통으로', danger: true }))) return;
    await attempt(() => api.del(`/api/characters/${c.id}`), '휴지통으로 옮겼어요');
    app.refreshNav();
    app.navigate('/characters');
  };

  draw();
}
