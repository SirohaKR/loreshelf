// 챗봇 카드 "프로필에서 채우기" — 캐릭터 프로필로 카드 칸을 채울 글을 만들고, 바뀔 내용을 먼저 보여 준 뒤 고른 칸만 넣는다.
// 기획: docs/planning/챗봇-설정-기획서.md 2-3
import { $, $$, html, openModal } from '../ui.js';

/** 성격 축 → 70% 이상 기운 쪽 낱말만 (50% 근처는 생략) */
function traitWords(traits) {
  const out = [];
  for (const t of traits || []) {
    const v = Number(t.value_percent);
    if (t.right_label) {
      if (v >= 70) out.push(t.right_label);
      else if (v <= 30) out.push(t.left_label);
    } else if (v >= 70) out.push(t.left_label);
  }
  return out;
}

/** 마크다운 기호 빼기 (제목 #, 굵게·기울임, 코드, 링크, 목록 기호) */
export function stripMarkdown(md) {
  return (md || '')
    .replace(/\r/g, '')
    .replace(/^#{1,6}\s+/gm, '')
    .replace(/\*\*([^*]+)\*\*/g, '$1')
    .replace(/\*([^*]+)\*/g, '$1')
    .replace(/`([^`]+)`/g, '$1')
    .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1')
    .replace(/^\s*[-*]\s+/gm, '')
    .trim();
}

const AGE = /^(나이|연령)$/;
const GENDER = /^(성별)$/;
const JOB = /^(직업|소속|직책|신분)$/;

/** 캐릭터 프로필 → 카드 칸 제안 [{path, label, after, secret}] */
export function profileProposals(kind, c) {
  const open = (c.fields || []).filter((f) => !f.is_secret && f.value);
  const pick = (re) => open.find((f) => re.test(f.label.trim()))?.value;
  const out = [];
  if (kind === 'character') {
    const paren = [pick(AGE), pick(GENDER)].filter(Boolean).join(', ');
    const job = pick(JOB);
    const first = `{{char}}${paren ? `(${paren})` : ''}${job ? ` — ${job}` : ''}`;
    const words = traitWords(c.traits);
    // 나이·성별·직업·성격이 하나도 없으면 {{char}} 한 단어뿐이라 제안하지 않음
    if (paren || job || words.length) out.push({ path: 'key_info', label: '중요 정보', after: [first, words.length ? `성격: ${words.join(', ')}` : ''].filter(Boolean).join('\n') });
    if (c.tagline) out.push({ path: 'one_line', label: '한 줄 소개', after: c.tagline });
    const rest = open.filter((f) => ![AGE, GENDER, JOB].some((re) => re.test(f.label.trim())));
    const quotes = (c.quotes || []).filter((q) => !q.is_secret);
    const detail = [
      rest.length ? `[기본 정보]\n${rest.map((f) => `${f.label}: ${f.value}`).join('\n')}` : '',
      quotes.length ? `[말투 예시]\n${quotes.map((q) => (q.situation ? `${q.situation}: "${q.body}"` : `"${q.body}"`)).join('\n')}` : '',
    ].filter(Boolean).join('\n\n');
    if (detail) out.push({ path: 'detail', label: '상세 설명', after: detail });
    const secretFields = (c.fields || []).filter((f) => f.is_secret && f.value);
    const secretQuotes = (c.quotes || []).filter((q) => q.is_secret);
    const secret = [...secretFields.map((f) => `${f.label}: ${f.value}`), ...secretQuotes.map((q) => `"${q.body}"`)].join('\n');
    // 공개 플랫폼에 올리는 거라 비밀은 기본으로 꺼 둔다
    if (secret) out.push({ path: 'secret', label: '비밀', after: secret, secret: true });
  }
  if (kind === 'story' && c.body_md) out.push({ path: 'full_story', label: '전체 스토리', after: stripMarkdown(c.body_md) });
  return out;
}

/** 전/후 비교 창 → 고른 제안 목록 (취소면 undefined) */
export function chooseProposals(name, proposals, content) {
  return openModal(
    html`<h2>프로필에서 채우기 <small class="sub">${name}</small></h2>
    <p class="sub" style="margin:-6px 0 12px">넣을 칸만 고르세요. 고른 칸은 지금 글이 프로필 내용으로 바뀌어요. 비밀은 공개 플랫폼에 올라가니 기본으로 꺼 뒀어요.</p>
    <div class="pf-list">${proposals.map((p, i) => {
      const before = content[p.path] || '';
      const same = before.trim() === p.after.trim();
      return html`<label class="pf-row ${same ? 'same' : ''}">
        <span class="pf-h"><input type="checkbox" data-i="${i}" ${!same && !p.secret && !before.trim() ? 'checked' : ''} ${same ? 'disabled' : ''}> <b>${p.label}</b>${same ? html` <span class="chip">이미 같아요</span>` : p.secret ? html` <span class="chip warn">공개 플랫폼 주의</span>` : before.trim() ? html` <span class="chip">지금 글을 바꿔요</span>` : ''}</span>
        <span class="pf-cols"><span class="pf-before">${before || '(비어 있음)'}</span><span class="pf-after">${p.after}</span></span>
      </label>`;
    })}</div>
    <div class="acts"><button class="btn" data-no>취소</button><button class="btn pri" data-yes>고른 칸 넣기</button></div>`,
    (m, close) => {
      m.classList.add('wide');
      $('[data-no]', m).onclick = () => close(undefined);
      $('[data-yes]', m).onclick = () => close($$('[data-i]:checked', m).map((b) => proposals[Number(b.dataset.i)]));
    },
  );
}
