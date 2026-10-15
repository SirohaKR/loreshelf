// 공통 사이드바 + 모바일 탭바 주입. <body data-nav="캐릭터"> 로 현재 메뉴 지정.
(function () {
  if (location.search.includes('dark')) document.documentElement.classList.add('dark');
  const on = document.body.dataset.nav || '';
  const item = (ic, name, cnt) =>
    `<a class="${on === name ? 'on' : ''}"><span class="ic">${ic}</span><span>${name}</span>${cnt ? `<span class="cnt">${cnt}</span>` : ''}</a>`;
  const side = `
  <aside class="side">
    <div class="brand"><div class="brand-mark">L</div><div><b>LoreShelf</b><small>내 캐릭터 서재</small></div></div>
    <button class="new-btn">+ <span>새로 만들기</span></button>
    <nav class="nav">
      ${item('⌂', '홈')}${item('☺', '캐릭터', 24)}${item('◎', '세계관', 3)}${item('▣', '프로젝트', 5)}
      <div class="nav-label">시각화</div>
      ${item('⋈', '관계도')}${item('↗', '타임라인')}${item('▦', '갤러리')}${item('✎', '메모')}
      <div class="nav-label">블로그</div>
      ${item('◐', '공개 설정')}${item('⇩', '내보내기·백업')}
    </nav>
    <div class="side-foot nav">${item('⚙', '설정')}</div>
  </aside>`;
  const tab = (ic, name) => `<a class="${on === name ? 'on' : ''}"><span class="ic">${ic}</span>${name}</a>`;
  const tabbar = `<nav class="tabbar">${tab('⌂', '홈')}${tab('☺', '캐릭터')}<a><span class="fab">+</span></a>${tab('▣', '프로젝트')}${tab('≡', '더보기')}</nav>`;
  const app = document.querySelector('.app');
  app.insertAdjacentHTML('afterbegin', side);
  document.body.insertAdjacentHTML('beforeend', tabbar);
})();
