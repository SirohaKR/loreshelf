// 챗봇 카드 편집 — 칸별 입력, 글자 수(로판·로플 두 기준), {{char}}·{{user}}·{{var_이름}} 칩 버튼과 색칠, 잘못된 표기 고치기.
// 입력하면 잠깐 뒤 저장(자동 저장), Ctrl+S 나 저장 버튼으로 바로 저장.
// 오른쪽(휴대폰은 아래) "저장 후 미리보기"는 저장된 내용으로 {{char}}·{{user}}를 바꿔 보여 준다. "프로필에서 채우기"는 chatbot_profile.js.
// 기획: docs/planning/챗봇-설정-기획서.md 2-1(입력 규칙) · 2-2(미리보기) · 2-3(프로필에서 채우기)
import { api, assetUrl } from '../api.js';
import { $, $$, attempt, confirmDialog, html, openMenu, raw, render as put, toast } from '../ui.js';
import { KIND_ICON, KIND_TONE } from './chatbot.js';
import {
  PLATFORM_NAME, ROFAN_DETAIL, convertNotation, fieldChecks, findNotations, fixNotations, formFor, highlightHtml, loadMeta, previewParts, rofanDetailParts, variableNames,
} from './chatbot_kit.js';
import { chooseProposals, profileProposals } from './chatbot_profile.js';

const SAVE_DELAY = 1000;

export async function render(el, { id, nid }, _query, app) {
  const [meta, story] = await Promise.all([loadMeta(), api.get(`/api/chatbot/stories/${id}`)]);
  let node = story.nodes.find((n) => n.id === nid);
  if (!node) throw Object.assign(new Error('카드를 찾을 수 없어요'), { status: 404 });
  const kind = node.kind;
  const form = formFor(kind, story.edit_mode);
  const needs = (t) => form.some((f) => f.type === t || f.fields?.some((g) => g.type === t));
  // 프로필에서 채우기에 쓸 캐릭터: 인물 카드는 가리키는 캐릭터, 스토리 카드는 대표 캐릭터
  const profileId = () => (kind === 'character' ? draft.source_character_id ?? story.main_character_id : kind === 'story' ? story.main_character_id : null);
  const [characters, gallery] = await Promise.all([
    needs('character') || kind === 'character' ? api.get('/api/characters') : [],
    needs('asset') && story.main_character_id ? api.get(`/api/characters/${story.main_character_id}`).then((c) => c.gallery) : [],
  ]);

  // 편집 중인 값 (저장 전)
  const draft = { title: node.title, source_character_id: node.source_character_id, content: structuredClone(node.content) };
  let dirty = false;
  let timer = null;
  let saving = null;
  let lastError = '';
  const fields = {}; // path → {limits, notation}
  let previewMode = 'preview'; // preview | rofan | rplay
  let tryUser = ''; // "이름 바꿔 보기" (저장 안 함)
  let savedAt = null;

  const others = () => story.nodes.filter((n) => n.id !== nid);
  const variables = () => variableNames(story.nodes.map((n) => (n.id === nid ? { ...n, content: draft.content } : n)));
  const detailTotal = () =>
    rofanDetailParts(story.nodes.map((n) => (n.id === nid ? { ...n, title: draft.title, content: draft.content } : n))).reduce((s, p) => s + p.count, 0);

  // ───── 그리기 ─────

  const draw = () => {
    for (const k of Object.keys(fields)) delete fields[k];
    put(
      el,
      html`<div class="crumb"><a href="#/chatbot/${story.id}">${story.title}</a> › ${meta.kind_labels[kind]}</div>
      <div class="page-head cb-head">
        <span class="kind-ic lg" style="--tone:var(--${KIND_TONE[kind]});--tone-soft:var(--${KIND_TONE[kind]}-soft)">${KIND_ICON[kind]}</span>
        <div><h1 data-h1>${draft.title}</h1><div class="sub">${meta.kind_labels[kind]} 카드${kind === 'character' ? html` · 글에선 <code class="n-char">{{char}}</code>` : ''}${node.is_enabled ? '' : ' · 꺼 둠'}</div></div>
        <div class="sp"></div>
        <span class="cb-status" data-status></span>
        <a class="btn" href="#/chatbot/${story.id}">← 로드맵</a>
        ${['character', 'story'].includes(kind) ? html`<button class="btn" data-fill ${profileId() ? '' : 'disabled title="이을 캐릭터가 없어요"'}>☺ 프로필에서 채우기</button>` : ''}
        ${kind === 'story' ? '' : html`<span class="menu-wrap"><button class="btn" data-more>⋯</button></span>`}
        <button class="btn pri" data-save>저장</button>
      </div>
      <div class="cb-wrap">
        <form class="card form cb-form" data-form autocomplete="off">
          ${titleField()}
          ${form.map((f) => field(f, f.path))}
        </form>
        <aside class="cb-side">${side()}</aside>
      </div>`,
    );
    bind();
    for (const path of Object.keys(fields)) refreshField(path);
    refreshCounts();
    showStatus();
    drawPreview();
  };

  const titleField = () => {
    if (kind === 'character') {
      fields.__title = { limits: ['rofan.character.name'], notation: false };
      return html`<div class="form-grid">
        ${textHead('__title', '이름', '로판 캐릭터 이름 칸 · 대화 속에선 {{char}}')}
        <label class="f">서재 캐릭터 <small>이 인물 카드가 가리키는 캐릭터</small>
          <select data-path="__source" data-type="int">${[html`<option value="">(없음)</option>`, ...characters.map((c) => html`<option value="${c.id}" ${c.id === draft.source_character_id ? 'selected' : ''}>${c.name}</option>`)]}</select></label>
      </div>`;
    }
    fields.__title = { limits: [], notation: false };
    return textHead('__title', '카드 이름', '로드맵에 보이는 이름');
  };

  /** 한 줄 입력 (카드 이름) */
  function textHead(path, label, hint) {
    return html`<div class="nf" data-nf="${path}">
      <div class="nf-head"><b>${label}</b><small>${hint}</small><span class="nf-count" data-count="${path}"></span></div>
      <input type="text" data-path="${path}" maxlength="100" value="${draft.title}">
    </div>`;
  }

  /** 칸 하나. path = content 안 위치 (줄 목록이면 'start_messages.0.body') */
  function field(f, path) {
    const v = getAt(draft.content, path);
    switch (f.type) {
      case 'text': {
        fields[path] = { limits: f.limits || [], notation: !f.plain };
        const head = html`<div class="nf-head"><b>${f.label}</b>${f.hint ? html`<small>${f.hint}</small>` : ''}<span class="nf-count" data-count="${path}"></span></div>`;
        if (f.single) {
          return html`<div class="nf ${f.small ? 'sm' : ''}" data-nf="${path}">${head}<input type="text" data-path="${path}" value="${v ?? ''}" placeholder="${f.placeholder || ''}"></div>`;
        }
        return html`<div class="nf" data-nf="${path}">${head}
          <div class="nf-tools">
            <button type="button" class="ins n-char" data-ins="{{char}}" title="캐릭터 본인">+ {{char}}</button>
            <button type="button" class="ins n-user" data-ins="{{user}}" title="이용자">+ {{user}}</button>
            <span class="menu-wrap"><button type="button" class="ins n-variable" data-ins-var title="변수">+ 변수</button></span>
          </div>
          <div class="nf-box"><div class="nf-hl" aria-hidden="true"></div><textarea data-path="${path}" rows="${f.rows || 3}" spellcheck="false" placeholder="${f.placeholder || ''}">${v ?? ''}</textarea></div>
          <div class="nf-bar" data-bar="${path}"><i></i></div>
          <div class="nf-fix" data-fix="${path}"></div>
        </div>`;
      }
      case 'int':
        return html`<label class="f nf-inline">${f.label}${f.hint ? html` <small>${f.hint}</small>` : ''}<input type="number" class="input" data-path="${path}" data-type="int" value="${v ?? ''}" ${f.min !== undefined ? html`min="${f.min}"` : ''} ${f.max !== undefined ? html`max="${f.max}"` : ''}></label>`;
      case 'bool':
        return html`<label class="check nf-check"><input type="checkbox" data-path="${path}" data-type="bool" ${v ? 'checked' : ''}> <b>${f.label}</b>${f.hint ? html` · ${f.hint}` : ''}</label>`;
      case 'choice':
        return html`<label class="f nf-inline">${f.label}<select data-path="${path}">${f.values.map(([val, label]) => html`<option value="${val}" ${val === v ? 'selected' : ''}>${label}</option>`)}</select></label>`;
      case 'list': {
        const count = f.countLimit ? meta.count_limits[f.countLimit] : null;
        return html`<label class="f">${f.label} ${f.hint ? html`<small>${f.hint}</small>` : ''}
          <input type="text" data-path="${path}" data-type="list" value="${(v || []).join(', ')}">
          ${count ? html`<small data-listcount="${path}" data-max="${count.max}"></small>` : ''}</label>`;
      }
      case 'character':
        return html`<label class="f nf-inline">${f.label}<select data-path="${path}" data-type="int">${[html`<option value="">(없음)</option>`, ...characters.map((c) => html`<option value="${c.id}" ${c.id === v ? 'selected' : ''}>${c.name}</option>`)]}</select></label>`;
      case 'variable': {
        const names = variables();
        const list = v && !names.includes(v) ? [v, ...names] : names;
        return html`<label class="f nf-inline">${f.label}<select data-path="${path}">${[html`<option value="">(고르기)</option>`, ...list.map((n) => html`<option value="${n}" ${n === v ? 'selected' : ''}>${n}</option>`)]}</select></label>`;
      }
      case 'node':
        return html`<label class="f nf-inline">${f.label}<select data-path="${path}" data-type="int">${[html`<option value="">(고르기)</option>`, ...others().map((n) => html`<option value="${n.id}" ${n.id === v ? 'selected' : ''}>${meta.kind_labels[n.kind]} · ${n.title}</option>`)]}</select></label>`;
      case 'asset':
        return html`<div class="f"><b style="font-size:13px">${f.label}</b>
          ${gallery.length
            ? html`<div class="cb-assets">${[
                html`<button type="button" class="none ${v ? '' : 'on'}" data-asset="">없음</button>`,
                ...gallery.map((a) => html`<button type="button" class="${a.id === v ? 'on' : ''}" data-asset="${a.id}"><img src="${assetUrl(a.id)}" alt="${a.original_name}" loading="lazy"></button>`),
              ]}</div>`
            : html`<div class="sub">대표 캐릭터 갤러리에 이미지를 올리면 여기서 골라요.</div>`}</div>`;
      case 'rows': {
        const list = v || [];
        const count = f.countLimit ? meta.count_limits[f.countLimit] : null;
        if (f.limits) fields[path] = { limits: f.limits, notation: false, joined: true };
        return html`<div class="nf cb-rows" data-nf="${path}">
          <div class="nf-head"><b>${f.label}</b>${f.hint ? html`<small>${f.hint}</small>` : ''}<span class="nf-count" data-count="${path}">${count ? `${list.length}/${count.max}개` : ''}</span></div>
          ${list.map(
            (_, i) => html`<div class="cb-rowbox ${f.inline ? 'inline' : ''}">
              <div class="cb-rowfields">${f.fields.map((g) => field(g, `${path}.${i}.${g.path}`))}</div>
              <button type="button" class="x-btn" data-row-del="${path}" data-i="${i}" title="이 줄 빼기" aria-label="이 줄 빼기">✕</button>
            </div>`,
          )}
          <button type="button" class="btn sm" data-row-add="${path}">${f.add}</button>
        </div>`;
      }
      default:
        return '';
    }
  }

  const side = () => html`<div class="card cb-preview" data-preview></div>
    <div class="card">
      <h3>글자 수 <small>기준일 ${meta.limits_checked_on}</small></h3>
      <div data-side-counts></div>
      <div class="hint">로판은 글자, 로플은 토큰(≈ 근사치)으로 세요. 90% 이상 주황, 넘으면 빨강. 플랫폼은 넘친 부분을 말없이 잘라요.</div>
    </div>
    <div class="card">
      <h3>표기</h3>
      <dl class="kv cb-legend-kv">
        <dt><code class="n-char">{{char}}</code></dt><dd>캐릭터 본인${story.main_character_name ? ` (${story.main_character_name})` : ''} · 로플로 내보낼 땐 이름으로 바꿔요</dd>
        <dt><code class="n-user">{{user}}</code></dt><dd>대화하는 이용자</dd>
        <dt><code class="n-variable">{{var_이름}}</code></dt><dd>변수 카드의 값 · 로판에선 낱말로</dd>
        <dt><code class="n-invalid">{{Char}}</code></dt><dd>잘못된 표기 — 노란 밑줄, 바꾸기 제안</dd>
      </dl>
    </div>`;

  // ───── 저장 후 미리보기 (기획서 2-2) ─────

  const charName = () => (kind === 'character' ? node.title : story.main_character_name) || '캐릭터';
  const nickname = () => app.settings.chat_nickname || app.user.display_name;
  /** 변수 예시 값 = 변수 카드의 처음 값 */
  const sampleValues = () =>
    Object.fromEntries(story.nodes.filter((n) => n.kind === 'variable' && n.content.name && n.content.initial_value).map((n) => [n.content.name, n.content.initial_value]));

  /** 저장된 카드에서 보여 줄 글들 [{label, text, bubble}] — 시작 메시지·첫 메시지는 말풍선으로 맨 위에 */
  const previewTexts = () => {
    const c = node.content;
    const out = [];
    for (const f of form) {
      if (f.type === 'text' && !f.single && c[f.path]?.trim()) out.push({ label: f.label, text: c[f.path], bubble: f.path === 'solo_first_message' });
      if (f.type === 'rows' && f.path === 'start_messages') {
        for (const m of c.start_messages || []) if (m.body?.trim()) out.push({ label: `시작 메시지 · ${m.name || '이름 없음'}`, text: m.body, bubble: true });
      }
    }
    return out.sort((a, b) => Number(b.bubble) - Number(a.bubble));
  };

  const previewHtml = (text) => {
    if (previewMode !== 'preview') return raw(highlightHtml(convertNotation(text, previewMode, charName())));
    return html`${previewParts(text, { charName: charName(), userName: tryUser || nickname(), values: sampleValues() }).map((p) =>
      p.kind ? html`<b class="n-${p.kind}">${p.text}</b>` : p.text,
    )}`;
  };

  const nameSource = () =>
    tryUser ? '잠깐 바꿔 보는 중 · 저장 안 돼요' : app.settings.chat_nickname ? '설정의 대화용 별명' : '계정 이름 (설정에서 대화용 별명을 정할 수 있어요)';

  function drawPreview() {
    const box = $('[data-preview]', el);
    if (!box) return;
    const texts = previewTexts();
    put(
      box,
      html`<div class="card-h"><h3 style="margin:0">저장 후 미리보기 ${savedAt ? html`<small class="cb-status ok">✓ 방금 저장</small>` : ''}</h3>
        <div class="seg">${[['preview', '미리보기'], ['rofan', '로판'], ['rplay', '로플']].map(
          ([m, label]) => html`<a class="${previewMode === m ? 'on' : ''}" data-pmode="${m}" title="${m === 'preview' ? '이름을 넣어서' : `${label}에 붙여 넣을 모양`}">${label}</a>`,
        )}</div></div>
      ${previewMode === 'preview'
        ? html`<div class="pv-names">
            <span><code class="n-char">{{char}}</code> = <b>${charName()}</b></span>
            <label><code class="n-user">{{user}}</code> = <input type="text" data-try-user value="${tryUser}" placeholder="${nickname()}" maxlength="30" aria-label="이름 바꿔 보기"></label>
          </div>
          <div class="sub pv-src">${nameSource()} · <a href="#/settings">설정</a></div>`
        : html`<div class="sub pv-src">${previewMode === 'rofan' ? '로판AI에 붙일 모양: {{char}}·{{user}} 그대로, 변수는 낱말로' : '로플챗에 붙일 모양: {{char}} → 캐릭터 이름, {{user}}·변수 그대로'}</div>`}
      ${texts.length
        ? texts.map(
            (t) => html`<div class="pv-item"><small>${t.label}</small>${t.bubble
              ? html`<div class="pv-bubble"><span class="pv-who">${charName()}</span><div data-pv>${previewHtml(t.text)}</div></div>`
              : html`<div class="pv-text" data-pv>${previewHtml(t.text)}</div>`}</div>`,
          )
        : html`<div class="sub">글을 쓰고 저장하면 여기에 실제로 보이는 모습이 떠요.</div>`}`,
    );
    $$('[data-pmode]', box).forEach((a) => (a.onclick = () => ((previewMode = a.dataset.pmode), drawPreview())));
    const tu = $('[data-try-user]', box);
    if (tu) {
      // 입력칸은 그대로 두고 아래 글만 다시 (저장 안 함)
      tu.oninput = () => {
        tryUser = tu.value.trim();
        $$('[data-pv]', box).forEach((d, i) => put(d, previewHtml(texts[i].text)));
        $('.pv-src', box).firstChild.textContent = `${nameSource()} · `;
      };
    }
  }

  /** 프로필에서 채우기: 제안 → 전/후 비교 창 → 고른 칸만 넣고 저장 */
  async function fillFromProfile() {
    const cid = profileId();
    if (!cid) return;
    const c = await attempt(() => api.get(`/api/characters/${cid}`));
    const proposals = profileProposals(kind, c);
    if (!proposals.length) return toast('프로필에 채울 내용이 없어요', 'error');
    const chosen = await chooseProposals(c.name, proposals, draft.content);
    if (!chosen?.length) return;
    for (const p of chosen) draft.content[p.path] = p.after;
    markDirty();
    draw();
    toast(`${chosen.length}칸을 채웠어요`);
  }

  // ───── 칸 새로 고침 (다시 그리지 않고 그 자리만) ─────

  const valueOf = (path) => {
    if (path === '__title') return draft.title || '';
    const v = getAt(draft.content, path);
    if (Array.isArray(v)) return v.map((p) => [p.name, p.role, p.speech, p.first_scene].filter((s) => s && s.trim()).join(' · ')).join('\n');
    return v || '';
  };

  /** 색칠 · 높이 · 고칠 표기 줄 */
  function refreshField(path) {
    const box = $(`[data-nf="${cssEsc(path)}"]`, el);
    const ta = box && $(':scope > .nf-box textarea', box);
    if (!ta) return;
    const value = ta.value;
    $(':scope > .nf-box .nf-hl', box).innerHTML = highlightHtml(value);
    ta.style.height = 'auto';
    ta.style.height = `${ta.scrollHeight + 2}px`;
    const matches = findNotations(value);
    const bad = matches.filter((m) => m.kind === 'invalid');
    const known = variables();
    const unknown = [...new Set(matches.filter((m) => m.kind === 'variable' && !known.includes(m.name)).map((m) => m.name))];
    const checks = fieldChecks(meta, fields[path].limits, value, detailTotal());
    const over = checks.find((c) => c.level === 'over' && c.key !== ROFAN_DETAIL);
    put(
      $(`[data-fix="${cssEsc(path)}"]`, el),
      html`${bad.map(
        (m) => html`<div class="fix"><code class="n-invalid">${m.text}</code> → <code>${m.suggestion}</code>로 바꿀까요? <button type="button" class="linkish" data-fix-one="${path}" data-at="${m.start}">바꾸기</button></div>`,
      )}
      ${bad.length > 1 ? html`<div class="fix"><button type="button" class="linkish" data-fix-all="${path}">모두 고치기 (${bad.length}개)</button></div>` : ''}
      ${unknown.length ? html`<div class="fix soft">변수 카드에 없는 이름: ${unknown.join(', ')} — 변수 카드를 만들면 로플 변수로 이어져요</div>` : ''}
      ${over ? html`<div class="fix bad">${PLATFORM_NAME[over.platform]} ${over.label} 한도를 넘었어요 — 넘친 부분은 플랫폼이 말없이 잘라요</div>` : ''}`,
    );
  }

  /** 칸마다 "로판 1,240/6,000자 · 로플 ≈ 980/2,000토큰" + 막대 + 오른쪽 요약 */
  function refreshCounts() {
    const total = detailTotal();
    const sideRows = [];
    for (const [path, f] of Object.entries(fields)) {
      const checks = fieldChecks(meta, f.limits, valueOf(path), total);
      const countEl = $(`[data-count="${cssEsc(path)}"]`, el);
      if (countEl && f.limits.length) {
        put(countEl, html`${checks.map((c, i) => html`${i ? ' · ' : ''}<span class="lv-${c.level}">${PLATFORM_NAME[c.platform]}${c.key === ROFAN_DETAIL ? ' 합계' : ''} ${c.display}</span>`)}`);
      }
      const bar = $(`[data-bar="${cssEsc(path)}"] i`, el);
      if (bar) {
        const own = checks.filter((c) => c.key !== ROFAN_DETAIL);
        const worst = own.reduce((w, c) => (!w || c.count / c.max > w.count / w.max ? c : w), null);
        bar.style.width = worst ? `${Math.min(100, (worst.count / worst.max) * 100)}%` : '0';
        bar.className = worst ? `lv-${worst.level}` : '';
      }
      for (const c of checks) {
        const detail = c.key === ROFAN_DETAIL;
        if (detail && sideRows.some((r) => r.detail)) continue;
        sideRows.push({ label: detail ? '로판 세부 설정 합계' : labelOf(path), c, detail });
      }
    }
    for (const lc of $$('[data-listcount]', el)) {
      const n = (getAt(draft.content, lc.dataset.listcount) || []).length;
      lc.textContent = `${n}/${lc.dataset.max}개`;
      lc.className = n > Number(lc.dataset.max) ? 'lv-over' : '';
    }
    put(
      $('[data-side-counts]', el),
      sideRows.length
        ? html`<div class="cb-side-counts">${sideRows.map(
            (r) => html`<div><span>${r.label}</span><b class="lv-${r.c.level}">${PLATFORM_NAME[r.c.platform]} ${r.c.display}</b></div>`,
          )}</div>`
        : html`<div class="sub">이 카드엔 글자 수 한도가 있는 칸이 없어요.</div>`,
    );
  }

  const labelOf = (path) => {
    if (path === '__title') return kind === 'character' ? '이름' : '카드 이름';
    const parts = path.split('.');
    const top = form.find((f) => f.path === parts[0]);
    if (parts.length === 1) return top?.label || path;
    const sub = top?.fields?.find((g) => g.path === parts[2]);
    return `${top.label} ${Number(parts[1]) + 1} ${sub?.label || ''}`;
  };

  // ───── 저장 ─────

  const showStatus = () => {
    const s = $('[data-status]', el);
    if (!s) return;
    s.className = `cb-status ${lastError ? 'bad' : dirty ? 'wait' : 'ok'}`;
    s.textContent = lastError ? `저장 안 됨 · ${lastError}` : saving ? '저장 중…' : dirty ? '고치는 중' : '✓ 저장됨';
  };

  const markDirty = () => {
    dirty = true;
    lastError = '';
    clearTimeout(timer);
    timer = setTimeout(save, SAVE_DELAY);
    showStatus();
  };

  async function save() {
    clearTimeout(timer);
    if (saving) return saving.then(() => dirty && save());
    if (!dirty) return;
    dirty = false;
    const body = { title: draft.title, content: draft.content, ...(kind === 'character' ? { source_character_id: draft.source_character_id } : {}) };
    saving = api
      .put(`/api/chatbot/nodes/${nid}`, body)
      .then((saved) => {
        node = saved;
        story.nodes = story.nodes.map((n) => (n.id === nid ? saved : n));
        savedAt = Date.now();
        drawPreview();
      })
      .catch((e) => {
        dirty = true;
        lastError = e.message;
        toast(e.message, 'error');
      })
      .finally(() => {
        saving = null;
        showStatus();
      });
    showStatus();
    return saving;
  }

  // ───── 이벤트 ─────

  function setValue(target) {
    const path = target.dataset.path;
    const type = target.dataset.type;
    const v =
      type === 'int' ? (target.value === '' ? null : Number(target.value))
        : type === 'bool' ? target.checked
          : type === 'list' ? target.value.split(/[,，\n]/).map((s) => s.trim()).filter(Boolean)
            : target.value;
    if (path === '__title') {
      draft.title = v;
      $('[data-h1]', el).textContent = v || meta.kind_labels[kind];
    } else if (path === '__source') draft.source_character_id = v;
    else setAt(draft.content, path, v);
    refreshField(path);
    refreshCounts();
    markDirty();
  }

  /** 입력칸 커서 자리에 글 넣기 */
  function insertAt(ta, text) {
    const { selectionStart: a, selectionEnd: b, value } = ta;
    ta.value = value.slice(0, a) + text + value.slice(b);
    ta.focus();
    ta.selectionStart = ta.selectionEnd = a + text.length;
    setValue(ta);
  }

  /** 줄 목록 칸에서 줄을 더하거나 빼면 그 칸 정의를 찾아 다시 그림 */
  const rowsField = (path) => form.find((f) => f.path === path);

  function bind() {
    const f = $('[data-form]', el);
    f.addEventListener('input', (e) => e.target.dataset.path && setValue(e.target));
    f.addEventListener('change', (e) => e.target.dataset.path && e.target.tagName === 'SELECT' && setValue(e.target));
    f.addEventListener('submit', (e) => e.preventDefault());
    f.addEventListener('click', (e) => {
      const ins = e.target.closest('[data-ins]');
      if (ins) return insertAt($('.nf-box textarea', ins.closest('.nf')), ins.dataset.ins);
      const insVar = e.target.closest('[data-ins-var]');
      if (insVar) {
        e.stopPropagation();
        const names = variables();
        const ta = $('.nf-box textarea', insVar.closest('.nf'));
        if (!names.length) return toast('변수 카드를 먼저 만들어 주세요 (로드맵 → + 변수)', 'error');
        return openMenu(insVar, names.map((n) => ({ label: `{{var_${n}}}`, onClick: () => insertAt(ta, `{{var_${n}}}`) })), { left: true });
      }
      const one = e.target.closest('[data-fix-one]');
      const all = e.target.closest('[data-fix-all]');
      if (one || all) {
        const path = (one || all).dataset.fixOne ?? (one || all).dataset.fixAll;
        const ta = $(`[data-nf="${cssEsc(path)}"] > .nf-box textarea`, el);
        ta.value = fixNotations(ta.value, one ? Number(one.dataset.at) : null);
        return setValue(ta);
      }
      const asset = e.target.closest('[data-asset]');
      if (asset) {
        const path = form.find((x) => x.type === 'asset').path;
        setAt(draft.content, path, asset.dataset.asset ? Number(asset.dataset.asset) : null);
        $$('[data-asset]', el).forEach((b) => b.classList.toggle('on', b === asset));
        return markDirty();
      }
      const add = e.target.closest('[data-row-add]');
      if (add) {
        const rf = rowsField(add.dataset.rowAdd);
        const list = getAt(draft.content, rf.path) || [];
        const count = rf.countLimit ? meta.count_limits[rf.countLimit] : null;
        if (count && list.length >= count.max) return toast(`${count.label}는 ${count.max}개까지예요`, 'error');
        list.push(Object.fromEntries(rf.fields.map((g) => [g.path, g.type === 'int' || g.type === 'character' || g.type === 'node' ? (g.path === 'priority' ? 0 : null) : g.type === 'choice' ? g.values[0][0] : ''])));
        setAt(draft.content, rf.path, list);
        markDirty();
        return draw();
      }
      const del = e.target.closest('[data-row-del]');
      if (del) {
        const list = getAt(draft.content, del.dataset.rowDel) || [];
        list.splice(Number(del.dataset.i), 1);
        markDirty();
        return draw();
      }
    });
    // 입력칸 스크롤과 색칠 층 맞추기 (높이를 늘리므로 거의 없지만 휠·붙여넣기 순간 대비)
    $$('.nf-box textarea', el).forEach((ta) => ta.addEventListener('scroll', () => (ta.previousElementSibling.scrollTop = ta.scrollTop)));

    const fill = $('[data-fill]', el);
    if (fill) fill.onclick = fillFromProfile;
    $('[data-save]', el).onclick = () => (dirty ? save().then(() => !lastError && toast('저장했어요')) : toast('이미 저장돼 있어요'));
    const more = $('[data-more]', el);
    if (more) {
      more.onclick = (e) => {
        e.stopPropagation();
        openMenu(e.currentTarget, [
          { label: node.is_enabled ? '◌ 꺼 두기 (내보낼 때 빼기)' : '● 다시 켜기', onClick: toggle },
          'sep',
          { label: '🗑 카드 지우기', danger: true, onClick: remove },
        ]);
      };
    }
  }

  const toggle = async () => {
    await save();
    node = await attempt(() => api.put(`/api/chatbot/nodes/${nid}`, { is_enabled: !node.is_enabled }), node.is_enabled ? '꺼 뒀어요' : '다시 켰어요');
    draw();
  };

  const remove = async () => {
    if (!(await confirmDialog(`'${draft.title}' 카드를 지울까요?\n지운 카드는 되살릴 수 없어요.`, { okText: '지우기', danger: true }))) return;
    clearTimeout(timer);
    dirty = false;
    await attempt(() => api.del(`/api/chatbot/nodes/${nid}`), '카드를 지웠어요');
    app.navigate(`/chatbot/${story.id}`);
  };

  const onKey = (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 's') {
      e.preventDefault();
      save();
    }
  };
  const onLeave = (e) => {
    if (!dirty && !saving) return;
    save();
    e.preventDefault();
    e.returnValue = '';
  };
  document.addEventListener('keydown', onKey);
  window.addEventListener('beforeunload', onLeave);

  draw();

  // 다른 화면으로 가면: 남은 저장을 바로 보내고 이벤트 정리
  return () => {
    document.removeEventListener('keydown', onKey);
    window.removeEventListener('beforeunload', onLeave);
    if (dirty) save();
  };
}

// ───── 'a.0.b' 같은 경로로 읽고 쓰기 ─────
function getAt(obj, path) {
  return path.split('.').reduce((o, k) => (o == null ? undefined : o[k]), obj);
}
function setAt(obj, path, value) {
  const keys = path.split('.');
  const last = keys.pop();
  keys.reduce((o, k) => o[k], obj)[last] = value;
}
const cssEsc = (s) => (window.CSS?.escape ? CSS.escape(s) : s);
