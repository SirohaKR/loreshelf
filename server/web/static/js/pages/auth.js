// 로그인 / 처음 계정 만들기 화면.
import { api } from '../api.js';
import { $, formData, html, render } from '../ui.js';

export function renderAuth(root, needsSetup, onDone) {
  render(
    root,
    html`<div class="auth-page"><div class="card auth-card">
      <div class="brand"><div class="brand-mark">L</div><div><b>LoreShelf</b><small>내 캐릭터 서재</small></div></div>
      <h2 style="text-align:center;margin-bottom:4px">${needsSetup ? '처음 오셨네요' : '로그인'}</h2>
      <p class="sub" style="text-align:center;margin:0 0 18px">${needsSetup ? '이 서재의 주인 계정을 만들어 주세요. 계정은 하나만 만들 수 있어요.' : '다시 오신 걸 환영해요.'}</p>
      <form class="form" data-auth>
        <label class="f">아이디<input type="text" name="login_name" autocomplete="username" required minlength="2" maxlength="30"></label>
        ${needsSetup ? html`<label class="f">이름 <small>화면과 블로그에 보여요</small><input type="text" name="display_name" maxlength="30"></label>` : ''}
        <label class="f">비밀번호${needsSetup ? html` <small>8자 이상</small>` : ''}
          <input type="password" name="password" autocomplete="${needsSetup ? 'new-password' : 'current-password'}" required minlength="${needsSetup ? 8 : 1}"></label>
        <div class="err" data-err hidden></div>
        <button class="btn pri" style="justify-content:center;padding:11px">${needsSetup ? '계정 만들고 시작하기' : '로그인'}</button>
      </form>
    </div></div>`,
  );
  const form = $('[data-auth]', root);
  form.onsubmit = async (e) => {
    e.preventDefault();
    const btn = form.querySelector('button');
    const err = $('[data-err]', root);
    btn.disabled = true;
    err.hidden = true;
    try {
      await api.post(needsSetup ? '/api/auth/setup' : '/api/auth/login', formData(form));
      onDone();
    } catch (ex) {
      err.textContent = ex.message;
      err.hidden = false;
      btn.disabled = false;
    }
  };
}
