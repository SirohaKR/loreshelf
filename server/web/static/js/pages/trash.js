// 휴지통 — 되살리기, 영구 삭제.
import { api } from '../api.js';
import { $$, ago, attempt, confirmDialog, html, render as put } from '../ui.js';

const LABEL = { characters: '캐릭터', worlds: '세계관', projects: '프로젝트', chatbot_stories: '챗봇 설정' };

export async function render(el, _params, _query, app) {
  const t = await api.get('/api/trash');
  const stories = t.chatbot_stories || [];
  const total = t.characters.length + t.worlds.length + t.projects.length + stories.length;
  const section = (kind, rows, note) =>
    rows.length
      ? html`<div class="sec-head"><h2>${LABEL[kind]} ${rows.length}</h2></div><div class="card" style="padding:6px 18px">${rows.map(
          (r) => html`<div class="list-row"><div class="grow"><b>${r.name}</b><span class="sub">${ago(r.deleted_at)} 지움${note(r)}</span></div>
            <button class="btn sm" data-restore="${kind}/${r.id}">되살리기</button>
            <button class="btn sm danger" data-purge="${kind}/${r.id}" data-name="${r.name}" data-own="${r.own_character_count ?? 0}">영구 삭제</button></div>`,
        )}</div>`
      : '';
  put(
    el,
    html`<h1>휴지통</h1><div class="sub" style="margin-bottom:18px">지운 것을 되살리거나 영구 삭제해요. 영구 삭제는 되돌릴 수 없어요.</div>
    ${total ? '' : html`<div class="card empty-state"><b>휴지통이 비어 있어요</b></div>`}
    ${section('characters', t.characters, (r) => (r.project_name ? ` · ${r.project_name} 전용` : ''))}
    ${section('worlds', t.worlds, () => '')}
    ${section('projects', t.projects, (r) => (r.own_character_count ? ` · 전용 캐릭터 ${r.own_character_count}명` : ''))}
    ${section('chatbot_stories', stories, (r) => (r.main_character_name ? ` · ${r.main_character_name}` : ''))}`,
  );
  $$('[data-restore]', el).forEach(
    (b) =>
      (b.onclick = async () => {
        await attempt(() => api.post(`/api/trash/${b.dataset.restore}/restore`), '되살렸어요');
        app.refreshNav();
        render(el, _params, _query, app);
      }),
  );
  $$('[data-purge]', el).forEach(
    (b) =>
      (b.onclick = async () => {
        const own = Number(b.dataset.own);
        const msg = `'${b.dataset.name}'을(를) 영구 삭제할까요? 되돌릴 수 없어요.${own ? `\n이 프로젝트 전용 캐릭터 ${own}명도 같이 영구 삭제돼요. 남기고 싶으면 먼저 되살려서 서재로 꺼내 주세요.` : ''}`;
        if (!(await confirmDialog(msg, { title: '영구 삭제', okText: '영구 삭제', danger: true }))) return;
        await attempt(() => api.del(`/api/trash/${b.dataset.purge}`), '영구 삭제했어요');
        render(el, _params, _query, app);
      }),
  );
}
