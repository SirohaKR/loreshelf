// 챗봇 설정 화면(로드맵·카드 편집)이 같이 쓰는 것 — 서버 표(/api/chatbot/meta), 글자 수 세기, 표기 찾기, 카드별 칸 정의.
// 글자 수 한도 숫자는 shared/lib/src/chatbot/platform_limits.dart 표 하나에만 있고, 여기선 서버에서 받아 쓴다.
// 세기·표기 규칙은 shared 쪽 Dart와 똑같이 맞춰 둔다 (바꾸면 둘 다).
import { api } from '../api.js';
import { esc } from '../ui.js';

let metaPromise = null;
/** 카드 종류·빈 모양·한도 표 (한 번만 읽음) */
export function loadMeta() {
  metaPromise ??= api.get('/api/chatbot/meta').catch((e) => {
    metaPromise = null;
    throw e;
  });
  return metaPromise;
}

// ───── 글자 수 (platform_limits.dart 와 같은 셈) ─────

/** 로판 "글자" — 띄어쓰기·줄바꿈 포함, 이모지도 한 글자 */
export const countChars = (text) => [...text].length;

/** 로플 토큰 근사치 — 한글 음절 0.75 · 영어/숫자 4글자에 1 · 띄어쓰기 0 · 그 밖의 글자 1 */
export function estimateTokens(text) {
  let hangul = 0;
  let latin = 0;
  let other = 0;
  for (const ch of text) {
    const r = ch.codePointAt(0);
    if (r >= 0xac00 && r <= 0xd7a3) hangul++;
    else if ((r >= 0x30 && r <= 0x39) || (r >= 0x41 && r <= 0x5a) || (r >= 0x61 && r <= 0x7a)) latin++;
    else if (r === 0x20 || r === 0x09) continue;
    else other++;
  }
  return Math.ceil(hangul * 0.75 + latin / 4 + other);
}

const comma = (n) => n.toLocaleString('en-US');

/** [key] 한도로 [text]를 센다 → {count, max, level: ok|near|over, display: "1,240/6,000자", label, platform} */
export function checkLimit(meta, key, text) {
  const l = meta.limits[key];
  if (!l) return null;
  const tokens = l.unit === 'tokens';
  return measured(l, tokens ? estimateTokens(text) : countChars(text), tokens);
}

function measured(l, count, estimate) {
  const level = count > l.max ? 'over' : count * 10 >= l.max * 9 ? 'near' : 'ok';
  const unit = l.unit === 'tokens' ? '토큰' : '자';
  return { ...l, count, level, display: `${estimate ? '≈ ' : ''}${comma(count)}/${comma(l.max)}${unit}` };
}

export const PLATFORM_NAME = { rofan: '로판', rplay: '로플' };
const LEVEL_RANK = { ok: 0, near: 1, over: 2 };
export const worse = (a, b) => (LEVEL_RANK[b] > LEVEL_RANK[a] ? b : a);

// ───── 표기 (notation.dart 와 같은 규칙) ─────

const PATTERN = /\{\{([^{}]*)\}\}|(?<!\{)\{\s*(char|user)\s*\}(?!\})|<\s*(char|user)\s*>/gi;
const VAR_NAME = /^var_([^{}\s]+)$/;
const ALIASES = {
  char: '{{char}}', 캐릭터: '{{char}}', 캐릭: '{{char}}', 봇: '{{char}}',
  user: '{{user}}', 유저: '{{user}}', 사용자: '{{user}}', 이용자: '{{user}}',
};

/** 글 속 표기 → [{start, end, kind: char|user|variable|invalid, text, name?, suggestion?}] */
export function findNotations(text) {
  const out = [];
  for (const m of text.matchAll(PATTERN)) {
    const at = { start: m.index, end: m.index + m[0].length, text: m[0] };
    const inner = m[1];
    if (inner === undefined) {
      out.push({ ...at, kind: 'invalid', suggestion: `{{${(m[2] ?? m[3]).toLowerCase()}}}` });
      continue;
    }
    const v = VAR_NAME.exec(inner);
    if (inner === 'char' || inner === 'user') out.push({ ...at, kind: inner });
    else if (v) out.push({ ...at, kind: 'variable', name: v[1] });
    else {
      const t = inner.trim();
      const alias = ALIASES[t.toLowerCase()];
      if (alias) out.push({ ...at, kind: 'invalid', suggestion: alias });
      else if (t.toLowerCase().startsWith('var_') && t.length > 4) {
        out.push({ ...at, kind: 'invalid', suggestion: `{{var_${t.slice(4).replace(/\s/g, '')}}}` });
      }
    }
  }
  return out;
}

/** 잘못된 표기를 제안대로 고친다 (only가 있으면 그 위치 하나만) */
export const fixNotations = (text, only = null) =>
  replaceNotations(text, (m) => (m.kind === 'invalid' && (only === null || m.start === only) ? m.suggestion : null));

/** 찾은 표기를 pick이 돌려준 글로 바꾼다 (null이면 그대로) */
function replaceNotations(text, pick) {
  let out = '';
  let at = 0;
  for (const m of findNotations(text)) {
    const to = pick(m);
    if (to == null) continue;
    out += text.slice(at, m.start) + to;
    at = m.end;
  }
  return out + text.slice(at);
}

/** 플랫폼에 붙여 넣을 모양 (notation.dart convertNotation) — 로판: 변수는 낱말, 로플: {{char}} → 이름 */
export const convertNotation = (text, platform, charName) =>
  replaceNotations(text, (m) => {
    if (m.kind === 'char') return platform === 'rplay' ? charName : null;
    if (m.kind === 'variable') return platform === 'rplay' ? null : m.name;
    return null;
  });

/** 저장 후 미리보기 (notation.dart renderPreview) — {{char}} → 이름, {{user}} → 별명, {{var_x}} → 예시 값 또는 이름.
 * 바뀐 자리는 {text, kind} 조각으로 돌려줘서 화면이 색을 입힌다 */
export function previewParts(text, { charName, userName, values = {} }) {
  const parts = [];
  let at = 0;
  for (const m of findNotations(text)) {
    if (m.kind === 'invalid') continue;
    parts.push({ text: text.slice(at, m.start) });
    parts.push({ kind: m.kind, text: m.kind === 'char' ? charName : m.kind === 'user' ? userName : (values[m.name] ?? m.name) });
    at = m.end;
  }
  parts.push({ text: text.slice(at) });
  return parts.filter((p) => p.text);
}

/** 입력칸 뒤에 깔 색칠 HTML (글자 자리는 입력칸과 똑같이) */
export function highlightHtml(text) {
  let out = '';
  let at = 0;
  for (const m of findNotations(text)) {
    out += esc(text.slice(at, m.start)) + `<mark class="n-${m.kind}">${esc(m.text)}</mark>`;
    at = m.end;
  }
  // 끝 줄바꿈도 높이를 차지하게 빈칸 하나
  return `${out}${esc(text.slice(at))} `;
}

// ───── 카드별 칸 정의 ─────
// path = content_json 안 위치. limits = 한도 표 키 ('rofan.detail'은 여러 칸을 합친 로판 세부 설정).
// text 칸은 {{char}}·{{user}}·{{var}} 칩 버튼과 색칠이 붙는다 (plain: true면 안 붙음).

const text = (path, label, o = {}) => ({ type: 'text', path, label, ...o });
const line = (path, label, o = {}) => ({ type: 'text', path, label, single: true, plain: true, ...o });
const int = (path, label, o = {}) => ({ type: 'int', path, label, ...o });
const bool = (path, label, o = {}) => ({ type: 'bool', path, label, ...o });
const choice = (path, label, values, o = {}) => ({ type: 'choice', path, label, values, ...o });
const rows = (path, label, fields, o = {}) => ({ type: 'rows', path, label, fields, ...o });

export const ROFAN_DETAIL = 'rofan.detail';

/** 카드 종류별 편집 칸. story는 작품의 편집 모드(간편/캔버스)에 따라 중요 정보 한도가 다르다 */
export function formFor(kind, editMode = 'simple') {
  switch (kind) {
    case 'story':
      return [
        text('key_info', '중요 정보', {
          hint: '매 턴 AI에 전달 · 세계관·장소·지금 상황',
          limits: [editMode === 'canvas' ? 'rplay.story.key_info' : 'rplay_simple.story.key_info', ROFAN_DETAIL],
          rows: 8,
        }),
        text('full_story', '전체 스토리', {
          hint: '참고 자료(필요할 때만 꺼내 씀) · 로플 간편 모드엔 없는 칸이라 내보낼 때 매크로로 나누기를 제안해요',
          limits: ['rplay.story.full_story', ROFAN_DETAIL],
          rows: 8,
        }),
        rows('start_messages', '시작 메시지', [
          line('name', '이름', { limits: ['rofan.start.name'], placeholder: '기본 설정' }),
          text('body', '내용', { limits: ['rofan.start.body', 'rplay.story.start_message'], rows: 4 }),
        ], { add: '+ 시작 메시지', hint: '로판 "시작 설정" 여러 개 · 로플 시작 메시지' }),
        text('start_guide', '시작 가이드', { hint: '초반 진행 안내 · 로플 캔버스만', limits: ['rplay.story.start_guide'], rows: 3 }),
        text('creator_notice', '크리에이터 공지', { hint: '로판 제작자 코멘트 · 로플 공지(넘치면 저장할 때 잘림)', limits: ['rofan.creator_comment', 'rplay.story.creator_notice'], rows: 3 }),
        bool('is_start', '시작 노드', { hint: '로플 캔버스에서 시작 메시지·가이드를 쓰는 노드' }),
      ];
    case 'character':
      return [
        line('one_line', '한 줄 소개', { limits: ['rofan.character.one_line'] }),
        text('key_info', '중요 정보', { hint: '매 턴 전달 · 꼭 지킬 성격·말투만', limits: ['rplay.character.key_info', ROFAN_DETAIL], rows: 6 }),
        text('detail', '상세 설명', { hint: '컴파일 자료 · 로판은 "캐릭터 소개"로', limits: [ROFAN_DETAIL], rows: 6 }),
        text('secret', '비밀', { hint: '로판 "비밀" 칸 · 로플은 매크로로 제안 · 공개 플랫폼 주의', limits: [ROFAN_DETAIL], rows: 3 }),
        text('solo_first_message', '단독 대화 첫 메시지', { hint: '1:1 대화 모드용', rows: 3 }),
        int('display_priority', '표시 우선순위'),
        bool('show_in_preview', '미리보기에 보이기'),
      ];
    case 'user':
      return [
        line('name', '이름', { placeholder: '비우면 {{user}} (이용자 별명)' }),
        text('body', '설정', { hint: '이용자가 맡는 사람 · 로판은 세계관 안 "{{user}} 설정" 단락으로', limits: [ROFAN_DETAIL], rows: 5 }),
      ];
    case 'image':
      return [
        { type: 'asset', path: 'asset_id', label: '이미지' },
        choice('usage', '쓰임', [['emotion', '감정'], ['situation', '상황'], ['background', '배경']]),
        text('description', '설명', { limits: ['rplay.image.description'], rows: 3 }),
        { type: 'list', path: 'tags', label: '태그', hint: '쉼표로 나눠 적어요', countLimit: 'rplay.image.tag' },
      ];
    case 'macro':
      return [
        choice('mode', '발동 방식', [['always', '항상'], ['keyword', '낱말이 나오면']]),
        { type: 'list', path: 'keywords', label: '낱말', hint: '쉼표로 나눠 적어요 · "낱말이 나오면"일 때만 써요' },
        text('body', '내용', { limits: ['rplay.macro.body'], rows: 5 }),
        int('priority', '우선순위', { hint: '한 턴에 상위 5개만 들어가요' }),
        int('duration_turns', '지속 턴 수', { min: 1, max: 5 }),
      ];
    case 'extra_cast':
      return [
        rows('people', '기타 인물', [
          line('name', '이름'),
          line('role', '역할·관계', { placeholder: '50대, 가끔 와서 폐기 도시락 챙김' }),
          line('speech', '말투', { placeholder: '사투리, "아이고"' }),
          line('first_scene', '처음 나오는 상황'),
          { type: 'character', path: 'character_id', label: '서재 캐릭터' },
        ], { add: '+ 사람 추가', hint: '한 줄에 한 사람 · 조연·지나가는 사람', limits: [ROFAN_DETAIL] }),
        bool('allow_improvised', '즉흥 등장', { hint: '끄면 "목록에 없는 인물은 만들지 않음"' }),
        text('improvise_rule', '즉흥 등장 규칙', { rows: 2, placeholder: '필요하면 이름 있는 조연을 새로 만들어도 됨. 한 번 나온 조연은 이름·말투를 유지' }),
      ];
    case 'preset_note':
      return [
        rows('notes', '프리셋', [
          line('emoji', '이모지'),
          line('title', '제목'),
          line('description', '설명'),
          text('body', '내용', { limits: ['rplay.preset_note.body'], rows: 3 }),
          int('priority', '우선순위'),
        ], { add: '+ 프리셋', countLimit: 'rplay.preset_note.per_node', hint: '이용자가 켜고 끄는 분위기 스위치' }),
      ];
    case 'variable':
      return [
        line('name', '변수 이름', { hint: '글에는 {{var_이름}} 으로 적어요 · { } 와 띄어쓰기는 못 써요' }),
        choice('value_kind', '종류', [['number', '숫자'], ['boolean', '참/거짓'], ['text', '문자']]),
        line('initial_value', '처음 값'),
      ];
    case 'update_rule':
      return [text('body', '규칙', { hint: '변수는 {{var_이름}} 으로 · 예) 친절하면 {{var_호감도}} +1', limits: ['rplay.update_rule.body'], rows: 5 })];
    case 'trigger':
      return [
        rows('conditions', '조건 (모두 만족)', [
          { type: 'variable', path: 'variable', label: '변수' },
          choice('operator', '비교', [['eq', '='], ['ne', '≠'], ['gt', '>'], ['gte', '≥'], ['lt', '<'], ['lte', '≤']]),
          line('value', '값'),
        ], { add: '+ 조건', inline: true }),
        rows('actions', '켜기', [
          choice('action', '동작', [['scene', '장면 전환'], ['image', '이미지'], ['macro', '매크로'], ['preset_note', '프리셋'], ['achievement', '업적']]),
          { type: 'node', path: 'chatbot_node_id', label: '대상 카드' },
        ], { add: '+ 동작', inline: true }),
      ];
    case 'achievement':
      return [
        { type: 'asset', path: 'asset_id', label: '이미지' },
        text('description', '설명', { rows: 3 }),
        line('hint', '힌트'),
        bool('is_hidden', '히든 업적'),
        int('display_priority', '표시 우선순위'),
        int('reward_credits', '리워드 크레딧', { min: 0, max: 5000 }),
      ];
    default:
      return [];
  }
}

/** 카드의 글 칸을 전부 펼친다 → [{label, text, limits}] (기타 인물 줄은 한 줄 글로 합침) */
export function textFields(node, editMode) {
  const c = node.content || {};
  const out = [];
  for (const f of formFor(node.kind, editMode)) {
    if (f.type === 'text') out.push({ label: f.label, text: c[f.path] || '', limits: f.limits || [] });
    if (f.type === 'rows') {
      const list = c[f.path] || [];
      if (f.limits) out.push({ label: f.label, text: list.map(personLine).join('\n'), limits: f.limits });
      list.forEach((r, i) => {
        for (const g of f.fields) {
          if (g.type === 'text' && g.limits) out.push({ label: `${f.label} ${i + 1} ${g.label}`, text: r[g.path] || '', limits: g.limits });
        }
      });
    }
  }
  if (node.kind === 'character') out.unshift({ label: '이름', text: node.title || '', limits: ['rofan.character.name'] });
  return out;
}

/** 기타 인물 한 줄 = "이름 · 역할 · 말투 · 처음 상황" (빈 칸은 뺌) */
export const personLine = (p) => [p.name, p.role, p.speech, p.first_scene].filter((s) => s && s.trim()).join(' · ');

/** 로판 세부 설정(세계관+캐릭터 소개+비밀)에 합쳐지는 글 → [{source: 세계관|캐릭터 소개|비밀|유저|기타 인물, count}] */
export function rofanDetailParts(nodes) {
  const parts = { 세계관: 0, '캐릭터 소개': 0, 비밀: 0, 유저: 0, '기타 인물': 0 };
  for (const n of nodes) {
    if (!n.is_enabled) continue;
    const c = n.content || {};
    const add = (k, s) => (parts[k] += countChars(s || ''));
    if (n.kind === 'story') add('세계관', (c.key_info || '') + (c.full_story || ''));
    if (n.kind === 'character') {
      add('캐릭터 소개', (c.key_info || '') + (c.detail || ''));
      add('비밀', c.secret);
    }
    if (n.kind === 'user') add('유저', c.body);
    if (n.kind === 'extra_cast') add('기타 인물', (c.people || []).map(personLine).join('\n'));
  }
  return Object.entries(parts).map(([source, count]) => ({ source, count }));
}

/** 칸 하나의 한도 결과들 (+ key). rofan.detail은 작품 전체 합계([detailTotal])로 센다 */
export function fieldChecks(meta, limits, value, detailTotal) {
  return limits
    .map((k) => {
      const c = k === ROFAN_DETAIL ? measured(meta.limits[k], detailTotal, false) : checkLimit(meta, k, value);
      return c && { ...c, key: k };
    })
    .filter(Boolean);
}

/** 로판 세부 설정 합계 결과 */
export function rofanDetailCheck(meta, nodes) {
  return measured(meta.limits[ROFAN_DETAIL], rofanDetailParts(nodes).reduce((s, p) => s + p.count, 0), false);
}

/** 작품 전체의 경고 목록 → [{node, label, check}] (주황·빨강만, 빨강 먼저). 로판 세부 설정 합계는 node 없이 한 줄 */
export function storyWarnings(meta, story) {
  const out = [];
  const detail = rofanDetailCheck(meta, story.nodes);
  if (detail.level !== 'ok') out.push({ node: null, label: '', check: detail });
  for (const n of story.nodes) {
    if (!n.is_enabled) continue;
    for (const f of textFields(n, story.edit_mode)) {
      for (const k of f.limits) {
        if (k === ROFAN_DETAIL) continue;
        const ch = checkLimit(meta, k, f.text);
        if (ch && ch.level !== 'ok') out.push({ node: n, label: f.label, check: ch });
      }
    }
  }
  return out.sort((a, b) => LEVEL_RANK[b.check.level] - LEVEL_RANK[a.check.level]);
}

/** 카드 하나의 가장 나쁜 상태 (ok|near|over) */
export function nodeLevel(meta, node, editMode) {
  let level = 'ok';
  for (const f of textFields(node, editMode)) {
    for (const k of f.limits) {
      if (k === ROFAN_DETAIL) continue; // 합계는 카드 하나 탓이 아니라서 로드맵 오른쪽에서 따로
      const ch = checkLimit(meta, k, f.text);
      if (ch) level = worse(level, ch.level);
    }
  }
  return level;
}

/** 작품 안 변수 카드 이름들 */
export const variableNames = (nodes) => nodes.filter((n) => n.kind === 'variable' && n.content?.name).map((n) => n.content.name);

/** 잘못된 표기 개수 (카드 전체) */
export function invalidNotationCount(node, editMode) {
  return textFields(node, editMode).reduce((s, f) => s + findNotations(f.text).filter((m) => m.kind === 'invalid').length, 0);
}
