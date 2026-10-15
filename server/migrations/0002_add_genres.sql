-- 0002_add_genres — 장르·세계관 태그 (로판, 현판, 학원, 청춘, 복수 …)
-- 세계관은 프로젝트마다 따로 쓰므로, 프로젝트에는 미리 준비된 태그 목록에서 골라 붙인다.
-- user_id 가 NULL이면 기본 제공 태그, 값이 있으면 사용자가 직접 추가한 태그.

-- 장르·세계관 태그 목록
CREATE TABLE genres (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER REFERENCES users(id) ON DELETE CASCADE,          -- NULL = 기본 제공
  category       TEXT    NOT NULL CHECK (category IN ('genre', 'setting', 'mood', 'trope', 'game', 'custom')),
  name           TEXT    NOT NULL,
  sort_order     INTEGER NOT NULL DEFAULT 0,
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);
-- 같은 사람(기본 제공 포함) 안에서 이름이 겹치지 않게
CREATE UNIQUE INDEX uq_genres_user_id_name ON genres (COALESCE(user_id, 0), name);

-- 프로젝트 ↔ 장르 태그
CREATE TABLE project_genres (
  id             INTEGER PRIMARY KEY,
  project_id     INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  genre_id       INTEGER NOT NULL REFERENCES genres(id) ON DELETE CASCADE,
  UNIQUE (project_id, genre_id)
);
CREATE INDEX idx_project_genres_genre_id ON project_genres (genre_id);

-- 기본 제공 태그 (category, 이름 순서대로 sort_order)
INSERT INTO genres (category, name, sort_order)
SELECT category, name, ord FROM (
  SELECT 'genre' AS category, value AS name, key AS ord FROM json_each('["로맨스 판타지","현대 판타지","판타지","로맨스","현대 로맨스","무협","선협","SF","아포칼립스","디스토피아","사이버펑크","스팀펑크","대체역사","호러","미스터리","추리","스릴러","액션","드라마","일상","코미디","BL","GL","스포츠","음악","요리","의학","법정","밀리터리"]')
  UNION ALL
  SELECT 'setting', value, key FROM json_each('["학원","아카데미","마법학교","궁정","기사단","던전","탑","이세계","게임 속","소설 속","서양풍 중세","동양풍","조선","중화풍","일본풍","빅토리아풍","근현대","현대 도시","시골","회사","연예계","아이돌","편의점·카페","병원","군대","우주","바다·해적","사막","설원","지하 세계"]')
  UNION ALL
  SELECT 'mood', value, key FROM json_each('["청춘","성장","복수","구원","힐링","다크","피폐","집착","후회","계약","정략결혼","신분 차이","앙숙","소꿉친구","첫사랑","짝사랑","삼각관계","우정","가족","생존","전쟁","정치·암투","음모","비극","해피엔딩","개그","잔잔함","달달함","긴장감"]')
  UNION ALL
  SELECT 'trope', value, key FROM json_each('["회귀","빙의","환생","전생","이세계 전이","타임루프","시간 여행","착각","시스템·상태창","헌터","각성","게이트","마왕","용사","성녀","악녀","악역 영애","흑막","공작가","황태자","기사","마법사","용","수인","뱀파이어","엘프","정령","신·신화","저주","계약 결혼"]')
  UNION ALL
  SELECT 'game', value, key FROM json_each('["캐릭터챗","RPG","턴제","액션 RPG","로그라이크","비주얼노벨","연애 시뮬레이션","육성 시뮬레이션","방치형","퍼즐","리듬","카드·덱빌딩","생존 게임","오픈월드","메트로배니아","방탈출","TRPG"]')
);
