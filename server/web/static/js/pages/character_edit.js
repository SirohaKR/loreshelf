// 캐릭터 만들기 / 고치기 — 기본, 저장 위치, 대표 이미지, 기본 정보 칸, 성격 축, 대표 대사, 태그, 배경 이야기.
import { api } from '../api.js';
import { options } from '../parts.js';
import { $, $$, KIND, VISIBILITY, attempt, html, pickFiles, portrait, render as put, toast } from '../ui.js';

const DEFAULT_FIELDS = ['나이', '생일', '키', '소속'];

const fieldRow = (f = {}) => html`<div class="edit-row field" data-row="field">
  <input type="text" data-k="label" value="${f.label ?? ''}" placeholder="항목 (예: 나이)" maxlength="40">
  <input type="text" data-k="value" value="${f.value ?? ''}" placeholder="값" maxlength="2000">
  <label class="check" title="블로그에 공개해도 이 칸은 안 보여요"><input type="checkbox" data-k="is_secret" ${f.is_secret ? 'checked' : ''}>🔒 비밀</label>
  <button type="button" class="x-btn" data-del title="지우기">✕</button></div>`;

const traitRow = (t = {}) => html`<div class="edit-row trait" data-row="trait">
  <input type="text" data-k="left_label" value="${t.left_label ?? ''}" placeholder="왼쪽 (예: 내향)" maxlength="20">
  <input type="range" data-k="value_percent" min="0" max="100" value="${t.value_percent ?? 50}">
  <input type="text" data-k="right_label" value="${t.right_label ?? ''}" placeholder="반대 성격 (예: 외향)" maxlength="20">
  <button type="button" class="x-btn" data-del title="지우기">✕</button></div>`;

const quoteRow = (q = {}) => html`<div class="edit-row quote" data-row="quote">
  <input type="text" data-k="body" value="${q.body ?? ''}" placeholder="대사" maxlength="1000">
  <input type="text" data-k="situation" value="${q.situation ?? ''}" placeholder="상황 (예: 첫 만남)" maxlength="100">
  <label class="check"><input type="checkbox" data-k="is_secret" ${q.is_secret ? 'checked' : ''}>🔒</label>
  <button type="button" class="x-btn" data-del title="지우기">✕</button></div>`;

export async function render(el, params, query, app) {
  const editing = params.id != null;
  const [c, projects, tags] = await Promise.all([
    editing ? api.get(`/api/characters/${params.id}`) : Promise.resolve(null),
    api.get('/api/projects'),
    api.get('/api/tags'),
  ]);
  const v = c ?? {
    name: '', project_id: query.project ? Number(query.project) : null, world_id: null,
    visibility: 'private', fields: DEFAULT_FIELDS.map((label) => ({ label })), traits: [], quotes: [], tags: [],
  };
  let portraitId = v.portrait_asset_id ?? null;
  let tagList = [...(v.tags || [])];

  put(
    el,
    html`<div class="crumb"><a href="#/characters">캐릭터</a> / ${editing ? html`<a href="#/characters/${c.id}">${c.name}</a> / 편집` : '새 캐릭터'}</div>
    <h1 style="margin-bottom:18px">${editing ? `${c.name} 편집` : '새 캐릭터'}</h1>
    <form class="form" data-form novalidate>
      <div class="card"><h3>기본</h3>
        <div class="form-grid">
          <label class="f">이름 *<input type="text" name="name" value="${v.name}" required maxlength="60"></label>
          <label class="f">영문 이름 <small>챗봇 카드·프롬프트 트리거에도 써요</small><input type="text" name="name_en" value="${v.name_en ?? ''}" maxlength="60"></label>
          <label class="f full">한 줄 소개<input type="text" name="tagline" value="${v.tagline ?? ''}" maxlength="120" placeholder="몰락한 왕가의 마지막 기사"></label>
          <label class="f full">대표 한 줄 대사<input type="text" name="quote" value="${v.quote ?? ''}" maxlength="200" placeholder="왕관은 잃었어도, 검은 아직 내 손에 있어."></label>
          <label class="f">저장 위치 <small>프로젝트 전용 또는 공용 서재</small>
            <select name="project_id"><option value="">공용 서재</option>${options(projects.map((p) => [p.id, `${p.name} 전용 (${KIND[p.kind]})`]), v.project_id)}</select></label>
          <label class="f">공개 범위 <small>블로그는 4단계에서 열려요</small><select name="visibility">${options(Object.entries(VISIBILITY), v.visibility)}</select></label>
          <div class="f" style="display:flex;flex-direction:column;gap:6px;font-size:13px;font-weight:700">테마색
            <div style="display:flex;gap:8px;align-items:center">
              <input type="color" data-color value="${v.theme_color || '#c9573f'}" ${v.theme_color ? '' : 'disabled'}>
              <label class="check"><input type="checkbox" data-use-color ${v.theme_color ? 'checked' : ''}>색 사용</label>
            </div></div>
        </div>
      </div>

      <div class="card"><h3>대표 이미지 <small>갤러리에도 같이 들어가요</small></h3>
        <div class="portrait-pick"><div data-portrait-view></div>
          <div style="display:flex;gap:8px;flex-wrap:wrap"><button type="button" class="btn" data-pick>⇪ 이미지 고르기</button><button type="button" class="btn" data-unpick>빼기</button></div>
        </div>
      </div>

      <div class="card"><h3>기본 정보 <small>🔒 비밀 칸은 블로그에 공개해도 안 보여요</small></h3>
        <div class="rows" data-rows="field">${v.fields.map(fieldRow)}</div>
        <button type="button" class="btn sm" style="margin-top:10px" data-add="field">+ 항목 추가</button>
      </div>

      <div class="card"><h3>성격 축</h3>
        <p class="card-hint">양 끝에 반대되는 성격을 쓰고 슬라이더로 위치를 정해요. 오른쪽을 비우면 한쪽 성격의 강도로 저장돼요</p>
        <div class="rows" data-rows="trait">${v.traits.map(traitRow)}</div>
        <button type="button" class="btn sm" style="margin-top:10px" data-add="trait">+ 축 추가</button>
      </div>

      <div class="card"><h3>대표 대사</h3>
        <div class="rows" data-rows="quote">${v.quotes.map(quoteRow)}</div>
        <button type="button" class="btn sm" style="margin-top:10px" data-add="quote">+ 대사 추가</button>
      </div>

      <div class="card"><h3>태그 <small>Enter나 쉼표로 추가</small></h3>
        <div class="tag-input" data-tags><input type="text" list="tag-list" data-tag-input placeholder="#은발 #복선 …" maxlength="40"></div>
        <datalist id="tag-list">${tags.map((t) => html`<option value="${t.name}">`)}</datalist>
      </div>

      <div class="card"><h3>배경 이야기 <small>마크다운: **굵게**, *기울임*, - 목록, # 제목</small></h3>
        <textarea name="body_md" rows="10" maxlength="50000">${v.body_md ?? ''}</textarea>
      </div>

      <div class="err" data-err hidden></div>
      <div class="form-actions">
        <a class="btn" href="${editing ? `#/characters/${c.id}` : '#/characters'}">취소</a>
        <button class="btn pri" data-save>${editing ? '저장' : '만들기'}</button>
      </div>
    </form>`,
  );

  const form = $('[data-form]', el);
  const nameInput = form.elements.namedItem('name'); // form.name은 폼 자신의 속성과 헷갈려서 이렇게
  const rowTemplates = { field: fieldRow, trait: traitRow, quote: quoteRow };

  // 줄 추가·지우기
  $$('[data-add]', el).forEach(
    (b) =>
      (b.onclick = () => {
        const box = $(`[data-rows=${b.dataset.add}]`, el);
        box.insertAdjacentHTML('beforeend', rowTemplates[b.dataset.add]().s);
        box.lastElementChild.querySelector('input').focus();
      }),
  );
  form.addEventListener('click', (e) => {
    if (e.target.matches('[data-del]')) e.target.closest('[data-row]').remove();
  });

  // 테마색
  const color = $('[data-color]', el);
  $('[data-use-color]', el).onchange = (e) => (color.disabled = !e.target.checked);

  // 대표 이미지
  const drawPortrait = () => put($('[data-portrait-view]', el), portrait({ name: nameInput.value || '?', portrait_asset_id: portraitId, theme_color: color.disabled ? null : color.value }));
  drawPortrait();
  $('[data-pick]', el).onclick = async () => {
    const [file] = await pickFiles();
    if (!file) return;
    const a = await attempt(() => api.upload(file));
    portraitId = a.id;
    drawPortrait();
  };
  $('[data-unpick]', el).onclick = () => {
    portraitId = null;
    drawPortrait();
  };

  // 태그
  const tagBox = $('[data-tags]', el);
  const tagInput = $('[data-tag-input]', el);
  const drawTags = () => {
    $$('.chip', tagBox).forEach((x) => x.remove());
    for (const t of tagList) {
      tagInput.insertAdjacentHTML('beforebegin', html`<span class="chip a">#${t}<button type="button" data-untag="${t}" aria-label="태그 빼기">✕</button></span>`.s);
    }
  };
  const addTags = (text) => {
    for (const t of text.split(/[,\s]+/).map((s) => s.replace(/^#+/, '').trim()).filter(Boolean)) {
      if (!tagList.includes(t) && tagList.length < 30) tagList.push(t);
    }
    tagInput.value = '';
    drawTags();
  };
  tagInput.addEventListener('keydown', (e) => {
    if (e.isComposing) return; // 한글 조합 중 Enter는 무시
    if (e.key === 'Enter' || e.key === ',') {
      e.preventDefault();
      addTags(tagInput.value);
    } else if (e.key === 'Backspace' && !tagInput.value && tagList.length) {
      tagList.pop();
      drawTags();
    }
  });
  tagInput.addEventListener('change', () => tagInput.value && addTags(tagInput.value)); // 자동완성 목록에서 고른 경우
  tagBox.addEventListener('click', (e) => {
    const t = e.target.dataset?.untag;
    if (t != null) {
      tagList = tagList.filter((x) => x !== t);
      drawTags();
    }
  });
  drawTags();

  // 저장
  const collect = (kind) =>
    $$(`[data-rows=${kind}] [data-row]`, el).map((row) =>
      Object.fromEntries($$('[data-k]', row).map((i) => [i.dataset.k, i.type === 'checkbox' ? i.checked : i.type === 'range' ? Number(i.value) : i.value])),
    );

  form.onsubmit = async (e) => {
    e.preventDefault();
    if (tagInput.value.trim()) addTags(tagInput.value);
    const err = $('[data-err]', el);
    err.hidden = true;
    if (!nameInput.value.trim()) {
      err.textContent = '이름을 입력해 주세요';
      err.hidden = false;
      nameInput.focus();
      return;
    }
    const payload = {
      name: nameInput.value, name_en: form.name_en.value, tagline: form.tagline.value, quote: form.quote.value,
      project_id: form.project_id.value || null, world_id: v.world_id ?? null, visibility: form.visibility.value,
      theme_color: color.disabled ? null : color.value, portrait_asset_id: portraitId,
      is_favorite: !!c?.is_favorite, is_card_downloadable: !!c?.is_card_downloadable, sort_order: c?.sort_order ?? 0,
      fields: collect('field'), traits: collect('trait'), quotes: collect('quote'), tags: tagList, body_md: form.body_md.value,
    };
    const btn = $('[data-save]', el);
    btn.disabled = true;
    try {
      const saved = editing ? await api.put(`/api/characters/${c.id}`, payload) : await api.post('/api/characters', payload);
      toast(editing ? '저장했어요' : '캐릭터를 만들었어요');
      app.refreshNav();
      app.navigate(`/characters/${saved.id}`);
    } catch (ex) {
      err.textContent = ex.message;
      err.hidden = false;
      btn.disabled = false;
    }
  };
}
