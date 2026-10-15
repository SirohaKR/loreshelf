// 화면 도구 — 안전한 HTML 만들기, 알림, 모달, 메뉴, 표시용 문구, 간단한 마크다운.
import { assetUrl } from './api.js';

// ───── 안전한 HTML ─────
// html`<b>${이름}</b>` 처럼 쓰면 ${} 안의 값은 자동으로 이스케이프된다 (사용자 글이 HTML로 실행되지 않게).
// 이미 만든 HTML 조각을 넣을 때만 raw()나 html`` 결과를 넣는다.
class Raw {
  constructor(s) {
    this.s = s;
  }
  toString() {
    return this.s;
  }
}
export const raw = (s) => new Raw(s);
export const esc = (s) =>
  String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
const fmt = (v) => (v instanceof Raw ? v.s : Array.isArray(v) ? v.map(fmt).join('') : v == null || v === false ? '' : esc(v));
export function html(strings, ...vals) {
  let out = '';
  strings.forEach((s, i) => {
    out += s + (i < vals.length ? fmt(vals[i]) : '');
  });
  return new Raw(out);
}

export const $ = (sel, root = document) => root.querySelector(sel);
export const $$ = (sel, root = document) => [...root.querySelectorAll(sel)];

/** el 안을 html`` 결과로 바꾸기 */
export function render(el, content) {
  el.innerHTML = content instanceof Raw ? content.s : fmt(content);
}

// ───── 알림 ─────
export function toast(message, type = 'info') {
  let box = $('.toast-box');
  if (!box) {
    box = document.createElement('div');
    box.className = 'toast-box';
    document.body.append(box);
  }
  const t = document.createElement('div');
  t.className = `toast ${type}`;
  t.textContent = message;
  box.append(t);
  setTimeout(() => t.remove(), type === 'error' ? 4500 : 2500);
}

/** 비동기 작업을 돌리고 오류면 알림 */
export async function attempt(fn, okMessage) {
  try {
    const r = await fn();
    if (okMessage) toast(okMessage);
    return r;
  } catch (e) {
    toast(e.message || String(e), 'error');
    throw e;
  }
}

// ───── 모달 ─────
/** 모달 열기. content는 html`` 결과, onMount(modalEl, close)로 이벤트 연결. 닫히면 Promise가 결과값으로 끝남 */
export function openModal(content, onMount) {
  return new Promise((resolve) => {
    const back = document.createElement('div');
    back.className = 'modal-back';
    back.innerHTML = `<div class="modal" role="dialog" aria-modal="true">${content.s ?? content}</div>`;
    const close = (result) => {
      back.remove();
      document.removeEventListener('keydown', onKey);
      resolve(result);
    };
    const onKey = (e) => e.key === 'Escape' && close(undefined);
    back.addEventListener('mousedown', (e) => e.target === back && close(undefined));
    document.addEventListener('keydown', onKey);
    document.body.append(back);
    onMount?.(back.querySelector('.modal'), close);
    back.querySelector('input, textarea, select, button.pri')?.focus();
  });
}

/** 확인 창 → true/false */
export function confirmDialog(message, { title = '확인', okText = '확인', danger = false } = {}) {
  return openModal(
    html`<h2>${title}</h2><p style="white-space:pre-wrap;margin:0">${message}</p>
      <div class="acts"><button class="btn" data-no>취소</button><button class="btn ${danger ? 'danger solid' : 'pri'}" data-yes>${okText}</button></div>`,
    (m, close) => {
      m.querySelector('[data-no]').onclick = () => close(false);
      m.querySelector('[data-yes]').onclick = () => close(true);
    },
  ).then((r) => r === true);
}

// ───── 드롭다운 메뉴 ─────
/** 버튼 옆에 메뉴 열기. items: [{label, danger, onClick}] 또는 'sep' */
export function openMenu(anchor, items, { left = false } = {}) {
  closeMenus();
  const menu = document.createElement('div');
  menu.className = `menu${left ? ' left' : ''}`;
  for (const it of items) {
    if (it === 'sep') {
      menu.append(document.createElement('hr'));
      continue;
    }
    const b = document.createElement('button');
    b.type = 'button';
    b.textContent = it.label;
    if (it.danger) b.className = 'danger';
    b.onclick = (e) => {
      e.stopPropagation();
      closeMenus();
      it.onClick();
    };
    menu.append(b);
  }
  anchor.closest('.menu-wrap').append(menu);
  setTimeout(() => document.addEventListener('click', closeMenus, { once: true }));
}
export function closeMenus() {
  $$('.menu').forEach((m) => m.remove());
}

// ───── 표시용 문구 ─────
export const VISIBILITY = { private: '비공개', unlisted: '링크 공개', public: '블로그 공개' };
export const KIND = { game: '게임', chatbot: '챗봇', etc: '기타' };
export const KIND_ICON = { game: '⚔', chatbot: '✉', etc: '✦' };
export const KIND_CHIP = { game: 'warn', chatbot: 'rose', etc: 'ok' };

export function visibilityChip(v) {
  if (v === 'public') return html`<span class="chip ok">공개</span>`;
  if (v === 'unlisted') return html`<span class="chip a">링크 공개</span>`;
  return html`<span class="chip">🔒 비공개</span>`;
}

/** '3일 전' 같은 상대 시각 */
export function ago(at) {
  if (!at) return '';
  const s = (Date.now() - new Date(at).getTime()) / 1000;
  if (s < 60) return '방금';
  if (s < 3600) return `${Math.floor(s / 60)}분 전`;
  if (s < 86400) return `${Math.floor(s / 3600)}시간 전`;
  if (s < 86400 * 30) return `${Math.floor(s / 86400)}일 전`;
  return new Date(at).toLocaleDateString('ko-KR');
}

// 이미지가 없을 때 쓰는 파스텔 색 (이름으로 항상 같은 색)
const PASTELS = ['#f6d6c8', '#cfe0f5', '#e3d6f3', '#d3ecdf', '#f5e6b8', '#f3cfdc', '#cfe9ee', '#e6e0d4'];
export function pastel(name = '') {
  let h = 0;
  for (const ch of name) h = (h * 31 + ch.codePointAt(0)) >>> 0;
  return PASTELS[h % PASTELS.length];
}

/** 초상화: 이미지가 있으면 썸네일, 없으면 테마색(또는 파스텔) + 이름 앞 두 글자 */
export function portrait(c, { cls = '', badge = null, initial = true } = {}) {
  const color = c.theme_color ? `${c.theme_color}55` : pastel(c.name);
  if (c.portrait_asset_id) {
    return html`<div class="pt ${cls}" style="--pt:${color}"><img src="${assetUrl(c.portrait_asset_id)}" alt="" loading="lazy">${badge}</div>`;
  }
  return html`<div class="pt empty ${cls}" style="--pt:${color}">${initial ? html`<span class="initial">${[...(c.name || '?')].slice(0, 2).join('')}</span>` : ''}${badge}</div>`;
}

// ───── 마크다운 (작은 버전: 제목, 굵게, 기울임, 코드, 목록, 링크, 문단) ─────
export function markdown(src) {
  if (!src) return raw('');
  const inline = (s) =>
    esc(s)
      .replace(/`([^`]+)`/g, '<code>$1</code>')
      .replace(/\*\*([^*]+)\*\*/g, '<b>$1</b>')
      .replace(/\*([^*]+)\*/g, '<i>$1</i>')
      .replace(/\[([^\]]+)\]\((https?:\/\/[^)\s]+)\)/g, '<a href="$2" target="_blank" rel="noopener noreferrer">$1</a>');
  // 한 줄씩: 제목 줄, 목록 줄이 이어진 묶음, 나머지 글 줄이 이어진 묶음(빈 줄에서 끊김)
  const out = [];
  let para = [];
  let list = [];
  const flush = () => {
    if (para.length) out.push(`<p>${para.map(inline).join('<br>')}</p>`);
    if (list.length) out.push(`<ul>${list.map((l) => `<li>${inline(l)}</li>`).join('')}</ul>`);
    para = [];
    list = [];
  };
  for (const line of src.replace(/\r/g, '').split('\n')) {
    const h = /^(#{1,3})\s+(.*)$/.exec(line);
    const li = /^\s*[-*]\s+(.*)$/.exec(line);
    if (!line.trim()) flush();
    else if (h) {
      flush();
      out.push(`<h${h[1].length}>${inline(h[2])}</h${h[1].length}>`);
    } else if (li) {
      if (para.length) flush();
      list.push(li[1]);
    } else {
      if (list.length) flush();
      para.push(line);
    }
  }
  flush();
  return raw(out.join(''));
}

/** 폼 → 객체 (name 속성 기준) */
export function formData(form) {
  const o = {};
  for (const el of form.elements) {
    if (!el.name) continue;
    if (el.type === 'checkbox') o[el.name] = el.checked;
    else o[el.name] = el.value;
  }
  return o;
}

/** 파일 고르기 창 → 선택한 파일들 */
export function pickFiles({ multiple = false } = {}) {
  return new Promise((resolve) => {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = 'image/png,image/jpeg,image/gif,image/webp';
    input.multiple = multiple;
    input.onchange = () => resolve([...input.files]);
    input.click();
  });
}
