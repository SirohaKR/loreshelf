// 챗봇 설정 — 캐릭터 상세의 "챗봇 설정" 탭(작품 목록)과 작품 로드맵(간편 모드).
// 간편 모드: 가운데 스토리 카드에 나머지 카드를 붙인다 = 카드 하나 + 스토리 카드로 가는 선 하나.
// 기획: docs/planning/챗봇-설정-기획서.md 2절
import { api, assetUrl } from '../api.js';
import { $, $$, ago, attempt, confirmDialog, html, openMenu, openModal, render as put, toast } from '../ui.js';
import {
  PLATFORM_NAME, checkLimit, invalidNotationCount, loadMeta, nodeLevel, rofanDetailCheck, rofanDetailParts, storyWarnings, textFields, worse,
} from './chatbot_kit.js';

// 카드 종류 → 아이콘 · 색 (style.css 의 --accent/--ok/--warn/--rose 와 각 -soft)
export const KIND_ICON = {
  story: 'S', character: '☺', extra_cast: '+', user: '나', image: '▦', macro: '#', preset_note: '◐',
  variable: 'x', update_rule: '↻', trigger: 'ϟ', status_view: '▤', achievement: '★', hub: '◎',
};
export const KIND_TONE = {
  story: 'accent', character: 'rose', extra_cast: 'rose', user: 'accent', image: 'accent', macro: 'warn', preset_note: 'warn',
  variable: 'ok', update_rule: 'ok', trigger: 'warn', status_view: 'accent', achievement: 'warn', hub: 'accent',
};

// "카드 붙이기" 줄에 보이는 종류 (스토리는 하나뿐, 허브는 캔버스 모드 3-8)
const ATTACHABLE = ['character', 'extra_cast', 'user', 'image', 'macro', 'preset_note', 'variable', 'update_rule', 'trigger', 'status_view', 'achievement'];
const LATER = { status_view: '상태창은 3-5에서 만들어요' };

// 로드맵 묶음 (목업 chatbot-roadmap.html 순서)
const GROUPS = [
  { label: '인물', kinds: ['character', 'extra_cast'] },
  { label: '유저', kinds: ['user'] },
  { label: '이미지', kinds: ['image'] },
  { label: '매크로 프롬프트', kinds: ['macro'] },
  { label: '변수 · 규칙 · 트리거', kinds: ['variable', 'update_rule', 'trigger'], note: '로플 캔버스' },
  { label: '상태창', kinds: ['status_view'], note: '3-5' },
  { label: '프리셋 노트', kinds: ['preset_note'] },
  { label: '업적', kinds: ['achievement'], note: '로플 캔버스' },
];

const byOrder = (a, b) => a.sort_order - b.sort_order || a.id - b.id;
const firstLine = (s) => (s || '').split('\n').find((l) => l.trim()) || '';
const kindIcon = (kind, cls = '') => html`<span class="kind-ic ${cls}" style="--tone:var(--${KIND_TONE[kind]});--tone-soft:var(--${KIND_TONE[kind]}-soft)">${KIND_ICON[kind]}</span>`;

// ───── 캐릭터 상세의 "챗봇 설정" 탭 ─────

/** 이 캐릭터가 대표인 작품 목록 + 만들기 */
export async function renderCharacterTab(el, c, app) {
  const list = await api.get(`/api/chatbot/stories?character_id=${c.id}`);
  put(
    el,
    list.length
      ? html`<div class="page-head"><div class="sub">한 캐릭터로 작품(스토리)을 여러 개 만들 수 있어요. 예) 로맨스판 · 학원판</div><div class="sp"></div>
          <button class="btn pri" data-new-story>+ 새 챗봇 설정</button></div>
        <div class="grid cb-stories">${list.map(
          (s) => html`<a class="card cb-story-row" href="#/chatbot/${s.id}">
            ${kindIcon('story')}
            <div class="grow"><b>${s.title}</b><div class="sub">카드 ${s.node_count}장 · ${s.edit_mode === 'canvas' ? '캔버스' : '간편'} 모드 · ${ago(s.updated_at)} 수정</div></div>
            <div class="chips">${s.target_platforms.map((p) => html`<span class="chip">${PLATFORM_NAME[p]}</span>`)}</div>
            <span class="go">›</span></a>`,
        )}</div>`
      : html`<div class="card empty-state"><b>아직 챗봇 설정이 없어요</b>스토리 카드를 가운데 두고 인물·유저·매크로·프리셋 노트 같은 카드를 붙여서<br>로판AI·로플챗에 넣을 설정을 짜요.<br><button class="btn pri" data-new-story>+ 챗봇 설정 만들기</button></div>`,
  );
  $('[data-new-story]', el).onclick = () => createStory(c, app);
}

async function createStory(c, app) {
  const title = await openModal(
    html`<h2>새 챗봇 설정</h2>
    <form class="form" data-f>
      <label class="f">작품 제목 <small>플랫폼에 올릴 때 이름(로판 15자)과 따로 정할 수 있어요</small><input type="text" name="title" maxlength="100" value="${c.name}의 이야기" required></label>
      <div class="sub" style="margin:0">대표 캐릭터 <b>${c.name}</b>의 인물 카드가 같이 만들어져요.</div>
      <div class="acts"><button type="button" class="btn" data-no>취소</button><button class="btn pri">만들기</button></div>
    </form>`,
    (m, close) => {
      $('[data-no]', m).onclick = () => close(undefined);
      $('[data-f]', m).onsubmit = (e) => {
        e.preventDefault();
        close(e.currentTarget.elements.namedItem('title').value.trim());
      };
      $('input', m).select();
    },
  );
  if (!title) return;
  const story = await attempt(() => api.post('/api/chatbot/stories', { title, main_character_id: c.id, project_id: c.project_id }));
  const storyNode = story.nodes.find((n) => n.kind === 'story');
  await attempt(() =>
    api.post(`/api/chatbot/stories/${story.id}/nodes`, {
      kind: 'character', title: c.name, source_character_id: c.id, link_to_chatbot_node_id: storyNode.id, sort_order: 10,
      content: { one_line: c.tagline || '' },
    }),
  );
  toast('챗봇 설정을 만들었어요');
  app.navigate(`/chatbot/${story.id}`);
}

// ───── 로드맵 (간편 모드) ─────

export async function renderRoadmap(el, { id }, _query, app) {
  const [meta, first] = await Promise.all([loadMeta(), api.get(`/api/chatbot/stories/${id}`)]);
  let s = first;
  const storyNode = () => s.nodes.find((n) => n.kind === 'story');
  const linked = (n) => s.links.some((l) => l.from_chatbot_node_id === n.id && l.to_chatbot_node_id === storyNode()?.id);
  const reload = async () => {
    s = await api.get(`/api/chatbot/stories/${id}`);
    draw();
  };

  const draw = () => {
    const sn = storyNode();
    const back = s.main_character_id ? `#/characters/${s.main_character_id}?tab=chatbot` : '#/characters';
    put(
      el,
      html`<div class="crumb"><a href="${back}">${s.main_character_name || '캐릭터'}</a> › 챗봇 설정</div>
      <div class="page-head cb-head">
        ${kindIcon('story', 'lg')}
        <div><h1>${s.title}</h1><div class="sub">${s.target_platforms.map((p) => PLATFORM_NAME[p]).join(' · ')}에 내보낼 설정 · ${ago(s.updated_at)} 수정</div></div>
        <div class="sp"></div>
        <div class="seg"><a class="on">간편 (카드)</a><a title="3-8에서 만들어요" class="off">캔버스</a></div>
        <button class="btn" disabled title="3-4에서 만들어요">⇩ 내보내기</button>
        <span class="menu-wrap"><button class="btn" data-more>⋯</button></span>
      </div>
      <div class="cb-wrap">
        <div class="cb-main">
          <div class="card cb-attach"><span class="sub">카드 붙이기</span>${ATTACHABLE.map(
            (k) => html`<button class="btn sm" data-add="${k}" ${LATER[k] ? html`disabled title="${LATER[k]}"` : ''}>${kindIcon(k, 'sm')}${meta.kind_labels[k]}</button>`,
          )}</div>
          ${sn ? storyCard(sn) : html`<div class="card empty-state"><b>스토리 카드가 없어요</b></div>`}
          <div class="cb-groups">${GROUPS.map(groupCard)}</div>
        </div>
        <aside class="cb-side">${overview()}</aside>
      </div>`,
    );
    bind();
  };

  const storyCard = (n) => {
    const c = n.content;
    const cell = (label, value, check, extra = '') =>
      html`<a class="cb-cell ${value ? '' : 'empty'}" href="#/chatbot/${s.id}/nodes/${n.id}">
        <b>${label}</b><span class="ln">${value || '비어 있음'}${extra}</span>
        ${check ? html`<small class="lv-${check.level}">${PLATFORM_NAME[check.platform]} ${check.display}</small>` : ''}</a>`;
    const keyKey = s.edit_mode === 'canvas' ? 'rplay.story.key_info' : 'rplay_simple.story.key_info';
    const starts = c.start_messages || [];
    return html`<div class="card cb-story">
      <div class="cb-story-h">${kindIcon('story')}<div class="grow"><b>스토리 · ${n.title}</b><div class="sub">모든 카드는 여기에 이어져야 내보내져요</div></div>
        ${c.is_start ? html`<span class="chip ok">시작 노드</span>` : ''}
        <a class="btn" href="#/chatbot/${s.id}/nodes/${n.id}">✎ 편집</a></div>
      <div class="cb-cells">
        ${cell('중요 정보', firstLine(c.key_info), checkLimit(meta, keyKey, c.key_info || ''))}
        ${cell('전체 스토리', firstLine(c.full_story), c.full_story ? checkLimit(meta, 'rplay.story.full_story', c.full_story) : null)}
        ${cell(`시작 메시지 ${starts.length}개`, starts.map((m) => m.name || '이름 없음').join(' · '), starts.length ? worstOf(starts.map((m) => checkLimit(meta, 'rofan.start.body', m.body || ''))) : null)}
        ${cell('시작 가이드', firstLine(c.start_guide), c.start_guide ? checkLimit(meta, 'rplay.story.start_guide', c.start_guide) : null)}
        ${cell('크리에이터 공지', firstLine(c.creator_notice), c.creator_notice ? checkLimit(meta, 'rplay.story.creator_notice', c.creator_notice) : null)}
      </div>
    </div>`;
  };

  const groupCard = (g) => {
    const nodes = s.nodes.filter((n) => g.kinds.includes(n.kind)).sort(byOrder);
    const addable = g.kinds.filter((k) => !LATER[k]);
    return html`<div class="card cb-group">
      <div class="cb-group-h">${kindIcon(g.kinds[0])}<b>${g.label}</b><span class="chip">${nodes.length}</span><span class="sp"></span>${g.note ? html`<span class="chip">${g.note}</span>` : ''}</div>
      ${nodes.map((n, i) => nodeRow(n, i, nodes.length))}
      ${addable.length
        ? html`<div class="cb-add-row">${addable.map((k) => html`<button class="linkish" data-add="${k}">+ ${meta.kind_labels[k]}</button>`)}</div>`
        : html`<div class="sub">${LATER[g.kinds[0]]}</div>`}
    </div>`;
  };

  const nodeRow = (n, i, len) => {
    const level = nodeLevel(meta, n, s.edit_mode);
    const bad = invalidNotationCount(n, s.edit_mode);
    const main = textFields(n, s.edit_mode).find((f) => f.limits.some((k) => k !== 'rofan.detail' && meta.limits[k]?.platform === 'rplay'));
    const mainCheck = main ? checkLimit(meta, main.limits.find((k) => meta.limits[k]?.platform === 'rplay'), main.text) : null;
    return html`<div class="cb-node ${n.is_enabled ? '' : 'off'}" data-node="${n.id}">
      ${n.kind === 'image' && n.content.asset_id ? html`<img class="thumb" src="${assetUrl(n.content.asset_id)}" alt="">` : ''}
      <a class="grow" href="#/chatbot/${s.id}/nodes/${n.id}">
        <b>${n.title}${n.kind === 'character' ? html` <code class="n-char">{{char}}</code>` : ''}${n.kind === 'variable' && n.content.name ? html` <code class="n-variable">{{var_${n.content.name}}}</code>` : ''}</b>
        <span class="ln">${nodeSummary(n)}</span>
        <span class="flags">${mainCheck && main.text ? html`<small class="cnt lv-${worse(level, mainCheck.level)}">${PLATFORM_NAME[mainCheck.platform]} ${mainCheck.display}</small>` : level !== 'ok' ? html`<small class="cnt lv-${level}">${level === 'over' ? '초과' : '거의 참'}</small>` : ''}${n.is_enabled ? '' : html`<span class="chip">꺼 둠</span>`}${linked(n) ? '' : html`<span class="chip warn" title="간편 모드에선 스토리에 이어져야 내보내져요">스토리에 안 이어짐</span>`}${bad ? html`<span class="chip warn">표기 ${bad}개 고치기</span>` : ''}</span>
      </a>
      <div class="ops">
        <button class="x-btn" data-move="${n.id}" data-dir="-1" ${i === 0 ? 'disabled' : ''} title="위로" aria-label="위로">↑</button>
        <button class="x-btn" data-move="${n.id}" data-dir="1" ${i === len - 1 ? 'disabled' : ''} title="아래로" aria-label="아래로">↓</button>
        <span class="menu-wrap"><button class="x-btn" data-node-menu="${n.id}" aria-label="더보기">⋯</button></span>
      </div>
    </div>`;
  };

  const nodeSummary = (n) => {
    const c = n.content;
    switch (n.kind) {
      case 'character':
        return c.one_line || firstLine(c.key_info) || '중요 정보를 채워 주세요';
      case 'extra_cast':
        return (c.people || []).map((p) => p.name).filter(Boolean).join(' · ') || '조연을 한 줄에 한 사람씩';
      case 'user':
        return `${c.name || '{{user}}'} · ${firstLine(c.body) || '설정 없음'}`;
      case 'image':
        return `${{ emotion: '감정', situation: '상황', background: '배경' }[c.usage]} · ${(c.tags || []).join(', ') || firstLine(c.description) || '태그 없음'}`;
      case 'macro':
        return `${c.mode === 'always' ? '항상' : `낱말: ${(c.keywords || []).join(', ') || '없음'}`} · 우선순위 ${c.priority} · ${c.duration_turns}턴`;
      case 'preset_note':
        return (c.notes || []).map((x) => `${x.emoji}${x.title}`).join(' · ') || '프리셋 없음';
      case 'variable':
        return `${{ number: '숫자', boolean: '참/거짓', text: '문자' }[c.value_kind]}${c.initial_value ? ` · 처음 ${c.initial_value}` : ''}`;
      case 'update_rule':
        return firstLine(c.body) || '규칙을 적어 주세요';
      case 'trigger':
        return `조건 ${(c.conditions || []).length}개 → 동작 ${(c.actions || []).length}개`;
      case 'achievement':
        return `${c.is_hidden ? '히든 · ' : ''}${firstLine(c.description) || '설명 없음'}`;
      default:
        return '';
    }
  };

  /** 오른쪽 "한눈에 보기": 채운 칸 · 경고 · 초과, 로판 세부 설정 합계 막대, 알림 */
  const overview = () => {
    const fields = s.nodes.filter((n) => n.is_enabled).flatMap((n) => textFields(n, s.edit_mode));
    const filled = fields.filter((f) => f.text.trim()).length;
    const warns = storyWarnings(meta, s);
    const over = warns.filter((w) => w.check.level === 'over').length;
    const detail = rofanDetailCheck(meta, s.nodes);
    const parts = rofanDetailParts(s.nodes);
    const bad = s.nodes.reduce((sum, n) => sum + invalidNotationCount(n, s.edit_mode), 0);
    const loose = s.nodes.filter((n) => n.kind !== 'story' && !linked(n));
    const scale = Math.max(detail.max, detail.count);
    return html`<div class="card">
      <h3>한눈에 보기 <small>한도 기준일 ${meta.limits_checked_on}</small></h3>
      <div class="cb-stats">
        <div><b>${filled}</b><span>채운 칸</span></div>
        <div class="lv-near"><b>${warns.length - over}</b><span>거의 참</span></div>
        <div class="lv-over"><b>${over}</b><span>초과</span></div>
      </div>
      <div class="cb-meter-h"><span>로판 세부 설정 ${detail.max.toLocaleString('en-US')}자</span><b class="lv-${detail.level}">${detail.count.toLocaleString('en-US')}</b></div>
      <div class="cb-meter">${parts.map((p, i) => (p.count ? html`<i class="p${i}" style="width:${(p.count / scale) * 100}%"></i>` : ''))}</div>
      <div class="cb-legend">${parts.map((p, i) => html`<span><i class="p${i}"></i>${p.source} ${p.count.toLocaleString('en-US')}</span>`)}</div>
      <h3 style="margin-top:18px">알림</h3>
      ${warns.length || bad || loose.length
        ? html`<div class="cb-alerts">
            ${warns.map((w) =>
              w.node
                ? html`<a class="cb-alert ${w.check.level}" href="#/chatbot/${s.id}/nodes/${w.node.id}">${meta.kind_labels[w.node.kind]} '${w.node.title}' ${w.label} — ${PLATFORM_NAME[w.check.platform]} ${w.check.display}</a>`
                : html`<div class="cb-alert ${w.check.level}">로판 세부 설정(세계관+캐릭터 소개+비밀) 합계 ${w.check.display}</div>`,
            )}
            ${bad ? html`<div class="cb-alert near">고칠 표기가 ${bad}개 있어요 (예: {{Char}} → {{char}}) · 카드에서 바꾸기</div>` : ''}
            ${loose.map((n) => html`<div class="cb-alert near">'${n.title}' 카드가 스토리에 안 이어져 있어요 <button class="linkish" data-link="${n.id}">잇기</button></div>`)}
          </div>`
        : html`<div class="sub">아직 넘친 칸이 없어요.</div>`}
      <div class="hint">로플 토큰은 입력 중 근사치(≈)예요. 플랫폼은 넘친 부분을 말없이 잘라요.</div>
    </div>`;
  };

  const bind = () => {
    $$('[data-add]', el).forEach((b) => (b.onclick = () => addNode(b.dataset.add)));
    $$('[data-move]', el).forEach((b) => (b.onclick = () => move(Number(b.dataset.move), Number(b.dataset.dir))));
    $$('[data-link]', el).forEach(
      (b) =>
        (b.onclick = async () => {
          await attempt(() => api.post(`/api/chatbot/stories/${s.id}/links`, { from_chatbot_node_id: Number(b.dataset.link), to_chatbot_node_id: storyNode().id }), '스토리에 이었어요');
          reload();
        }),
    );
    $$('[data-node-menu]', el).forEach(
      (b) =>
        (b.onclick = (e) => {
          e.stopPropagation();
          const n = s.nodes.find((x) => x.id === Number(b.dataset.nodeMenu));
          openMenu(b, [
            { label: n.is_enabled ? '◌ 꺼 두기 (내보낼 때 빼기)' : '● 다시 켜기', onClick: () => toggle(n) },
            'sep',
            { label: '🗑 카드 지우기', danger: true, onClick: () => removeNode(n) },
          ]);
        }),
    );
    $('[data-more]', el).onclick = (e) => {
      e.stopPropagation();
      openMenu(e.currentTarget, [
        { label: '✎ 작품 제목 바꾸기', onClick: rename },
        'sep',
        { label: '🗑 휴지통으로', danger: true, onClick: removeStory },
      ]);
    };
  };

  const addNode = async (kind) => {
    const same = s.nodes.filter((n) => n.kind === kind);
    const n = await attempt(() =>
      api.post(`/api/chatbot/stories/${s.id}/nodes`, {
        kind,
        title: same.length ? `${meta.kind_labels[kind]} ${same.length + 1}` : meta.kind_labels[kind],
        link_to_chatbot_node_id: storyNode()?.id,
        sort_order: (Math.max(0, ...same.map((x) => x.sort_order)) || 0) + 10,
      }),
    );
    app.navigate(`/chatbot/${s.id}/nodes/${n.id}`);
  };

  /** 같은 묶음 안에서 한 칸 위/아래로 — 묶음 전체 순서를 10, 20, 30…으로 다시 매김 */
  const move = async (nodeId, dir) => {
    const g = GROUPS.find((x) => x.kinds.includes(s.nodes.find((n) => n.id === nodeId).kind));
    const list = s.nodes.filter((n) => g.kinds.includes(n.kind)).sort(byOrder);
    const i = list.findIndex((n) => n.id === nodeId);
    const j = i + dir;
    if (j < 0 || j >= list.length) return;
    [list[i], list[j]] = [list[j], list[i]];
    const changed = list.map((n, k) => [n, (k + 1) * 10]).filter(([n, order]) => n.sort_order !== order);
    await attempt(() => Promise.all(changed.map(([n, order]) => api.put(`/api/chatbot/nodes/${n.id}`, { sort_order: order }))));
    reload();
  };

  const toggle = async (n) => {
    await attempt(() => api.put(`/api/chatbot/nodes/${n.id}`, { is_enabled: !n.is_enabled }), n.is_enabled ? '꺼 뒀어요' : '다시 켰어요');
    reload();
  };

  const removeNode = async (n) => {
    if (!(await confirmDialog(`'${n.title}' 카드를 지울까요?\n지운 카드는 되살릴 수 없어요.`, { okText: '지우기', danger: true }))) return;
    await attempt(() => api.del(`/api/chatbot/nodes/${n.id}`), '카드를 지웠어요');
    reload();
  };

  const rename = async () => {
    const title = await openModal(
      html`<h2>작품 제목</h2><form data-f><input type="text" name="title" maxlength="100" value="${s.title}" required>
        <div class="acts"><button type="button" class="btn" data-no>취소</button><button class="btn pri">바꾸기</button></div></form>`,
      (m, close) => {
        $('[data-no]', m).onclick = () => close(undefined);
        $('[data-f]', m).onsubmit = (e) => {
          e.preventDefault();
          close(e.currentTarget.elements.namedItem('title').value.trim());
        };
      },
    );
    if (!title || title === s.title) return;
    await attempt(() => api.put(`/api/chatbot/stories/${s.id}`, { title }), '제목을 바꿨어요');
    reload();
  };

  const removeStory = async () => {
    if (!(await confirmDialog(`'${s.title}' 챗봇 설정을 휴지통으로 옮길까요?`, { okText: '휴지통으로', danger: true }))) return;
    await attempt(() => api.del(`/api/chatbot/stories/${s.id}`), '휴지통으로 옮겼어요');
    app.navigate(s.main_character_id ? `/characters/${s.main_character_id}?tab=chatbot` : '/characters');
  };

  draw();
}

const worstOf = (checks) => checks.filter(Boolean).reduce((w, c) => (!w || worse(w.level, c.level) !== w.level ? c : w), null);
