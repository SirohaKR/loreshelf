// 설정 — 이름, 대화용 별명, 화면 테마, 비밀번호, 로그아웃.
import { api } from '../api.js';
import { $, $$, attempt, html, render as put } from '../ui.js';

export async function render(el, _params, _query, app) {
  const theme = app.settings.theme || 'system';
  put(
    el,
    html`<h1 style="margin-bottom:18px">설정</h1>
    <div class="grid" style="max-width:640px">
      <form class="card form" data-profile><h3>내 정보</h3>
        <label class="f">이름 <small>화면과 블로그에 보여요</small><input type="text" name="display_name" value="${app.user.display_name}" maxlength="30"></label>
        <div class="sub">아이디: ${app.user.login_name}</div>
        <div><button class="btn pri">저장</button></div></form>

      <form class="card form" data-chat><h3>챗봇 대화</h3>
        <label class="f">대화용 별명 <small>챗봇 미리보기에서 {{user}} 자리에 들어가요. 비우면 이름(${app.user.display_name})을 써요</small>
          <input type="text" name="chat_nickname" value="${app.settings.chat_nickname || ''}" maxlength="30" placeholder="${app.user.display_name}"></label>
        <div><button class="btn pri">저장</button></div></form>

      <div class="card"><h3>화면 테마</h3><div class="filters" style="margin:0">
        ${[['system', '기기 설정 따라가기'], ['light', '밝게'], ['dark', '어둡게']].map(
          ([v, label]) => html`<button class="chip ${theme === v ? 'a' : ''}" data-theme="${v}">${label}</button>`,
        )}</div></div>

      <form class="card form" data-password><h3>비밀번호 바꾸기 <small>바꾸면 다른 기기는 로그아웃돼요</small></h3>
        <label class="f">지금 비밀번호<input type="password" name="old" autocomplete="current-password" required></label>
        <label class="f">새 비밀번호 <small>8자 이상</small><input type="password" name="new" autocomplete="new-password" minlength="8" required></label>
        <div><button class="btn pri">바꾸기</button></div></form>

      <div class="card" style="display:flex;justify-content:space-between;align-items:center;gap:10px">
        <div><b>로그아웃</b><div class="sub">이 기기에서 로그아웃해요</div></div><button class="btn danger" data-logout>로그아웃</button></div>
    </div>`,
  );
  $('[data-profile]', el).onsubmit = async (e) => {
    e.preventDefault();
    const r = await attempt(() => api.put('/api/account/profile', { display_name: e.currentTarget.display_name.value }), '저장했어요');
    app.user = r.user;
    $('.avatar-me').textContent = [...r.user.display_name][0];
  };
  $('[data-chat]', el).onsubmit = async (e) => {
    e.preventDefault();
    app.settings = await attempt(() => api.put('/api/settings', { chat_nickname: e.currentTarget.chat_nickname.value.trim() }), '저장했어요');
  };
  $$('[data-theme]', el).forEach(
    (b) =>
      (b.onclick = async () => {
        await attempt(() => api.put('/api/settings', { theme: b.dataset.theme }));
        app.setTheme(b.dataset.theme);
        $('[data-chat]', el).onsubmit = async (e) => {
    e.preventDefault();
    app.settings = await attempt(() => api.put('/api/settings', { chat_nickname: e.currentTarget.chat_nickname.value.trim() }), '저장했어요');
  };
  $$('[data-theme]', el).forEach((x) => x.classList.toggle('a', x === b));
      }),
  );
  $('[data-password]', el).onsubmit = async (e) => {
    e.preventDefault();
    const f = e.currentTarget;
    await attempt(() => api.put('/api/account/password', { old: f.old.value, new: f.new.value }), '비밀번호를 바꿨어요');
    f.reset();
  };
  $('[data-logout]', el).onclick = () => app.logout();
}
