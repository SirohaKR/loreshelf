// 생성 도구 — LoRA 목록, 플랫폼·모델 목록, 내 분류 사전 (#/gen)
import { api } from '../api.js';
import { $, $$, attempt, confirmDialog, formData, html, openModal, render as put, toast } from '../ui.js';
import { CATEGORY } from './character_prompt.js';

export async function render(el) {
  let loras = [];
  let platforms = [];
  let rules = [];

  const load = async () => {
    [loras, platforms, rules] = await Promise.all([api.get('/api/gen/loras'), api.get('/api/gen/platforms'), api.get('/api/gen/tag-rules')]);
  };

  const draw = () => {
    put(
      el,
      html`<div class="page-head"><div><h1>생성 도구</h1><div class="sub">이미지 생성에 쓰는 LoRA·모델 목록과 자동 분류 사전이에요. 생성 기록을 저장할 때 자동완성에 쓰여요.</div></div></div>
      <div class="wrap2">
        <div class="grid">
          <div class="card">
            <div class="card-h"><h2>LoRA <span class="chip">${loras.length}</span></h2><button class="btn sm pri" data-lora-new>+ LoRA</button></div>
            <div class="gen-list">${loras.length
              ? loras.map(
                  (l) => html`<div class="item">
                    <div class="grow"><b>${l.name}</b> <span class="lora">기본 ${l.default_weight}</span>${l.base_model ? html` <span class="chip">${l.base_model}</span>` : ''}
                      <div class="sub">${[l.trigger_words && `트리거: ${l.trigger_words}`, `기록 ${l.use_count}개`, l.note].filter(Boolean).join(' · ')}</div></div>
                    ${l.source_url && /^https?:\/\//.test(l.source_url) ? html`<a class="btn sm" href="${l.source_url}" target="_blank" rel="noopener noreferrer">↗</a>` : ''}
                    <button class="btn sm" data-lora="${l.id}">고치기</button>
                  </div>`,
                )
              : html`<div class="sub">아직 없어요. 캐릭터 LoRA, 화풍 LoRA를 등록해 두면 고정 프롬프트에 넣을 수 있어요.</div>`}</div>
          </div>
          <div class="card">
            <div class="card-h"><h2>플랫폼 · 모델</h2><button class="btn sm" data-platform-new>+ 플랫폼</button></div>
            <div class="gen-list">${platforms.map(
              (p) => html`<div class="item" style="align-items:flex-start">
                <div class="grow"><b>${p.name}</b>
                  <div class="chips" style="margin-top:6px">${p.models.map((m) => html`<button class="chip pick" data-model="${m.id}" title="${m.base_model || ''}">${m.name}</button>`)}
                    <button class="chip pick" data-model-new="${p.id}">+ 모델</button></div></div>
                <button class="btn sm" data-platform="${p.id}">⋯</button>
              </div>`,
            )}</div>
          </div>
        </div>
        <div class="card">
          <div class="card-h"><div><h2>내 분류 사전 <span class="chip">${rules.length}</span></h2><div class="sub">자동 분류에서 옮긴 태그. 기본 규칙보다 먼저 써요.</div></div></div>
          <div class="gen-list">${rules.length
            ? rules.map(
                (r) => html`<div class="item"><div class="grow"><span class="ptag">${r.tag}</span></div><span class="chip">${CATEGORY[r.category] || r.category}</span>
                  <button class="btn sm" data-rule-del="${r.id}" title="사전에서 빼기">✕</button></div>`,
              )
            : html`<div class="sub">캐릭터의 이미지·프롬프트 탭에서 태그를 다른 칸으로 옮기면 여기에 쌓여요.</div>`}</div>
        </div>
      </div>`,
    );
    $('[data-lora-new]', el).onclick = () => editLora(null);
    $$('[data-lora]', el).forEach((b) => (b.onclick = () => editLora(loras.find((l) => l.id === Number(b.dataset.lora)))));
    $('[data-platform-new]', el).onclick = () => editPlatform(null);
    $$('[data-platform]', el).forEach((b) => (b.onclick = () => editPlatform(platforms.find((p) => p.id === Number(b.dataset.platform)))));
    $$('[data-model-new]', el).forEach((b) => (b.onclick = () => editModel(null, Number(b.dataset.modelNew))));
    $$('[data-model]', el).forEach((b) => (b.onclick = () => editModel(platforms.flatMap((p) => p.models).find((m) => m.id === Number(b.dataset.model)))));
    $$('[data-rule-del]', el).forEach(
      (b) =>
        (b.onclick = async () => {
          await attempt(() => api.del(`/api/gen/tag-rules/${b.dataset.ruleDel}`), '사전에서 뺐어요');
          await refresh();
        }),
    );
  };

  const refresh = async () => {
    await load();
    draw();
  };

  /** 이름·칸 폼 모달 공통. fields: [[name, label, {full, area, placeholder}]] */
  const formModal = (title, fields, v, { canDelete = false } = {}) =>
    openModal(
      html`<h2>${title}</h2>
      <form data-f class="form-grid">
        ${fields.map(([name, label, o = {}]) =>
          o.area
            ? html`<label class="f full">${label}<textarea name="${name}" placeholder="${o.placeholder || ''}">${v?.[name] ?? ''}</textarea></label>`
            : html`<label class="f ${o.full ? 'full' : ''}">${label}<input type="text" name="${name}" value="${v?.[name] ?? o.value ?? ''}" placeholder="${o.placeholder || ''}"></label>`,
        )}
        <div class="acts full">${canDelete ? html`<button type="button" class="btn danger" data-del style="margin-right:auto">지우기</button>` : ''}<button type="button" class="btn" data-no>취소</button><button class="btn pri">저장</button></div>
      </form>`,
      (m, close) => {
        $('[data-no]', m).onclick = () => close(undefined);
        const del = $('[data-del]', m);
        if (del) del.onclick = () => close('delete');
        $('[data-f]', m).onsubmit = (e) => {
          e.preventDefault();
          close(formData(e.target));
        };
      },
    );

  const editLora = async (l) => {
    const v = await formModal(
      l ? `LoRA 고치기 · ${l.name}` : '새 LoRA',
      [
        ['name', '이름 (프롬프트의 <lora:이름>)', { full: true }],
        ['default_weight', '기본 가중치', { value: '1' }],
        ['base_model', '기반 모델', { placeholder: 'Illustrious, Pony, SDXL …' }],
        ['trigger_words', '트리거 단어 (쉼표로)', { full: true }],
        ['file_name', '파일 이름'],
        ['source_url', '출처 주소', { placeholder: 'https://civitai.com/…' }],
        ['note', '메모', { area: true }],
      ],
      l,
      { canDelete: !!l },
    );
    if (v === undefined) return;
    try {
      if (v === 'delete') {
        if (!(await confirmDialog(`LoRA '${l.name}'을(를) 목록에서 지울까요?\n생성 기록에는 이름이 남아요. 고정 프롬프트에서는 빠져요.`, { okText: '지우기', danger: true }))) return;
        await api.del(`/api/gen/loras/${l.id}`);
        toast('지웠어요');
      } else if (l) {
        await api.put(`/api/gen/loras/${l.id}`, v);
        toast('고쳤어요');
      } else {
        await api.post('/api/gen/loras', v);
        toast('LoRA를 추가했어요');
      }
    } catch (e) {
      toast(e.message, 'error');
    }
    await refresh();
  };

  const editPlatform = async (p) => {
    const v = await formModal(p ? `플랫폼 · ${p.name}` : '새 플랫폼', [['name', '이름', { full: true }]], p, { canDelete: !!p });
    if (v === undefined) return;
    try {
      if (v === 'delete') {
        if (!(await confirmDialog(`플랫폼 '${p.name}'과(와) 그 모델 ${p.models.length}개를 지울까요?\n생성 기록에서는 "플랫폼 없음"이 돼요.`, { okText: '지우기', danger: true }))) return;
        await api.del(`/api/gen/platforms/${p.id}`);
      } else if (p) await api.put(`/api/gen/platforms/${p.id}`, v);
      else await api.post('/api/gen/platforms', v);
      toast('저장했어요');
    } catch (e) {
      toast(e.message, 'error');
    }
    await refresh();
  };

  const editModel = async (m, platformId) => {
    const v = await formModal(
      m ? `모델 · ${m.name}` : '새 모델',
      [
        ['name', '이름', { full: true }],
        ['base_model', '기반 모델', { placeholder: 'SDXL, Illustrious, NAI V4.5 …' }],
        ['file_name', '파일 이름'],
        ['source_url', '출처 주소', { full: true }],
        ['note', '메모', { area: true }],
      ],
      m,
      { canDelete: !!m },
    );
    if (v === undefined) return;
    try {
      if (v === 'delete') {
        if (!(await confirmDialog(`모델 '${m.name}'을(를) 지울까요?`, { okText: '지우기', danger: true }))) return;
        await api.del(`/api/gen/models/${m.id}`);
      } else if (m) await api.put(`/api/gen/models/${m.id}`, v);
      else await api.post('/api/gen/models', { ...v, gen_platform_id: platformId });
      toast('저장했어요');
    } catch (e) {
      toast(e.message, 'error');
    }
    await refresh();
  };

  await load();
  draw();
}
