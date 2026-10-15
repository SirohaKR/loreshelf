-- =====================================================================
-- 0001_init — LoreShelf 첫 스키마 (SQLite)
-- 이름 규칙: docs/DB-설계.md. 이 파일은 절대 고치지 말고, 바꿀 땐 0002_….sql을 새로 만든다.
-- 연결할 때마다 PRAGMA foreign_keys = ON; 필수 (SQLite는 기본이 꺼짐)
--
-- 공통 약속
--   id            모든 테이블의 기본키 INTEGER
--   *_id          다른 테이블 참조 (참조테이블 단수형 + _id)
--   *_at          시각, TEXT 'YYYY-MM-DDTHH:MM:SSZ' (UTC)
--   is_*          참/거짓, INTEGER 0 또는 1
--   *_json        JSON 문자열 (json_valid 검사)
--   *_md          마크다운 본문
--   sort_order    화면 정렬 순서 (작을수록 위)
--   deleted_at    휴지통 (NULL이면 살아 있음)
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. 계정 · 설정  (features/auth, features/settings)
-- ---------------------------------------------------------------------

-- 사용자. 1인용으로 시작하지만 나중에 계정을 늘릴 수 있게 처음부터 둠
CREATE TABLE users (
  id             INTEGER PRIMARY KEY,
  login_name     TEXT    NOT NULL UNIQUE,                 -- 로그인 아이디
  password_hash  TEXT    NOT NULL,
  display_name   TEXT    NOT NULL,                        -- 화면·블로그에 보이는 이름
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);

-- 로그인 세션
CREATE TABLE sessions (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash     TEXT    NOT NULL UNIQUE,                 -- 쿠키 토큰의 해시 (원문은 저장 안 함)
  expires_at     TEXT    NOT NULL,
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);

-- 사용자별 설정 (테마, API 키, 블로그 제목, 월 AI 상한액 …)
CREATE TABLE settings (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name           TEXT    NOT NULL,                        -- 예: 'theme', 'claude_api_key', 'blog_title'
  value          TEXT,
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  UNIQUE (user_id, name)
);

-- ---------------------------------------------------------------------
-- 2. 파일 · 태그  (features/assets, features/tags)
-- ---------------------------------------------------------------------

-- 업로드한 파일 (이미지, ComfyUI 워크플로 등). 실제 파일은 data/assets/ 아래
CREATE TABLE assets (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  file_path      TEXT    NOT NULL UNIQUE,                 -- data/assets/ 기준 상대 경로
  original_name  TEXT    NOT NULL,                        -- 올릴 때 파일 이름
  mime_type      TEXT    NOT NULL,                        -- 예: 'image/png'
  byte_size      INTEGER NOT NULL,
  width          INTEGER,                                 -- 이미지일 때만
  height         INTEGER,
  sha256         TEXT    NOT NULL,                        -- 같은 파일 중복 업로드 확인용
  caption        TEXT,
  is_public      INTEGER NOT NULL DEFAULT 0 CHECK (is_public IN (0, 1)),  -- 블로그에 보여도 되는지
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  deleted_at     TEXT
);
CREATE INDEX idx_assets_sha256 ON assets (sha256);

-- 태그 (#은발, #복선 …). 캐릭터·메모·보드 카드가 같이 씀
CREATE TABLE tags (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name           TEXT    NOT NULL,                        -- '#' 없이 저장
  color          TEXT,                                    -- '#RRGGBB'
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  UNIQUE (user_id, name)
);

-- ---------------------------------------------------------------------
-- 3. 세계관 · 프로젝트  (features/worlds, features/projects)
-- ---------------------------------------------------------------------

CREATE TABLE worlds (
  id               INTEGER PRIMARY KEY,
  user_id          INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name             TEXT    NOT NULL,
  summary          TEXT,                                  -- 한 줄 소개
  body_md          TEXT,
  cover_asset_id   INTEGER REFERENCES assets(id) ON DELETE SET NULL,
  visibility       TEXT    NOT NULL DEFAULT 'private' CHECK (visibility IN ('private', 'unlisted', 'public')),
  sort_order       INTEGER NOT NULL DEFAULT 0,
  created_at       TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at       TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  deleted_at       TEXT
);

-- 프로젝트 = 게임 / 챗봇 / 기타 작품 단위
CREATE TABLE projects (
  id               INTEGER PRIMARY KEY,
  user_id          INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  world_id         INTEGER REFERENCES worlds(id) ON DELETE SET NULL,
  kind             TEXT    NOT NULL CHECK (kind IN ('game', 'chatbot', 'etc')),
  name             TEXT    NOT NULL,
  summary          TEXT,
  body_md          TEXT,
  cover_asset_id   INTEGER REFERENCES assets(id) ON DELETE SET NULL,
  progress_percent INTEGER NOT NULL DEFAULT 0 CHECK (progress_percent BETWEEN 0 AND 100),
  visibility       TEXT    NOT NULL DEFAULT 'private' CHECK (visibility IN ('private', 'unlisted', 'public')),
  sort_order       INTEGER NOT NULL DEFAULT 0,
  created_at       TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at       TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  deleted_at       TEXT
);

-- ---------------------------------------------------------------------
-- 4. 캐릭터  (features/characters)
-- ---------------------------------------------------------------------

-- 기본 정보 칸 묶음 (판타지 / 현대 / 챗봇 전용 …)
CREATE TABLE character_templates (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name           TEXT    NOT NULL,
  fields_json    TEXT    NOT NULL DEFAULT '[]' CHECK (json_valid(fields_json)),  -- ["나이", "생일", "키", …]
  sort_order     INTEGER NOT NULL DEFAULT 0,
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);

-- 캐릭터. project_id가 있으면 그 프로젝트 전용, NULL이면 공용 서재
CREATE TABLE characters (
  id                       INTEGER PRIMARY KEY,
  user_id                  INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  world_id                 INTEGER REFERENCES worlds(id) ON DELETE SET NULL,
  project_id               INTEGER REFERENCES projects(id) ON DELETE CASCADE,          -- 전용 캐릭터의 소속 프로젝트
  source_character_id      INTEGER REFERENCES characters(id) ON DELETE SET NULL,      -- 분기했을 때 원본
  character_template_id    INTEGER REFERENCES character_templates(id) ON DELETE SET NULL,
  name                     TEXT    NOT NULL,
  name_en                  TEXT,                          -- 영문 이름 (챗봇 카드, 프롬프트 트리거에도 씀)
  tagline                  TEXT,                          -- 한 줄 소개
  quote                    TEXT,                          -- 대표 한 줄 대사
  theme_color              TEXT,                          -- '#RRGGBB'
  portrait_asset_id        INTEGER REFERENCES assets(id) ON DELETE SET NULL,
  body_md                  TEXT,                          -- 배경 이야기
  visibility               TEXT    NOT NULL DEFAULT 'private' CHECK (visibility IN ('private', 'unlisted', 'public')),
  is_card_downloadable     INTEGER NOT NULL DEFAULT 0 CHECK (is_card_downloadable IN (0, 1)),  -- 블로그에서 챗봇 카드 받기 허용
  is_favorite              INTEGER NOT NULL DEFAULT 0 CHECK (is_favorite IN (0, 1)),
  sort_order               INTEGER NOT NULL DEFAULT 0,
  created_at               TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at               TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  deleted_at               TEXT
);
CREATE INDEX idx_characters_project_id ON characters (project_id);
CREATE INDEX idx_characters_world_id ON characters (world_id);

-- 기본 정보 칸 (나이: 23세). is_secret=1이면 블로그에서 서버가 아예 빼고 보냄
CREATE TABLE character_fields (
  id             INTEGER PRIMARY KEY,
  character_id   INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  label          TEXT    NOT NULL,
  value          TEXT,
  is_secret      INTEGER NOT NULL DEFAULT 0 CHECK (is_secret IN (0, 1)),
  sort_order     INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_character_fields_character_id ON character_fields (character_id);

-- 성격 축 (내향 ←→ 외향, 0~100)
CREATE TABLE character_traits (
  id             INTEGER PRIMARY KEY,
  character_id   INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  left_label     TEXT    NOT NULL,
  right_label    TEXT    NOT NULL,
  value_percent  INTEGER NOT NULL DEFAULT 50 CHECK (value_percent BETWEEN 0 AND 100),
  sort_order     INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_character_traits_character_id ON character_traits (character_id);

-- 대표 대사 (챗봇 예시 대화로 가져다 씀)
CREATE TABLE character_quotes (
  id             INTEGER PRIMARY KEY,
  character_id   INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  body           TEXT    NOT NULL,
  situation      TEXT,                                    -- '처음 만났을 때'
  is_secret      INTEGER NOT NULL DEFAULT 0 CHECK (is_secret IN (0, 1)),
  sort_order     INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_character_quotes_character_id ON character_quotes (character_id);

-- 캐릭터 사이 관계 (관계도)
CREATE TABLE character_relations (
  id                 INTEGER PRIMARY KEY,
  from_character_id  INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  to_character_id    INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  label              TEXT    NOT NULL,                    -- '빚진 사이'
  direction          TEXT    NOT NULL DEFAULT 'two_way' CHECK (direction IN ('one_way', 'two_way')),
  color              TEXT,
  note               TEXT,
  is_secret          INTEGER NOT NULL DEFAULT 0 CHECK (is_secret IN (0, 1)),
  sort_order         INTEGER NOT NULL DEFAULT 0,
  CHECK (from_character_id <> to_character_id)
);
CREATE INDEX idx_character_relations_from_character_id ON character_relations (from_character_id);
CREATE INDEX idx_character_relations_to_character_id ON character_relations (to_character_id);

-- 갤러리 (캐릭터 ↔ 파일)
CREATE TABLE character_assets (
  id             INTEGER PRIMARY KEY,
  character_id   INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  asset_id       INTEGER NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
  sort_order     INTEGER NOT NULL DEFAULT 0,
  UNIQUE (character_id, asset_id)
);

-- 캐릭터 ↔ 태그
CREATE TABLE character_tags (
  id             INTEGER PRIMARY KEY,
  character_id   INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  tag_id         INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  UNIQUE (character_id, tag_id)
);

-- 공용 서재 캐릭터를 프로젝트에 "연결" (전용 캐릭터는 characters.project_id로 이미 소속)
CREATE TABLE project_characters (
  id             INTEGER PRIMARY KEY,
  project_id     INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  character_id   INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  role           TEXT,                                    -- '주인공', 'NPC', '보스'
  sort_order     INTEGER NOT NULL DEFAULT 0,
  UNIQUE (project_id, character_id)
);

-- ---------------------------------------------------------------------
-- 5. 문서 · 메모 · 연표  (features/docs, features/memos, features/timeline)
-- ---------------------------------------------------------------------

-- 설정 문서. 세계관 / 프로젝트 / 캐릭터 중 정확히 하나에 속함
CREATE TABLE docs (
  id             INTEGER PRIMARY KEY,
  world_id       INTEGER REFERENCES worlds(id) ON DELETE CASCADE,
  project_id     INTEGER REFERENCES projects(id) ON DELETE CASCADE,
  character_id   INTEGER REFERENCES characters(id) ON DELETE CASCADE,
  title          TEXT    NOT NULL,
  body_md        TEXT,
  visibility     TEXT    NOT NULL DEFAULT 'private' CHECK (visibility IN ('private', 'unlisted', 'public')),
  sort_order     INTEGER NOT NULL DEFAULT 0,
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  deleted_at     TEXT,
  CHECK ((world_id IS NOT NULL) + (project_id IS NOT NULL) + (character_id IS NOT NULL) = 1)
);

-- 빠른 메모
CREATE TABLE memos (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  body           TEXT    NOT NULL,
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  deleted_at     TEXT
);

CREATE TABLE memo_tags (
  id             INTEGER PRIMARY KEY,
  memo_id        INTEGER NOT NULL REFERENCES memos(id) ON DELETE CASCADE,
  tag_id         INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  UNIQUE (memo_id, tag_id)
);

-- 연표 사건. 작품 속 날짜는 자유 글('왕국력 312년 겨울'), 순서는 sort_order로
CREATE TABLE timeline_events (
  id             INTEGER PRIMARY KEY,
  world_id       INTEGER REFERENCES worlds(id) ON DELETE CASCADE,
  project_id     INTEGER REFERENCES projects(id) ON DELETE CASCADE,
  title          TEXT    NOT NULL,
  when_label     TEXT,                                    -- 작품 속 시점
  body_md        TEXT,
  is_secret      INTEGER NOT NULL DEFAULT 0 CHECK (is_secret IN (0, 1)),
  sort_order     INTEGER NOT NULL DEFAULT 0,
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  CHECK ((world_id IS NOT NULL) + (project_id IS NOT NULL) = 1)
);

CREATE TABLE timeline_event_characters (
  id                 INTEGER PRIMARY KEY,
  timeline_event_id  INTEGER NOT NULL REFERENCES timeline_events(id) ON DELETE CASCADE,
  character_id       INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  UNIQUE (timeline_event_id, character_id)
);

-- 변경 기록 (되돌리기·비교용 스냅샷). 여러 테이블을 가리키는 유일한 예외 테이블
CREATE TABLE revisions (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  target_table   TEXT    NOT NULL CHECK (target_table IN ('characters', 'worlds', 'projects', 'docs', 'chatbot_versions', 'gen_presets')),
  target_id      INTEGER NOT NULL,
  snapshot_json  TEXT    NOT NULL CHECK (json_valid(snapshot_json)),  -- 그 시점 행 + 하위 행 전체
  summary        TEXT,                                    -- 'v6 · 나이 22 → 23'
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);
CREATE INDEX idx_revisions_target_table_target_id ON revisions (target_table, target_id);

-- ---------------------------------------------------------------------
-- 6. 챗봇  (features/chatbot)
-- ---------------------------------------------------------------------

-- 챗봇 설정 버전 (v1, v2, v3 …). 필드 이름은 캐릭터 카드 V2/V3에 맞춰 둠
CREATE TABLE chatbot_versions (
  id                         INTEGER PRIMARY KEY,
  character_id               INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  version_number             INTEGER NOT NULL,
  description                TEXT,                        -- 카드 description (캐릭터 설명)
  personality                TEXT,                        -- 카드 personality
  scenario                   TEXT,                        -- 카드 scenario
  first_message              TEXT,                        -- 카드 first_mes
  example_dialogue           TEXT,                        -- 카드 mes_example
  system_prompt              TEXT,                        -- 카드 system_prompt
  post_history_instructions  TEXT,                        -- 카드 post_history_instructions
  creator_note               TEXT,                        -- 카드 creator_notes
  is_current                 INTEGER NOT NULL DEFAULT 0 CHECK (is_current IN (0, 1)),
  created_at                 TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at                 TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  UNIQUE (character_id, version_number)
);
-- 캐릭터마다 현재 버전은 하나만
CREATE UNIQUE INDEX uq_chatbot_versions_character_id_current ON chatbot_versions (character_id) WHERE is_current = 1;

-- 대체 첫 인사 (카드 alternate_greetings)
CREATE TABLE chatbot_greetings (
  id                  INTEGER PRIMARY KEY,
  chatbot_version_id  INTEGER NOT NULL REFERENCES chatbot_versions(id) ON DELETE CASCADE,
  body                TEXT    NOT NULL,
  sort_order          INTEGER NOT NULL DEFAULT 0
);

-- 로어북 항목 (카드 character_book.entries)
CREATE TABLE chatbot_lore_entries (
  id                  INTEGER PRIMARY KEY,
  chatbot_version_id  INTEGER NOT NULL REFERENCES chatbot_versions(id) ON DELETE CASCADE,
  name                TEXT    NOT NULL,
  keywords_json       TEXT    NOT NULL DEFAULT '[]' CHECK (json_valid(keywords_json)),  -- ["편의점", "가게"]
  content             TEXT    NOT NULL,
  is_enabled          INTEGER NOT NULL DEFAULT 1 CHECK (is_enabled IN (0, 1)),
  is_constant         INTEGER NOT NULL DEFAULT 0 CHECK (is_constant IN (0, 1)),          -- 키워드 없이 항상 넣기
  priority            INTEGER NOT NULL DEFAULT 0,                                         -- 카드 insertion_order
  sort_order          INTEGER NOT NULL DEFAULT 0
);

-- 미리보기 대화 기록
CREATE TABLE chatbot_test_messages (
  id                  INTEGER PRIMARY KEY,
  chatbot_version_id  INTEGER NOT NULL REFERENCES chatbot_versions(id) ON DELETE CASCADE,
  role                TEXT    NOT NULL CHECK (role IN ('user', 'assistant')),
  body                TEXT    NOT NULL,
  input_tokens        INTEGER,                            -- 비용 계산용 (assistant일 때)
  output_tokens       INTEGER,
  created_at          TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);

-- ---------------------------------------------------------------------
-- 7. 이미지 생성 기록  (features/gen)
-- ---------------------------------------------------------------------

-- 플랫폼 목록 (NovelAI, SD WebUI Forge, ComfyUI, Midjourney …)
CREATE TABLE gen_platforms (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name           TEXT    NOT NULL,
  sort_order     INTEGER NOT NULL DEFAULT 0,
  UNIQUE (user_id, name)
);

-- 모델 목록 (illustriousXL_v01, NAI Diffusion V4.5, niji 6 …)
CREATE TABLE gen_models (
  id               INTEGER PRIMARY KEY,
  gen_platform_id  INTEGER NOT NULL REFERENCES gen_platforms(id) ON DELETE CASCADE,
  name             TEXT    NOT NULL,
  base_model       TEXT,                                  -- 'SDXL', 'Illustrious', 'Pony', 'NAI V4.5'
  file_name        TEXT,
  sha256           TEXT,                                  -- Civitai 조회용
  source_url       TEXT,
  note             TEXT,
  sort_order       INTEGER NOT NULL DEFAULT 0,
  UNIQUE (gen_platform_id, name)
);

-- LoRA 목록
CREATE TABLE gen_loras (
  id                  INTEGER PRIMARY KEY,
  user_id             INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name                TEXT    NOT NULL,                   -- 프롬프트에 쓰는 이름 (<lora:이름:0.8>)
  file_name           TEXT,
  base_model          TEXT,
  trigger_words       TEXT,                               -- 쉼표로 구분
  default_weight      REAL    NOT NULL DEFAULT 1.0,
  sha256              TEXT,
  source_url          TEXT,                               -- Civitai 페이지 등
  civitai_version_id  INTEGER,
  note                TEXT,
  created_at          TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at          TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  UNIQUE (user_id, name)
);

-- 고정 프롬프트 프리셋 (기본 외형 / 전투복 / 평상복 …)
CREATE TABLE gen_presets (
  id             INTEGER PRIMARY KEY,
  character_id   INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  name           TEXT    NOT NULL,
  tags_json      TEXT    NOT NULL DEFAULT '{}' CHECK (json_valid(tags_json)),      -- 형식은 DB-설계.md "JSON 칸 형식"
  negative_json  TEXT    NOT NULL DEFAULT '[]' CHECK (json_valid(negative_json)),
  sort_order     INTEGER NOT NULL DEFAULT 0,
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);

CREATE TABLE gen_preset_loras (
  id             INTEGER PRIMARY KEY,
  gen_preset_id  INTEGER NOT NULL REFERENCES gen_presets(id) ON DELETE CASCADE,
  gen_lora_id    INTEGER NOT NULL REFERENCES gen_loras(id) ON DELETE CASCADE,
  weight         REAL    NOT NULL DEFAULT 1.0,
  UNIQUE (gen_preset_id, gen_lora_id)
);

-- 생성 기록 (이미지 1장 = 1행)
CREATE TABLE gen_records (
  id               INTEGER PRIMARY KEY,
  character_id     INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  asset_id         INTEGER REFERENCES assets(id) ON DELETE SET NULL,
  gen_platform_id  INTEGER REFERENCES gen_platforms(id) ON DELETE SET NULL,
  gen_model_id     INTEGER REFERENCES gen_models(id) ON DELETE SET NULL,
  gen_preset_id    INTEGER REFERENCES gen_presets(id) ON DELETE SET NULL,     -- 어떤 고정 프롬프트로 시작했는지
  title            TEXT,
  prompt_raw       TEXT,                                  -- 붙여넣은 원문 그대로 (분류가 틀려도 원본 보존)
  tags_json        TEXT    NOT NULL DEFAULT '{}' CHECK (json_valid(tags_json)),
  negative_json    TEXT    NOT NULL DEFAULT '[]' CHECK (json_valid(negative_json)),
  seed             INTEGER,
  sampler          TEXT,
  steps            INTEGER,
  cfg_scale        REAL,
  width            INTEGER,
  height           INTEGER,
  extra_json       TEXT    NOT NULL DEFAULT '{}' CHECK (json_valid(extra_json)),   -- MJ 옵션, ComfyUI 워크플로 asset id 등
  note             TEXT,
  is_cover         INTEGER NOT NULL DEFAULT 0 CHECK (is_cover IN (0, 1)),         -- ★ 대표
  created_at       TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at       TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  deleted_at       TEXT
);
CREATE INDEX idx_gen_records_character_id ON gen_records (character_id);

-- 생성 기록에 쓴 LoRA. 목록에 없는 LoRA는 lora_name만 남김
CREATE TABLE gen_record_loras (
  id             INTEGER PRIMARY KEY,
  gen_record_id  INTEGER NOT NULL REFERENCES gen_records(id) ON DELETE CASCADE,
  gen_lora_id    INTEGER REFERENCES gen_loras(id) ON DELETE SET NULL,
  lora_name      TEXT    NOT NULL,                        -- 원문의 이름 (목록에서 지워져도 남음)
  weight         REAL    NOT NULL DEFAULT 1.0
);
CREATE INDEX idx_gen_record_loras_gen_lora_id ON gen_record_loras (gen_lora_id);

-- 자동 분류 내 사전 (미분류 태그를 옮기면 여기에 학습)
CREATE TABLE gen_tag_rules (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  tag            TEXT    NOT NULL,                        -- 소문자, 밑줄은 공백으로 바꿔서 저장
  category       TEXT    NOT NULL CHECK (category IN ('character', 'outfit', 'expression', 'pose', 'background', 'style', 'quality', 'etc')),
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  UNIQUE (user_id, tag)
);

-- ---------------------------------------------------------------------
-- 8. 게임 데이터  (features/game)
-- ---------------------------------------------------------------------

-- 프로젝트별 스탯 항목 정의 (HP, 공격, 속도 …)
CREATE TABLE game_stats (
  id             INTEGER PRIMARY KEY,
  project_id     INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name           TEXT    NOT NULL,
  max_value      REAL,                                    -- 막대 그래프 기준값
  sort_order     INTEGER NOT NULL DEFAULT 0,
  UNIQUE (project_id, name)
);

-- 캐릭터별 스탯 값
CREATE TABLE game_stat_values (
  id             INTEGER PRIMARY KEY,
  game_stat_id   INTEGER NOT NULL REFERENCES game_stats(id) ON DELETE CASCADE,
  character_id   INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  value          REAL,
  UNIQUE (game_stat_id, character_id)
);

CREATE TABLE game_skills (
  id             INTEGER PRIMARY KEY,
  project_id     INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  character_id   INTEGER REFERENCES characters(id) ON DELETE SET NULL,      -- 공용 스킬이면 NULL
  name           TEXT    NOT NULL,
  summary        TEXT,                                    -- '단일 대상 180% 피해'
  cost_label     TEXT,                                    -- 'MP 12', '쿨 4턴'
  body_md        TEXT,
  sort_order     INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE game_quests (
  id             INTEGER PRIMARY KEY,
  project_id     INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  title          TEXT    NOT NULL,
  summary        TEXT,
  body_md        TEXT,
  status         TEXT    NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'planned', 'done')),
  sort_order     INTEGER NOT NULL DEFAULT 0
);

-- ---------------------------------------------------------------------
-- 9. 기획 보드  (features/board)
-- ---------------------------------------------------------------------

CREATE TABLE board_columns (
  id             INTEGER PRIMARY KEY,
  project_id     INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name           TEXT    NOT NULL,                        -- '아이디어', '기획 중', '확정'
  sort_order     INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE board_cards (
  id               INTEGER PRIMARY KEY,
  board_column_id  INTEGER NOT NULL REFERENCES board_columns(id) ON DELETE CASCADE,
  title            TEXT    NOT NULL,
  body_md          TEXT,
  sort_order       INTEGER NOT NULL DEFAULT 0,
  created_at       TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at       TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);

CREATE TABLE board_card_tags (
  id             INTEGER PRIMARY KEY,
  board_card_id  INTEGER NOT NULL REFERENCES board_cards(id) ON DELETE CASCADE,
  tag_id         INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  UNIQUE (board_card_id, tag_id)
);

