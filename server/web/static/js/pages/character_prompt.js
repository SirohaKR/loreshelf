// 캐릭터 상세의 "이미지·프롬프트" 탭 — 고정 프롬프트(의상 프리셋), 붙여넣기 → 자동 분류, 생성 기록.
// 분류는 서버(shared/ 패키지)가 하고, 이 화면은 결과를 보여 주고 고치기만 한다.
import { api, assetUrl } from '../api.js';
import { options } from '../parts.js';
import { $, $$, attempt, confirmDialog, formData, html, openMenu, openModal, pickFiles, toast } from '../ui.js';

export const CATEGORY = {
  character: '인물·외형',
  personality: '성격·분위기',
  outfit: '의상',
  props: '소품',
  expression: '표정',
  pose: '포즈·구도',
  background: '배경·조명',
  style: '스타일·화풍',
  quality: '품질',
  etc: '미분류',
};
const COLOR = {
  character: '#3f5bd8', personality: '#0e9aa7', outfit: '#d9822b', props: '#a0662f', expression: '#e0a800',
  pose: '#7c5cd6', background: '#2f9e6b', style: '#d6487a', quality: '#6b7280', etc: '#9aa1ad',
};
// 붙여넣은 프롬프트를 나눌 때 기본 행선지 (shared promptCategoryDefaultTarget과 같게): 정체성은 고정, 장면은 이번만
const DEFAULT_TARGET = {
  character: 'fixed', personality: 'fixed', outfit: 'fixed', style: 'fixed', quality: 'fixed',
  props: 'scene', expression: 'scene', pose: 'scene', background: 'scene', etc: 'scene',
  negative: 'fixed', loras: 'fixed',
};
const TARGET_KEY = 'loreshelf.gen.targets';
const PLATFORM_SHORT = { NovelAI: 'NAI', 'Stable Diffusion WebUI': 'SD', ComfyUI: 'Comfy', Midjourney: 'MJ' };

// ───── 태그 합치기 (shared mergePromptTags와 같은 규칙: 정규화한 글이 같으면 이미 있는 것) ─────
const norm = (s) => String(s).toLowerCase().replaceAll('_', ' ').trim();
/** add 중에서 base에 아직 없는 태그만 */
function newTags(base = {}, add = {}) {
  const seen = new Set(Object.values(base).flat().map((t) => norm(t.tag)));
  const out = {};
  for (const k of Object.keys(CATEGORY)) {
    for (const t of add[k] || []) {
      if (seen.has(norm(t.tag))) continue;
      seen.add(norm(t.tag));
      (out[k] ||= []).push(t);
    }
  }
  return out;
}
const mergeTags = (base = {}, add = {}) => {
  const extra = newTags(base, add);
  return Object.fromEntries(Object.keys(CATEGORY).filter((k) => base[k]?.length || extra[k]).map((k) => [k, [...(base[k] || []), ...(extra[k] || [])]]));
};
const mergeList = (base = [], add = [], key = (x) => norm(x)) => {
  const seen = new Set(base.map(key));
  return [...base, ...add.filter((x) => !seen.has(key(x)) && seen.add(key(x)))];
};
const countTags = (tags) => Object.values(tags).reduce((a, b) => a + b.length, 0);

// ───── 프롬프트 글로 만들기 ─────
const w = (n) => Math.round(n * 100) / 100;
const sdTag = (t) => (t.weight === 1 ? t.tag : `(${t.tag}:${w(t.weight)})`);
const naiTag = (t) => (t.weight === 1 ? t.tag : `${w(t.weight)}::${t.tag}::`);
const orderedTags = (tags, keys = Object.keys(CATEGORY)) => keys.flatMap((k) => tags[k] || []);

/** 태그 묶음 → 붙여넣을 글. format: 'sd' | 'nai' */
export function promptText({ tags = {}, negative = [], loras = [] }, format = 'sd') {
  const list = orderedTags(tags).map(format === 'nai' ? naiTag : sdTag);
  if (format === 'sd') list.push(...loras.map((l) => `<lora:${l.name}:${w(l.weight)}>`));
  let out = list.join(', ');
  if (negative.length) out += `\n${format === 'sd' ? 'Negative prompt: ' : '네거티브: '}${negative.join(', ')}`;
  return out;
}

async function copy(text, what = '복사했어요') {
  try {
    await navigator.clipboard.writeText(text);
    toast(what);
  } catch {
    toast('복사하지 못했어요 (브라우저가 막음)', 'error');
  }
}

const xBtn = (k, i) => html`<button type="button" class="x" data-x="${k}" data-i="${i}" title="이 태그 지우기" aria-label="지우기">✕</button>`;
const tagChip = (t, attrs = '', x = '') => html`<span class="ptag" ${attrs}>${t.tag}${t.weight !== 1 ? html` <b>${w(t.weight)}</b>` : ''}${x}</span>`;
const loraChip = (l) => html`<span class="lora">${l.name} · ${w(l.weight)}</span>`;

/** 칸 이름 아래 "고정 / 이번만" 토글 */
const toggle = (k, targets) =>
  html`<span class="tgl" data-tgl="${k}"><a class="${targets[k] === 'fixed' ? 'on' : ''}" data-to="fixed" title="캐릭터의 고정 프롬프트에 넣기">고정</a><a class="${targets[k] === 'fixed' ? '' : 'on'}" data-to="scene" title="이번 생성 기록에만">이번만</a></span>`;

/**
 * 카테고리별 줄 (복사 버튼 포함).
 * movable: 태그를 눌러 다른 칸으로 옮기기 · del: 칩에 ✕ (data-x=칸, data-i=번호) · targets: 칸마다 고정/이번만 토글
 */
function rows({ tags = {}, negative = [], loras = [] }, { movable = false, del = false, targets = null } = {}) {
  const tg = (k) => (targets ? toggle(k, targets) : '');
  const out = Object.keys(CATEGORY)
    .filter((k) => tags[k]?.length)
    .map(
      (k) => html`<div class="crow"><div class="lb"><i style="--c:${COLOR[k]}"></i>${CATEGORY[k]}${tg(k)}</div>
        <div class="tags">${tags[k].map((t, i) => tagChip(t, movable ? html`data-move="${t.tag}" data-cat="${k}" data-i="${i}" title="눌러서 다른 칸으로 옮기기·지우기" role="button"` : del ? 'data-chip' : '', del ? xBtn(k, i) : ''))}</div>
        <button class="cp" data-copy-cat="${k}" title="이 줄 복사">⧉</button></div>`,
    );
  if (negative.length) {
    out.push(html`<div class="crow"><div class="lb"><i style="--c:#c03d3d"></i>네거티브${tg('negative')}</div>
      <div class="tags">${negative.map((t, i) => html`<span class="ptag neg" ${del ? 'data-chip' : ''}>${t}${del ? xBtn('negative', i) : ''}</span>`)}</div>
      <button class="cp" data-copy-cat="negative" title="이 줄 복사">⧉</button></div>`);
  }
  if (loras.length) {
    out.push(html`<div class="crow"><div class="lb"><i style="--c:#2f9e6b"></i>LoRA${tg('loras')}</div>
      <div class="tags">${loras.map(loraChip)}</div><span></span></div>`);
  }
  return out.length ? out : html`<div class="sub">아직 태그가 없어요</div>`;
}

/** ✕ 누르면 onDelete(칸, 번호). 터치 화면에선 칩을 한 번 누르면 ✕가 보인다 */
function bindChipDelete(root, onDelete) {
  $$('[data-chip]', root).forEach((c) => (c.onclick = () => c.classList.toggle('sel')));
  $$('[data-x]', root).forEach(
    (b) =>
      (b.onclick = (e) => {
        e.stopPropagation();
        onDelete(b.dataset.x, Number(b.dataset.i));
      }),
  );
}

/** {tags, negative}에서 태그 하나를 뺀 새 값 */
function withoutTag(data, k, i) {
  if (k === 'negative') return { negative: data.negative.filter((_, j) => j !== i) };
  const list = (data.tags[k] || []).filter((_, j) => j !== i);
  const tags = { ...data.tags, [k]: list };
  if (!list.length) delete tags[k];
  return { tags };
}

/** 네거티브 세트 버튼 줄. sets = GET /api/gen/negative-sets */
const negSetBar = (sets, manage = true) =>
  html`<div class="negsets"><span class="sub">네거티브 세트</span>${sets.map((s, i) => html`<button type="button" class="btn sm" data-negset="${i}" title="${s.negative.join(', ')}">+ ${s.name}</button>`)}${manage ? html`<button type="button" class="linkish" data-negset-manage>세트 관리</button>` : ''}</div>`;

function bindRowCopy(root, data) {
  $$('[data-copy-cat]', root).forEach(
    (b) =>
      (b.onclick = () => {
        const k = b.dataset.copyCat;
        copy(k === 'negative' ? data.negative.join(', ') : (data.tags[k] || []).map(sdTag).join(', '), `${k === 'negative' ? '네거티브' : CATEGORY[k]} 줄을 복사했어요`);
      }),
  );
}

/** 탭 그리기. el = 탭 본문, c = 캐릭터 */
export async function renderPromptTab(el, c) {
  let presets = [];
  let records = [];
  let platforms = [];
  let presetId = null;
  let filter = '';
  let parsed = null;
  let rawText = '';
  let format = 'sd';
  let negSets = [];
  let defaults = { quality: [], negative: [] }; // 모든 캐릭터 공통 기본값 (GET /api/gen/defaults)
  let dropped = new Set(); // 붙여넣기 결과에서 ✕로 뺀 태그 (글을 고치면 초기화)
  let targets = { ...DEFAULT_TARGET };
  try {
    Object.assign(targets, JSON.parse(localStorage.getItem(TARGET_KEY) || '{}'));
  } catch {
    /* 저장소를 못 쓰면 기본값 */
  }
  const saveTargets = () => {
    try {
      localStorage.setItem(TARGET_KEY, JSON.stringify(targets));
    } catch {
      /* 무시 */
    }
  };

  /** 붙여 넣은 것에서 공통 기본값과 겹치는 태그를 뺀다 (shared stripPromptDefaults와 같은 규칙). removed = 뺀 것 */
  const stripDefaults = ({ tags = {}, negative = [], loras = [] }) => {
    const q = new Set(defaults.quality.map(norm));
    const n = new Set(defaults.negative.map(norm));
    const removed = [];
    const out = {};
    for (const [k, list] of Object.entries(tags)) {
      const kept = list.filter((t) => !(q.has(norm(t.tag)) && removed.push(t.tag)));
      if (kept.length) out[k] = kept;
    }
    const neg = negative.filter((t) => !(n.has(norm(t)) && removed.push(t)));
    return { tags: out, negative: neg, loras, removed };
  };
  /** 복사할 때: 공통 기본 품질은 품질 칸 앞에, 기본 네거티브는 네거티브 앞에 */
  const withDefaults = (d) => ({
    tags: mergeTags(defaults.quality.length ? { quality: defaults.quality.map((tag) => ({ tag, weight: 1 })) } : {}, d.tags),
    negative: mergeList(mergeList([], defaults.negative), d.negative),
    loras: d.loras,
  });
  const removedNote = (removed) =>
    removed.length ? html`<div class="sub" style="margin-top:6px" title="${removed.join(', ')}">공통 기본값과 겹쳐서 뺐어요: ${removed.join(', ')}</div>` : '';

  const load = async () => {
    [presets, records, platforms, negSets, defaults] = await Promise.all([
      api.get(`/api/characters/${c.id}/gen-presets`),
      api.get(`/api/characters/${c.id}/gen-records`),
      api.get('/api/gen/platforms'),
      api.get('/api/gen/negative-sets'),
      api.get('/api/gen/defaults'),
    ]);
    if (!presets.some((p) => p.id === presetId)) presetId = presets[0]?.id ?? null;
  };

  const draw = () => {
    el.innerHTML = html`<div class="wrap2">
      <div class="grid">
        <div class="card" data-preset-card>${presetCard()}</div>
        <div class="card" data-def-card>${defaultsCard()}</div>
        <div class="card" data-parse-card>${parseCard()}</div>
      </div>
      <div class="card" data-rec-card>${recordCard()}</div>
    </div>`.s;
    bindPreset();
    bindDefaults();
    bindParse();
    bindRecords();
  };

  // ───── 고정 프롬프트 ─────
  const presetCard = () => {
    const p = presets.find((x) => x.id === presetId);
    return html`<div class="card-h">
        <div><h2>고정 프롬프트</h2><div class="sub">이 캐릭터를 그릴 때 항상 넣는 부분 · 의상별로 여러 개</div></div>
        <div class="seg">${presets.map((x) => html`<a class="${x.id === presetId ? 'on' : ''}" data-preset="${x.id}">${x.name}</a>`)}<a data-preset-new title="새 고정 프롬프트">+</a></div>
      </div>
      ${p
        ? html`${rows(p, { del: true })}
          <div class="sub" style="margin-top:8px">전체 복사에는 아래 공통 기본값(품질 ${defaults.quality.length}개 · 네거티브 ${defaults.negative.length}개)이 함께 붙어요.</div>
          <div class="acts">
            <div class="seg"><a class="${format === 'sd' ? 'on' : ''}" data-format="sd">SD 형식</a><a class="${format === 'nai' ? 'on' : ''}" data-format="nai">NovelAI 형식</a></div>
            <span class="menu-wrap"><button class="btn" data-preset-more>⋯</button></span>
            <button class="btn" data-preset-edit>✎ 고치기</button>
            <button class="btn pri" data-preset-copy>⧉ 전체 복사</button>
          </div>`
        : html`<div class="empty-state" style="padding:24px 10px"><b>고정 프롬프트가 없어요</b>기본 외형, 전투복, 평상복처럼 의상별로 만들어 두면 복사해서 바로 써요.<br><button class="btn pri" data-preset-new>+ 고정 프롬프트 만들기</button></div>`}`;
  };

  const bindPreset = () => {
    const card = $('[data-preset-card]', el);
    const p = presets.find((x) => x.id === presetId);
    $$('[data-preset]', card).forEach((a) => (a.onclick = () => ((presetId = Number(a.dataset.preset)), draw())));
    $$('[data-preset-new]', card).forEach((a) => (a.onclick = () => editPreset(null)));
    $$('[data-format]', card).forEach((a) => (a.onclick = () => ((format = a.dataset.format), draw())));
    if (!p) return;
    bindRowCopy(card, p);
    bindChipDelete(card, async (k, i) => {
      const removed = k === 'negative' ? p.negative[i] : p.tags[k][i].tag;
      await attempt(() => api.put(`/api/gen/presets/${p.id}`, withoutTag(p, k, i)), `'${removed}'을(를) 고정 프롬프트에서 뺐어요`);
      await load();
      draw();
    });
    $('[data-preset-copy]', card).onclick = () => copy(promptText(withDefaults(p), format), `${format === 'sd' ? 'SD' : 'NovelAI'} 형식으로 복사했어요`);
    $('[data-preset-edit]', card).onclick = () => editPreset(p);
    $('[data-preset-more]', card).onclick = (e) => {
      e.stopPropagation();
      openMenu(e.currentTarget, [
        { label: '이름 바꾸기', onClick: () => renamePreset(p) },
        { label: '지우기', danger: true, onClick: () => deletePreset(p) },
      ]);
    };
  };

  /** 고정 프롬프트 만들기·고치기: 프롬프트 글을 붙여넣으면 서버가 나눠서 저장 */
  const editPreset = async (p) => {
    const saved = await openModal(
      html`<h2>${p ? `고정 프롬프트 고치기 · ${p.name}` : '새 고정 프롬프트'}</h2>
      <form data-f class="grid" style="gap:10px">
        <label class="f">이름 <input type="text" name="name" maxlength="60" required value="${p?.name ?? (presets.length ? '' : '기본 외형')}" placeholder="기본 외형, 전투복 …"></label>
        <label class="f">프롬프트 <textarea class="raw" name="text" placeholder="1girl, silver hair, (red eyes:1.2), silver armor, &lt;lora:이름:0.8&gt;&#10;Negative prompt: lowres, bad hands">${p ? promptText(p, 'sd') : ''}</textarea></label>
        <div class="hint">쉼표로 나눈 태그를 저장할 때 자동으로 분류해요. 가중치는 (tag:1.2), LoRA는 &lt;lora:이름:0.8&gt;, 네거티브는 "Negative prompt:" 줄에. LoRA는 <a href="#/gen">생성 도구</a> 목록에 있는 것만 들어가요.</div>
        <div class="acts"><button type="button" class="btn" data-no>취소</button><button class="btn pri">저장</button></div>
      </form>`,
      (m, close) => {
        m.classList.add('wide');
        $('[data-no]', m).onclick = () => close(undefined);
        $('[data-f]', m).onsubmit = async (e) => {
          e.preventDefault();
          const f = formData(e.target);
          try {
            const parsedText = await api.post('/api/gen/parse', { text: f.text });
            const r = { ...stripDefaults({ tags: parsedText.categories, negative: parsedText.negative }), loras: parsedText.loras };
            r.categories = r.tags;
            const known = new Set((await api.get('/api/gen/loras')).map((l) => l.name.toLowerCase()));
            const skipped = r.loras.filter((l) => !known.has(l.name.toLowerCase()));
            const body = { name: f.name, tags: r.categories, negative: r.negative, loras: r.loras.filter((l) => known.has(l.name.toLowerCase())) };
            const out = p ? await api.put(`/api/gen/presets/${p.id}`, body) : await api.post(`/api/characters/${c.id}/gen-presets`, body);
            if (skipped.length) toast(`목록에 없는 LoRA는 빼고 저장했어요: ${skipped.map((l) => l.name).join(', ')}`, 'error');
            if (r.removed.length) toast(`공통 기본값과 겹치는 ${r.removed.length}개는 빼고 저장했어요`);
            close(out);
          } catch (err) {
            toast(err.message, 'error');
          }
        };
      },
    );
    if (!saved) return;
    toast('고정 프롬프트를 저장했어요');
    presetId = saved.id;
    await load();
    draw();
  };

  const renamePreset = async (p) => {
    const name = await openModal(
      html`<h2>이름 바꾸기</h2><input type="text" data-n maxlength="60" value="${p.name}">
      <div class="acts"><button class="btn" data-no>취소</button><button class="btn pri" data-yes>바꾸기</button></div>`,
      (m, close) => {
        $('[data-no]', m).onclick = () => close(undefined);
        $('[data-yes]', m).onclick = () => close($('[data-n]', m).value);
      },
    );
    if (name === undefined) return;
    await attempt(() => api.put(`/api/gen/presets/${p.id}`, { name }), '이름을 바꿨어요');
    await load();
    draw();
  };

  const deletePreset = async (p) => {
    if (!(await confirmDialog(`고정 프롬프트 '${p.name}'을(를) 지울까요?\n휴지통에 남지 않아요. 이 프리셋으로 만든 생성 기록은 남아요.`, { okText: '지우기', danger: true }))) return;
    await attempt(() => api.del(`/api/gen/presets/${p.id}`), '지웠어요');
    await load();
    draw();
  };

  // ───── 모든 캐릭터 공통 기본값 (품질·네거티브) ─────
  const defaultsCard = () => html`<div class="card-h"><div><h2>모든 캐릭터 공통 기본값</h2>
      <div class="sub">높은 품질을 위해 늘 넣는 품질 태그·네거티브예요. 복사할 때 자동으로 합쳐지고, 붙여 넣을 때 겹치는 태그는 캐릭터 쪽에서 빠져요.</div></div></div>
    ${rows({ tags: defaults.quality.length ? { quality: defaults.quality.map((tag) => ({ tag, weight: 1 })) } : {}, negative: defaults.negative }, { del: true })}
    <form data-def-add class="def-add">
      <select name="to"><option value="quality">품질에</option><option value="negative">네거티브에</option></select>
      <input type="text" name="text" maxlength="2000" placeholder="태그 추가 (쉼표로 나눠서)">
      <button class="btn sm">추가</button>
    </form>
    ${negSetBar(negSets)}`;

  const bindDefaults = () => {
    const card = $('[data-def-card]', el);
    const save = async (body, done) => {
      defaults = await attempt(() => api.put('/api/gen/defaults', body), done);
      draw();
    };
    bindRowCopy(card, { tags: { quality: defaults.quality.map((tag) => ({ tag, weight: 1 })) }, negative: defaults.negative });
    bindChipDelete(card, (k, i) =>
      k === 'negative'
        ? save({ negative: defaults.negative.filter((_, j) => j !== i) }, `'${defaults.negative[i]}'을(를) 기본 네거티브에서 뺐어요`)
        : save({ quality: defaults.quality.filter((_, j) => j !== i) }, `'${defaults.quality[i]}'을(를) 기본 품질에서 뺐어요`),
    );
    $('[data-def-add]', card).onsubmit = (e) => {
      e.preventDefault();
      const f = formData(e.target);
      const add = f.text.split(/[,\n]/).map((t) => t.trim()).filter(Boolean);
      if (!add.length) return;
      const to = f.to === 'negative' ? 'negative' : 'quality';
      save({ [to]: mergeList(defaults[to], add) }, to === 'negative' ? '기본 네거티브에 넣었어요' : '기본 품질에 넣었어요');
    };
    bindNegSets(card, (set) => {
      const negative = mergeList(defaults.negative, set.negative);
      if (negative.length === defaults.negative.length) return toast('이미 다 들어 있어요');
      save({ negative }, `네거티브 '${set.name}' 세트를 기본값에 넣었어요`);
    });
  };

  // ───── 붙여넣기 → 자동 분류 ─────
  const parseCard = () => html`<div class="card-h">
      <div><h2>프롬프트 붙여넣기 → 자동 분류</h2><div class="sub">WebUI·Forge 생성 정보 통째로, NovelAI 태그, Midjourney 명령어 모두 돼요</div></div>
    </div>
    <textarea class="raw" data-raw placeholder="여기에 프롬프트를 붙여넣어요">${rawText}</textarea>
    <div data-parsed>${parsedView()}</div>`;

  /** 붙여넣은 결과에서 ✕로 뺀 태그를 빼고 */
  const current = () => {
    const tags = {};
    for (const [k, list] of Object.entries(parsed.categories)) {
      const kept = list.filter((t) => !dropped.has(norm(t.tag)));
      if (kept.length) tags[k] = kept;
    }
    return { tags, negative: parsed.negative.filter((t) => !dropped.has(`neg:${norm(t)}`)), loras: parsed.loras };
  };

  const parsedView = () => {
    if (!parsed || !rawText.trim()) return '';
    const d = stripDefaults(current());
    return html`<div class="detect">감지된 플랫폼 <span class="chip a">${parsed.platform || '알 수 없음'}</span> 태그 ${countTags(d.tags)}개 · LoRA ${d.loras.length}개 · 네거티브 ${d.negative.length}개</div>
      <div class="parsed">${rows(d, { movable: true, del: true, targets })}</div>
      ${removedNote(d.removed)}
      ${Object.keys(parsed.settings).length ? html`<div class="settings">${Object.entries(parsed.settings).map(([k, v]) => html`<div><small>${k}</small><span title="${v}">${v}</span></div>`)}</div>` : ''}
      <div class="hint">칸 이름 아래에서 <b>고정</b>(캐릭터의 고정 프롬프트)과 <b>이번만</b>(이번 생성 기록)을 골라요. 태그를 누르면 다른 칸으로 옮기거나 지울 수 있고, 옮긴 태그는 내 사전에 기억돼서 다음부터 자동으로 그 칸에 들어가요.</div>
      <div class="acts">
        <button class="btn" data-to-record title="나누지 않고 전부 생성 기록으로">통째로 생성 기록</button>
        <button class="btn pri" data-split>고정 / 이번만 나눠서 저장</button>
      </div>`;
  };

  const redrawParsed = () => {
    const box = $('[data-parsed]', el);
    if (!box) return;
    box.innerHTML = parsedView().s ?? '';
    bindParsed();
  };

  let timer = 0;
  const reparse = async () => {
    if (!rawText.trim()) {
      parsed = null;
    } else {
      try {
        parsed = await api.post('/api/gen/parse', { text: rawText });
      } catch (e) {
        toast(e.message, 'error');
        return;
      }
    }
    redrawParsed();
  };

  const bindParse = () => {
    $('[data-raw]', el).oninput = (e) => {
      rawText = e.target.value;
      dropped = new Set();
      clearTimeout(timer);
      timer = setTimeout(reparse, 300);
    };
    bindParsed();
  };

  const bindParsed = () => {
    const box = $('[data-parsed]', el);
    if (!box || !parsed || !rawText.trim()) return;
    const d = stripDefaults(current());
    const drop = (k, i) => {
      dropped.add(k === 'negative' ? `neg:${norm(d.negative[i])}` : norm(d.tags[k][i].tag));
      redrawParsed();
    };
    bindRowCopy(box, d);
    bindChipDelete(box, drop);
    $$('[data-tgl] a', box).forEach(
      (a) =>
        (a.onclick = () => {
          targets[a.parentElement.dataset.tgl] = a.dataset.to;
          saveTargets();
          redrawParsed();
        }),
    );
    $$('[data-move]', box).forEach((t) => {
      t.classList.add('menu-wrap');
      t.onclick = (e) => {
        e.stopPropagation();
        openMenu(t, [
          ...Object.entries(CATEGORY)
            .filter(([k]) => k !== t.dataset.cat)
            .map(([k, label]) => ({
              label: `→ ${label}`,
              onClick: async () => {
                await attempt(() => api.post('/api/gen/tag-rules', { tag: t.dataset.move, category: k }), `'${t.dataset.move}'은(는) 이제 ${label}`);
                reparse();
              },
            })),
          'sep',
          { label: '✕ 이 태그 지우기', danger: true, onClick: () => drop(t.dataset.cat, Number(t.dataset.i)) },
        ]);
      };
    });
    $('[data-split]', box).onclick = () => splitSave(d);
    $('[data-to-record]', box).onclick = () => saveRecord(null, recordFromParsed(d));
  };

  /** 붙여넣은 것을 칸마다 고른 대로 나눠서: 고정 → 고른 고정 프롬프트에 (이미 있는 태그는 빼고) 추가, 이번만 → 생성 기록 */
  const splitSave = async (d) => {
    const keys = Object.keys(CATEGORY).filter((k) => d.tags[k]);
    const fixedTags = Object.fromEntries(keys.filter((k) => targets[k] === 'fixed').map((k) => [k, d.tags[k]]));
    const sceneTags = Object.fromEntries(keys.filter((k) => targets[k] !== 'fixed').map((k) => [k, d.tags[k]]));
    const negFixed = targets.negative === 'fixed';
    const loraFixed = targets.loras === 'fixed';
    const known = new Set((await api.get('/api/gen/loras')).map((l) => l.name.toLowerCase()));
    const loraKey = (l) => l.name.toLowerCase();
    // 고정 쪽 LoRA는 목록에 있는 것만 들어가니, 목록에 없는 건 생성 기록에 남긴다
    const fixedLoras = loraFixed ? d.loras.filter((l) => known.has(loraKey(l))) : [];
    const sceneLoras = d.loras.filter((l) => !fixedLoras.includes(l));
    const sceneNeg = negFixed ? [] : d.negative;

    const adds = (p) => ({
      tags: newTags(p?.tags, fixedTags),
      negative: negFixed ? mergeList(p?.negative ?? [], d.negative).slice(p?.negative.length ?? 0) : [],
      loras: mergeList(p?.loras ?? [], fixedLoras, loraKey).slice(p?.loras.length ?? 0),
    });
    const preview = (p) => {
      const a = adds(p);
      const n = countTags(a.tags) + a.negative.length + a.loras.length;
      const skipped = countTags(fixedTags) - countTags(a.tags) + (negFixed ? d.negative.length - a.negative.length : 0);
      const sceneN = countTags(sceneTags) + sceneNeg.length + sceneLoras.length;
      return html`<div class="split-box"><h3>${p ? `고정 프롬프트 '${p.name}'에 추가돼요` : '새 고정 프롬프트에 들어가요'} · ${n}개</h3>
          ${n ? rows(a) : html`<div class="sub">새로 추가할 태그가 없어요</div>`}
          ${skipped ? html`<div class="sub" style="margin-top:6px">이미 들어 있는 ${skipped}개는 건너뛰어요</div>` : ''}</div>
        ${removedNote(d.removed)}
        <div class="split-box"><h3>이번 생성 기록에 들어가요 · ${sceneN}개</h3>
          ${sceneN ? rows({ tags: sceneTags, negative: sceneNeg, loras: sceneLoras }) : html`<div class="sub">장면 태그가 없어요</div>`}</div>`;
    };
    const choice = await openModal(
      html`<h2>고정 / 이번만 나눠서 저장</h2>
      <label class="f">고정 프롬프트 <select data-p>${options(presets.map((p) => [p.id, p.name]), presetId)}<option value="">+ 새 고정 프롬프트</option></select></label>
      <input type="text" data-n maxlength="60" placeholder="새 고정 프롬프트 이름" value="${presets.length ? '' : '기본 외형'}" style="margin-top:8px">
      <div data-preview></div>
      <label class="check" style="margin-top:10px"><input type="checkbox" data-rec checked> 이번 생성 기록도 저장 (다음 창에서 제목·이미지 정보 확인)</label>
      <div class="acts"><button class="btn" data-no>취소</button><button class="btn pri" data-yes>확인하고 저장</button></div>`,
      (m, close) => {
        m.classList.add('wide');
        const sel = $('[data-p]', m);
        const name = $('[data-n]', m);
        const sync = () => {
          name.style.display = sel.value ? 'none' : '';
          $('[data-preview]', m).innerHTML = preview(presets.find((p) => p.id === Number(sel.value))).s;
        };
        sel.onchange = sync;
        sync();
        $('[data-no]', m).onclick = () => close(undefined);
        $('[data-yes]', m).onclick = () => close({ id: sel.value ? Number(sel.value) : null, name: name.value.trim(), rec: $('[data-rec]', m).checked });
      },
    );
    if (!choice) return;
    const p = presets.find((x) => x.id === choice.id);
    const out = p
      ? await attempt(
          () =>
            api.put(`/api/gen/presets/${p.id}`, {
              tags: mergeTags(p.tags, fixedTags),
              negative: negFixed ? mergeList(p.negative, d.negative) : p.negative,
              loras: mergeList(p.loras, fixedLoras, loraKey),
            }),
          `고정 프롬프트 '${p.name}'에 넣었어요`,
        )
      : await attempt(
          () => api.post(`/api/characters/${c.id}/gen-presets`, { name: choice.name || '새 고정 프롬프트', tags: fixedTags, negative: negFixed ? d.negative : [], loras: fixedLoras }),
          '고정 프롬프트를 만들었어요',
        );
    if (!out) return;
    presetId = out.id;
    await load();
    draw();
    if (choice.rec) saveRecord(null, recordFromParsed({ tags: sceneTags, negative: sceneNeg, loras: sceneLoras }));
  };

  /** 네거티브 세트 버튼 연결 */
  const bindNegSets = (root, onPick) => {
    $$('[data-negset]', root).forEach((b) => (b.onclick = () => onPick(negSets[Number(b.dataset.negset)])));
    const manage = $('[data-negset-manage]', root);
    if (manage) manage.onclick = manageNegSets;
  };

  /** 내 네거티브 세트 만들기·고치기·지우기 (기본 세트는 고칠 수 없음) */
  const manageNegSets = async () => {
    await openModal(
      html`<h2>네거티브 세트 관리</h2>
      <div class="sub">기본 세트는 고칠 수 없어요. 내 세트를 만들어 두면 고정 프롬프트·생성 기록에서 눌러서 넣을 수 있어요.</div>
      <div class="gen-list" data-list style="margin-top:8px"></div>
      <form data-f class="grid" style="gap:8px;margin-top:10px">
        <label class="f">세트 이름 <input type="text" name="name" maxlength="60" required placeholder="내 세트"></label>
        <label class="f">태그 (쉼표로 나눠서) <textarea name="negative" placeholder="nsfw, extra ears"></textarea></label>
        <div class="acts"><button type="button" class="btn" data-no>닫기</button><button type="button" class="btn" data-reset>새 세트</button><button class="btn pri" data-save>세트 저장</button></div>
      </form>`,
      (m, close) => {
        const f = $('[data-f]', m);
        let editing = null;
        const reset = () => {
          editing = null;
          f.reset();
          $('[data-save]', m).textContent = '세트 저장';
        };
        const paint = () => {
          $('[data-list]', m).innerHTML = html`${negSets.map(
            (s, i) => html`<div class="item"><div class="grow"><b>${s.name}</b>${s.builtin ? html` <span class="chip">기본</span>` : ''}<div class="sub" title="${s.negative.join(', ')}">${s.negative.join(', ')}</div></div>
              ${s.builtin ? '' : html`<button type="button" class="btn sm" data-edit="${i}">고치기</button><button type="button" class="btn sm danger" data-del="${i}">지우기</button>`}</div>`,
          )}`.s;
          $$('[data-edit]', m).forEach(
            (b) =>
              (b.onclick = () => {
                editing = negSets[Number(b.dataset.edit)];
                f.elements.name.value = editing.name;
                f.elements.negative.value = editing.negative.join(', ');
                $('[data-save]', m).textContent = '고친 내용 저장';
              }),
          );
          $$('[data-del]', m).forEach(
            (b) =>
              (b.onclick = async () => {
                const s = negSets[Number(b.dataset.del)];
                if (!(await attempt(() => api.del(`/api/gen/negative-sets/${s.id}`), `'${s.name}' 세트를 지웠어요`))) return;
                negSets = await api.get('/api/gen/negative-sets');
                if (editing?.id === s.id) reset();
                paint();
              }),
          );
        };
        paint();
        $('[data-no]', m).onclick = () => close(undefined);
        $('[data-reset]', m).onclick = reset;
        f.onsubmit = async (e) => {
          e.preventDefault();
          const body = { name: f.elements.name.value, negative: f.elements.negative.value };
          const ok = editing
            ? await attempt(() => api.put(`/api/gen/negative-sets/${editing.id}`, body), '세트를 고쳤어요')
            : await attempt(() => api.post('/api/gen/negative-sets', body), '세트를 만들었어요');
          if (!ok) return;
          negSets = await api.get('/api/gen/negative-sets');
          reset();
          paint();
        };
      },
    );
    draw();
  };

  const recordFromParsed = (d) => {
    const s = parsed.settings;
    const size = /^(\d+)\s*x\s*(\d+)$/.exec(s.Size || '');
    const platform = parsed.platform && parsed.platform !== '알 수 없음' ? parsed.platform : '';
    return {
      platform,
      model: s.Model || (s['--niji'] ? `niji ${s['--niji']}` : s['--v'] ? `v${s['--v']}` : ''),
      prompt_raw: rawText,
      tags: d.tags,
      negative: d.negative,
      loras: d.loras,
      seed: s.Seed ?? s['--seed'] ?? '',
      steps: s.Steps ?? '',
      sampler: s.Sampler ?? '',
      cfg_scale: s['CFG scale'] ?? '',
      width: size?.[1] ?? '',
      height: size?.[2] ?? '',
      extra: Object.fromEntries(Object.entries(s).filter(([k]) => !['Seed', 'Steps', 'Sampler', 'CFG scale', 'Size', 'Model', '--seed'].includes(k))),
      gen_preset_id: presetId,
    };
  };

  // ───── 생성 기록 ─────
  /** 기록 + 그 기록의 고정 프롬프트 (고정 쪽 태그가 앞, 겹치는 태그는 한 번만). 고정이 없으면 기록 그대로 */
  const withPreset = (r) => {
    const p = presets.find((x) => x.id === r.gen_preset_id);
    if (!p) return r;
    return {
      tags: mergeTags(p.tags, r.tags),
      negative: mergeList(p.negative, r.negative),
      loras: mergeList(p.loras, r.loras, (l) => l.name.toLowerCase()),
    };
  };

  const recordCard = () => {
    const shown = filter ? records.filter((r) => r.platform_name === filter) : records;
    const used = [...new Set(records.map((r) => r.platform_name).filter(Boolean))];
    return html`<div class="card-h"><h2>생성 기록 <span class="chip">${records.length}</span></h2>
        ${used.length > 1 ? html`<div class="seg"><a class="${filter ? '' : 'on'}" data-filter="">전체</a>${used.map((p) => html`<a class="${filter === p ? 'on' : ''}" data-filter="${p}">${PLATFORM_SHORT[p] || p}</a>`)}</div>` : ''}</div>
      <div class="drop" data-drop>이미지를 끌어다 놓거나 <button class="linkish" data-pick>골라서 올리면</button> PNG 안의 생성 정보를 자동으로 읽어요</div>
      <div class="acts" style="margin:0 0 6px"><button class="btn sm" data-rec-new>+ 직접 기록</button></div>
      ${shown.length ? shown.map(recordRow) : html`<div class="sub" style="padding:12px 0">아직 기록이 없어요</div>`}`;
  };

  const recordRow = (r) => html`<div class="rec" data-rec="${r.id}" role="button" title="눌러서 보기·고치기">
      <div class="pt ${r.asset_id ? 'img' : ''}">${r.asset_id ? html`<img src="${assetUrl(r.asset_id)}" alt="" loading="lazy">` : ''}${r.is_cover ? html`<span class="star">★ 대표</span>` : ''}</div>
      <div style="min-width:0">
        <b>${r.title || r.preset_name || '제목 없음'}</b> <span class="chip">${(r.created_at || '').slice(5, 10).replace('-', '/')}</span>
        <dl class="kv rk">
          <dt>플랫폼</dt><dd>${r.platform_name || '—'}</dd>
          <dt>모델</dt><dd>${r.model_name || '—'}</dd>
          ${r.loras.length ? html`<dt>LoRA</dt><dd>${r.loras.map((l) => html`<span class="lora">${l.name} ${w(l.weight)}</span>`)}</dd>` : ''}
          <dt>시드</dt><dd>${[r.seed, r.sampler, r.steps && `${r.steps}스텝`].filter((x) => x != null && x !== '').join(' · ') || '—'}</dd>
        </dl>
      </div>
    </div>`;

  const bindRecords = () => {
    const card = $('[data-rec-card]', el);
    $$('[data-filter]', card).forEach((a) => (a.onclick = () => ((filter = a.dataset.filter), draw())));
    $$('[data-rec]', card).forEach((row) => (row.onclick = () => openRecord(records.find((r) => r.id === Number(row.dataset.rec)))));
    $('[data-rec-new]', card).onclick = () => saveRecord(null, { gen_preset_id: presetId });
    $('[data-pick]', card).onclick = async () => importFiles(await pickFiles({ multiple: true }));
    const drop = $('[data-drop]', card);
    drop.ondragover = (e) => {
      e.preventDefault();
      drop.classList.add('over');
    };
    drop.ondragleave = () => drop.classList.remove('over');
    drop.ondrop = (e) => {
      e.preventDefault();
      drop.classList.remove('over');
      importFiles([...e.dataTransfer.files].filter((f) => f.type.startsWith('image/')));
    };
  };

  /** 이미지 올리기 → 생성 정보 읽기 → 기록 만들기 (정보가 없으면 이미지만) */
  const importFiles = async (files) => {
    if (!files.length) return;
    let withInfo = 0;
    let plain = 0;
    for (const f of files) {
      try {
        const a = await api.upload(f);
        const { info } = await api.get(`/api/gen/png-info/${a.id}`);
        const body = { asset_id: a.id, title: f.name.replace(/\.\w+$/, ''), gen_preset_id: presetId };
        if (info) {
          Object.assign(body, {
            platform: info.platform,
            model: info.model,
            prompt_raw: info.prompt_raw,
            ...(({ tags, negative }) => ({ tags, negative }))(stripDefaults({ tags: info.parsed.categories, negative: info.parsed.negative })),
            loras: info.parsed.loras,
            seed: info.seed,
            steps: info.steps,
            sampler: info.sampler,
            cfg_scale: info.cfg_scale,
            width: info.width,
            height: info.height,
            extra: info.extra,
          });
          withInfo++;
        } else plain++;
        await api.post(`/api/characters/${c.id}/gen-records`, body);
      } catch (e) {
        toast(`${f.name}: ${e.message}`, 'error');
      }
    }
    if (withInfo) toast(`${withInfo}장의 생성 정보를 읽어서 기록했어요`);
    if (plain) toast(`${plain}장은 생성 정보가 없어서 이미지만 기록했어요. 눌러서 채워 주세요`);
    await load();
    draw();
  };

  /** 기록 보기 (원문 프롬프트, 분류, 복사) */
  const openRecord = async (r) => {
    const act = await openModal(
      html`<div class="rec-detail">
        ${r.asset_id ? html`<a href="${assetUrl(r.asset_id, false)}" target="_blank" rel="noopener"><img src="${assetUrl(r.asset_id)}" alt=""></a>` : ''}
        <div style="min-width:0">
          <h2>${r.title || '제목 없음'}${r.is_cover ? html` <span class="chip warn">★ 대표</span>` : ''}</h2>
          <dl class="kv">
            <dt>플랫폼</dt><dd>${r.platform_name || '—'}</dd><dt>모델</dt><dd>${r.model_name || '—'}</dd>
            <dt>시드</dt><dd>${r.seed ?? '—'}</dd><dt>샘플러</dt><dd>${[r.sampler, r.steps && `${r.steps}스텝`, r.cfg_scale != null && `CFG ${r.cfg_scale}`].filter(Boolean).join(' · ') || '—'}</dd>
            <dt>크기</dt><dd>${r.width && r.height ? `${r.width}×${r.height}` : '—'}</dd>
            ${r.preset_name ? html`<dt>고정</dt><dd>${r.preset_name}</dd>` : ''}
            ${Object.keys(r.extra).filter((k) => k !== 'workflow').length ? html`<dt>그 밖에</dt><dd>${Object.entries(r.extra).filter(([k]) => k !== 'workflow').map(([k, v]) => `${k}: ${typeof v === 'object' ? JSON.stringify(v) : v}`).join('\n')}</dd>` : ''}
            ${r.extra.workflow ? html`<dt>워크플로</dt><dd>ComfyUI 워크플로 보관됨 <button class="btn sm" data-wf>⧉ 복사</button></dd>` : ''}
            ${r.note ? html`<dt>메모</dt><dd>${r.note}</dd>` : ''}
          </dl>
        </div>
      </div>
      <div style="margin-top:12px">${rows(r, { del: true })}</div>
      <div class="hint">프롬프트를 복사하면 ${withPreset(r) !== r ? `고정 프롬프트 '${r.preset_name}'와 ` : ''}공통 기본값이 앞에 합쳐져요 (겹치는 태그는 한 번만).</div>
      ${r.prompt_raw ? html`<details style="margin-top:10px"><summary class="sub">원문 프롬프트</summary><pre class="raw-pre">${r.prompt_raw}</pre></details>` : ''}
      <div class="acts">
        <button class="btn danger" data-act="del">지우기</button>
        ${r.is_cover ? '' : html`<button class="btn" data-act="cover">★ 대표로</button>`}
        <button class="btn" data-act="copy">⧉ 프롬프트 복사</button>
        <button class="btn pri" data-act="edit">✎ 고치기</button>
      </div>`,
      (m, close) => {
        m.classList.add('wide');
        bindRowCopy(m, r);
        bindChipDelete(m, async (k, i) => {
          await attempt(() => api.put(`/api/gen/records/${r.id}`, withoutTag(r, k, i)), '태그를 뺐어요');
          close('refresh');
        });
        const wf = $('[data-wf]', m);
        if (wf) wf.onclick = () => copy(String(r.extra.workflow), '워크플로 JSON을 복사했어요');
        $$('[data-act]', m).forEach((b) => (b.onclick = () => close(b.dataset.act)));
      },
    );
    if (act === 'refresh') {
      await load();
      draw();
      const again = records.find((x) => x.id === r.id);
      if (again) openRecord(again);
    }
    if (act === 'copy') copy(promptText(withDefaults(withPreset(r)), 'sd'));
    if (act === 'edit') saveRecord(r, r);
    if (act === 'cover') {
      await attempt(() => api.put(`/api/gen/records/${r.id}`, { is_cover: true }), '대표 이미지로 정했어요');
      await load();
      draw();
    }
    if (act === 'del') {
      if (!(await confirmDialog('이 생성 기록을 지울까요?\n휴지통에 남지 않아요. 올린 이미지 파일은 남아요.', { okText: '지우기', danger: true }))) return;
      await attempt(() => api.del(`/api/gen/records/${r.id}`), '지웠어요');
      await load();
      draw();
    }
  };

  /** 기록 만들기·고치기 폼. rec = 고칠 기록(null이면 새로), v = 처음 채울 값 */
  const saveRecord = async (rec, v) => {
    const platformName = rec ? rec.platform_name : v.platform;
    const modelName = rec ? rec.model_name : v.model;
    const allModels = [...new Set(platforms.flatMap((p) => p.models.map((m) => m.name)))];
    const tagsText = v.tags ? promptText({ tags: v.tags, negative: v.negative || [], loras: v.loras || [] }, 'sd') : '';
    const out = await openModal(
      html`<h2>${rec ? '생성 기록 고치기' : '생성 기록 저장'}</h2>
      <form data-f class="form-grid">
        <label class="f full">제목 <input type="text" name="title" maxlength="120" value="${v.title ?? ''}" placeholder="전투복 · 노을 폐허"></label>
        <label class="f">플랫폼 <input type="text" name="platform" list="dl-platforms" maxlength="60" value="${platformName ?? ''}"></label>
        <label class="f">모델 <input type="text" name="model" list="dl-models" maxlength="120" value="${modelName ?? ''}"></label>
        <label class="f">시드 <input type="text" name="seed" inputmode="numeric" value="${v.seed ?? ''}"></label>
        <label class="f">샘플러 <input type="text" name="sampler" maxlength="120" value="${v.sampler ?? ''}"></label>
        <label class="f">스텝 <input type="text" name="steps" inputmode="numeric" value="${v.steps ?? ''}"></label>
        <label class="f">CFG <input type="text" name="cfg_scale" inputmode="decimal" value="${v.cfg_scale ?? ''}"></label>
        <label class="f">가로 <input type="text" name="width" inputmode="numeric" value="${v.width ?? ''}"></label>
        <label class="f">세로 <input type="text" name="height" inputmode="numeric" value="${v.height ?? ''}"></label>
        <label class="f full">고정 프롬프트 <select name="gen_preset_id"><option value="">없음</option>${options(presets.map((p) => [p.id, p.name]), v.gen_preset_id)}</select></label>
        <label class="f full">프롬프트 (분류해서 저장) <textarea class="raw" name="text">${tagsText}</textarea></label>
        <label class="f full">메모 <textarea name="note" maxlength="5000">${v.note ?? ''}</textarea></label>
        <label class="full check"><input type="checkbox" name="is_cover" ${v.is_cover ? 'checked' : ''}> ★ 이 캐릭터의 대표 생성 이미지</label>
        <datalist id="dl-platforms">${platforms.map((p) => html`<option value="${p.name}">`)}</datalist>
        <datalist id="dl-models">${allModels.map((n) => html`<option value="${n}">`)}</datalist>
        <div class="acts full"><button type="button" class="btn" data-no>취소</button><button class="btn pri">저장</button></div>
      </form>`,
      (m, close) => {
        m.classList.add('wide');
        $('[data-no]', m).onclick = () => close(undefined);
        $('[data-f]', m).onsubmit = async (e) => {
          e.preventDefault();
          const f = formData(e.target);
          try {
            const body = { ...f, gen_preset_id: f.gen_preset_id || null };
            delete body.text;
            if (f.text.trim() !== tagsText.trim()) {
              const p = await api.post('/api/gen/parse', { text: f.text });
              const s = stripDefaults({ tags: p.categories, negative: p.negative });
              Object.assign(body, { tags: s.tags, negative: s.negative, loras: p.loras });
            } else if (!rec && v.tags) {
              Object.assign(body, { tags: v.tags, negative: v.negative, loras: v.loras });
            }
            if (!rec) Object.assign(body, { prompt_raw: v.prompt_raw ?? (f.text || null), extra: v.extra ?? {}, asset_id: v.asset_id ?? null });
            close(rec ? await api.put(`/api/gen/records/${rec.id}`, body) : await api.post(`/api/characters/${c.id}/gen-records`, body));
          } catch (err) {
            toast(err.message, 'error');
          }
        };
      },
    );
    if (!out) return;
    toast(rec ? '고쳤어요' : '생성 기록에 저장했어요');
    await load();
    draw();
  };

  el.innerHTML = '<div class="sub">불러오는 중…</div>';
  await load();
  draw();
}
