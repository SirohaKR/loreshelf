// 캐릭터 상세의 "이미지·프롬프트" 탭 — 고정 프롬프트(의상 프리셋), 붙여넣기 → 자동 분류, 생성 기록.
// 분류는 서버(shared/ 패키지)가 하고, 이 화면은 결과를 보여 주고 고치기만 한다.
import { api, assetUrl } from '../api.js';
import { options } from '../parts.js';
import { $, $$, attempt, confirmDialog, formData, html, openMenu, openModal, pickFiles, toast } from '../ui.js';

export const CATEGORY = {
  character: '인물·외형',
  outfit: '의상·소품',
  expression: '표정',
  pose: '포즈·구도',
  background: '배경·조명',
  style: '스타일·화풍',
  quality: '품질',
  etc: '미분류',
};
const COLOR = { character: '#3f5bd8', outfit: '#d9822b', expression: '#e0a800', pose: '#7c5cd6', background: '#2f9e6b', style: '#d6487a', quality: '#6b7280', etc: '#9aa1ad' };
// 고정 프롬프트에 넣는 것 — 포즈·표정·배경은 그림마다 바뀌니 뺀다
const FIXED = ['character', 'outfit', 'style', 'quality', 'etc'];
const PLATFORM_SHORT = { NovelAI: 'NAI', 'Stable Diffusion WebUI': 'SD', ComfyUI: 'Comfy', Midjourney: 'MJ' };

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

const tagChip = (t, attrs = '') => html`<span class="ptag" ${attrs}>${t.tag}${t.weight !== 1 ? html` <b>${w(t.weight)}</b>` : ''}</span>`;
const loraChip = (l) => html`<span class="lora">${l.name} · ${w(l.weight)}</span>`;

/** 카테고리별 줄 (복사 버튼 포함). movable이면 태그를 눌러 다른 칸으로 옮길 수 있다 */
function rows({ tags = {}, negative = [], loras = [] }, { movable = false } = {}) {
  const out = Object.keys(CATEGORY)
    .filter((k) => tags[k]?.length)
    .map(
      (k) => html`<div class="crow"><div class="lb"><i style="--c:${COLOR[k]}"></i>${CATEGORY[k]}</div>
        <div class="tags">${tags[k].map((t) => tagChip(t, movable ? html`data-move="${t.tag}" title="눌러서 다른 칸으로 옮기기" role="button"` : ''))}</div>
        <button class="cp" data-copy-cat="${k}" title="이 줄 복사">⧉</button></div>`,
    );
  if (negative.length) {
    out.push(html`<div class="crow"><div class="lb"><i style="--c:#c03d3d"></i>네거티브</div>
      <div class="tags">${negative.map((t) => html`<span class="ptag neg">${t}</span>`)}</div>
      <button class="cp" data-copy-cat="negative" title="이 줄 복사">⧉</button></div>`);
  }
  if (loras.length) {
    out.push(html`<div class="crow"><div class="lb"><i style="--c:#2f9e6b"></i>LoRA</div>
      <div class="tags">${loras.map(loraChip)}</div><span></span></div>`);
  }
  return out.length ? out : html`<div class="sub">아직 태그가 없어요</div>`;
}

/** 분류 결과({categories, …}) → 화면용 묶음({tags, …}) */
const asData = (p) => ({ tags: p.categories, negative: p.negative, loras: p.loras });

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

  const load = async () => {
    [presets, records, platforms] = await Promise.all([
      api.get(`/api/characters/${c.id}/gen-presets`),
      api.get(`/api/characters/${c.id}/gen-records`),
      api.get('/api/gen/platforms'),
    ]);
    if (!presets.some((p) => p.id === presetId)) presetId = presets[0]?.id ?? null;
  };

  const draw = () => {
    el.innerHTML = html`<div class="wrap2">
      <div class="grid">
        <div class="card" data-preset-card>${presetCard()}</div>
        <div class="card" data-parse-card>${parseCard()}</div>
      </div>
      <div class="card" data-rec-card>${recordCard()}</div>
    </div>`.s;
    bindPreset();
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
        ? html`${rows(p)}
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
    $('[data-preset-copy]', card).onclick = () => copy(promptText(p, format), `${format === 'sd' ? 'SD' : 'NovelAI'} 형식으로 복사했어요`);
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
            const r = await api.post('/api/gen/parse', { text: f.text });
            const known = new Set((await api.get('/api/gen/loras')).map((l) => l.name.toLowerCase()));
            const skipped = r.loras.filter((l) => !known.has(l.name.toLowerCase()));
            const body = { name: f.name, tags: r.categories, negative: r.negative, loras: r.loras.filter((l) => known.has(l.name.toLowerCase())) };
            const out = p ? await api.put(`/api/gen/presets/${p.id}`, body) : await api.post(`/api/characters/${c.id}/gen-presets`, body);
            if (skipped.length) toast(`목록에 없는 LoRA는 빼고 저장했어요: ${skipped.map((l) => l.name).join(', ')}`, 'error');
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

  // ───── 붙여넣기 → 자동 분류 ─────
  const parseCard = () => html`<div class="card-h">
      <div><h2>프롬프트 붙여넣기 → 자동 분류</h2><div class="sub">WebUI·Forge 생성 정보 통째로, NovelAI 태그, Midjourney 명령어 모두 돼요</div></div>
    </div>
    <textarea class="raw" data-raw placeholder="여기에 프롬프트를 붙여넣어요">${rawText}</textarea>
    <div data-parsed>${parsedView()}</div>`;

  const parsedView = () => {
    if (!parsed || !rawText.trim()) return '';
    const total = Object.values(parsed.categories).reduce((a, b) => a + b.length, 0);
    return html`<div class="detect">감지된 플랫폼 <span class="chip a">${parsed.platform || '알 수 없음'}</span> 태그 ${total}개 · LoRA ${parsed.loras.length}개 · 네거티브 ${parsed.negative.length}개</div>
      <div class="parsed">${rows(asData(parsed), { movable: true })}</div>
      ${Object.keys(parsed.settings).length ? html`<div class="settings">${Object.entries(parsed.settings).map(([k, v]) => html`<div><small>${k}</small><span title="${v}">${v}</span></div>`)}</div>` : ''}
      <div class="hint">태그를 누르면 다른 칸으로 옮길 수 있고, 옮긴 태그는 내 사전에 기억돼서 다음부터 자동으로 그 칸에 들어가요.</div>
      <div class="acts">
        <button class="btn" data-to-preset>고정 프롬프트에 반영</button>
        <button class="btn pri" data-to-record>생성 기록으로 저장</button>
      </div>`;
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
    const box = $('[data-parsed]', el);
    if (!box) return;
    box.innerHTML = parsedView().s ?? '';
    bindParsed();
  };

  const bindParse = () => {
    $('[data-raw]', el).oninput = (e) => {
      rawText = e.target.value;
      clearTimeout(timer);
      timer = setTimeout(reparse, 300);
    };
    bindParsed();
  };

  const bindParsed = () => {
    const box = $('[data-parsed]', el);
    if (!box || !parsed) return;
    bindRowCopy(box, asData(parsed));
    $$('[data-move]', box).forEach((t) => {
      t.classList.add('menu-wrap');
      t.onclick = (e) => {
        e.stopPropagation();
        openMenu(
          t,
          Object.entries(CATEGORY).map(([k, label]) => ({
            label: `→ ${label}`,
            onClick: async () => {
              await attempt(() => api.post('/api/gen/tag-rules', { tag: t.dataset.move, category: k }), `'${t.dataset.move}'은(는) 이제 ${label}`);
              reparse();
            },
          })),
        );
      };
    });
    $('[data-to-preset]', box).onclick = toPreset;
    $('[data-to-record]', box).onclick = () => saveRecord(null, recordFromParsed());
  };

  /** 붙여넣은 것 중 고정 부분(인물·의상·화풍·품질·미분류 + 네거티브 + 목록에 있는 LoRA)을 프리셋에 덮어쓰기 */
  const toPreset = async () => {
    const choice = await openModal(
      html`<h2>고정 프롬프트에 반영</h2>
      <p class="sub" style="margin:0 0 10px">포즈·표정·배경은 그림마다 바뀌어서 빼고, 나머지로 고른 프리셋을 <b>덮어써요</b>.</p>
      <select data-p><option value="">+ 새 고정 프롬프트</option>${options(presets.map((p) => [p.id, p.name]), presetId)}</select>
      <input type="text" data-n maxlength="60" placeholder="새 프리셋 이름" style="margin-top:8px">
      <div class="acts"><button class="btn" data-no>취소</button><button class="btn pri" data-yes>반영</button></div>`,
      (m, close) => {
        const sel = $('[data-p]', m);
        const name = $('[data-n]', m);
        const sync = () => (name.style.display = sel.value ? 'none' : '');
        sel.onchange = sync;
        sync();
        $('[data-no]', m).onclick = () => close(undefined);
        $('[data-yes]', m).onclick = () => close({ id: sel.value ? Number(sel.value) : null, name: name.value.trim() });
      },
    );
    if (!choice) return;
    const known = new Set((await api.get('/api/gen/loras')).map((l) => l.name.toLowerCase()));
    const body = {
      tags: Object.fromEntries(FIXED.filter((k) => parsed.categories[k]).map((k) => [k, parsed.categories[k]])),
      negative: parsed.negative,
      loras: parsed.loras.filter((l) => known.has(l.name.toLowerCase())),
    };
    const out = choice.id
      ? await attempt(() => api.put(`/api/gen/presets/${choice.id}`, body), '고정 프롬프트에 반영했어요')
      : await attempt(() => api.post(`/api/characters/${c.id}/gen-presets`, { ...body, name: choice.name || '새 프리셋' }), '고정 프롬프트를 만들었어요');
    presetId = out.id;
    await load();
    draw();
  };

  const recordFromParsed = () => {
    const s = parsed.settings;
    const size = /^(\d+)\s*x\s*(\d+)$/.exec(s.Size || '');
    const platform = parsed.platform && parsed.platform !== '알 수 없음' ? parsed.platform : '';
    return {
      platform,
      model: s.Model || (s['--niji'] ? `niji ${s['--niji']}` : s['--v'] ? `v${s['--v']}` : ''),
      prompt_raw: rawText,
      tags: parsed.categories,
      negative: parsed.negative,
      loras: parsed.loras,
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
            tags: info.parsed.categories,
            negative: info.parsed.negative,
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
      <div style="margin-top:12px">${rows(r)}</div>
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
        const wf = $('[data-wf]', m);
        if (wf) wf.onclick = () => copy(String(r.extra.workflow), '워크플로 JSON을 복사했어요');
        $$('[data-act]', m).forEach((b) => (b.onclick = () => close(b.dataset.act)));
      },
    );
    if (act === 'copy') copy(promptText(r, 'sd'));
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
              Object.assign(body, { tags: p.categories, negative: p.negative, loras: p.loras });
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
