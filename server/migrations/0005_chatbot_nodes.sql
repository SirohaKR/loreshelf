-- 0005_chatbot_nodes — 챗봇 설정을 "카드(노드) 구조"로 새로 만든다 (docs/planning/챗봇-설정-기획서.md 3절)
-- 예전 카드 V2 한 장 모양 테이블 4개는 아무 코드도 안 쓰고 데이터도 0줄이라 지운다.
-- 카드 V2/V3는 저장 모양이 아니라 내보내기 모양으로만 남는다(shared/의 변환 함수).

-- 1) 예전 챗봇 테이블 지우기 (딸린 것부터)
DROP TABLE chatbot_test_messages;
DROP TABLE chatbot_lore_entries;
DROP TABLE chatbot_greetings;
DROP TABLE chatbot_versions;

-- 2) 변경 기록이 가리킬 수 있는 테이블: chatbot_versions → chatbot_stories
--    SQLite는 CHECK를 바로 못 바꾸므로, 새 테이블을 만들어 옮긴 뒤 이름을 바꾼다 (0003과 같은 방식).
CREATE TABLE revisions_new (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  target_table   TEXT    NOT NULL CHECK (target_table IN ('characters', 'worlds', 'projects', 'docs', 'chatbot_stories', 'gen_presets')),
  target_id      INTEGER NOT NULL,
  snapshot_json  TEXT    NOT NULL CHECK (json_valid(snapshot_json)),  -- 그 시점 행 + 하위 행 전체
  summary        TEXT,                                    -- 'v6 · 나이 22 → 23'
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);
-- 지운 테이블을 가리키던 기록은 옮기지 않는다 (챗봇 테이블이 비어 있었으니 실제로는 0줄)
INSERT INTO revisions_new (id, user_id, target_table, target_id, snapshot_json, summary, created_at)
  SELECT id, user_id, target_table, target_id, snapshot_json, summary, created_at FROM revisions
  WHERE target_table <> 'chatbot_versions';
DROP TABLE revisions;
ALTER TABLE revisions_new RENAME TO revisions;
CREATE INDEX idx_revisions_target_table_target_id ON revisions (target_table, target_id);

-- 3) AI 사용 기록 (새 접두사 ai_ = features/ai/). 호출 한 번에 한 줄, 원가는 100만분의 1달러 정수
CREATE TABLE ai_usage_logs (
  id                 INTEGER PRIMARY KEY,
  user_id            INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  feature            TEXT    NOT NULL,                    -- 'status_view', 'chatbot_test', 'prompt_classify' …
  provider           TEXT    NOT NULL CHECK (provider IN ('anthropic', 'openai', 'google')),
  model              TEXT    NOT NULL,
  input_tokens       INTEGER NOT NULL DEFAULT 0,
  output_tokens      INTEGER NOT NULL DEFAULT 0,
  cost_microdollars  INTEGER NOT NULL DEFAULT 0,          -- 100만분의 1달러 (정수라 반올림 오차 없음)
  created_at         TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);
CREATE INDEX idx_ai_usage_logs_user_id_created_at ON ai_usage_logs (user_id, created_at);

-- 4) 상태창(로판AI 트래커 모양) — 작품과 따로 관리, 여러 작품이 같이 씀
CREATE TABLE chatbot_status_views (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name           TEXT    NOT NULL,                        -- 로판 10자
  design_html    TEXT    NOT NULL DEFAULT '',             -- {{항목}}·{{char}}·{{user}} 들어간 원본 (인라인 style만)
  theme          TEXT    NOT NULL DEFAULT 'dark' CHECK (theme IN ('dark', 'light')),
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  deleted_at     TEXT
);
CREATE INDEX idx_chatbot_status_views_user_id ON chatbot_status_views (user_id);

-- 상태창 항목 (로판 항목 = 로플 문자 변수 + 업데이트 규칙)
CREATE TABLE chatbot_status_view_items (
  id                      INTEGER PRIMARY KEY,
  chatbot_status_view_id  INTEGER NOT NULL REFERENCES chatbot_status_views(id) ON DELETE CASCADE,
  name                    TEXT    NOT NULL,               -- 로판 15자, 로플 변수 이름
  instruction             TEXT    NOT NULL DEFAULT '',    -- 지시사항 = 로플 업데이트 규칙
  value_kind              TEXT    NOT NULL DEFAULT 'text' CHECK (value_kind IN ('text', 'number', 'boolean')),
  sample_value            TEXT,                           -- 미리보기용 예시 값
  sort_order              INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_chatbot_status_view_items_chatbot_status_view_id ON chatbot_status_view_items (chatbot_status_view_id);

-- 상태창을 AI에게 부탁한 기록 (다시 부탁하기·되돌리기)
CREATE TABLE chatbot_status_view_drafts (
  id                      INTEGER PRIMARY KEY,
  chatbot_status_view_id  INTEGER NOT NULL REFERENCES chatbot_status_views(id) ON DELETE CASCADE,
  request_text            TEXT    NOT NULL,               -- "호감도 하트 5칸, 날짜·장소, 기분 이모지"
  design_html             TEXT    NOT NULL,
  items_json              TEXT    NOT NULL DEFAULT '[]' CHECK (json_valid(items_json)),  -- [{name, instruction, value_kind, sample_value}]
  ai_usage_log_id         INTEGER REFERENCES ai_usage_logs(id) ON DELETE SET NULL,
  created_at              TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);
CREATE INDEX idx_chatbot_status_view_drafts_chatbot_status_view_id ON chatbot_status_view_drafts (chatbot_status_view_id);

-- 5) 챗봇 작품(스토리 묶음). 캐릭터 하나에 여러 개 가능 (예: 같은 캐릭터로 로맨스판/학원판)
CREATE TABLE chatbot_stories (
  id                     INTEGER PRIMARY KEY,
  user_id                INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  main_character_id      INTEGER REFERENCES characters(id) ON DELETE SET NULL,  -- 대표 캐릭터 (목록·{{char}} 기본값)
  project_id             INTEGER REFERENCES projects(id) ON DELETE SET NULL,    -- 자동 채우기 원본
  title                  TEXT    NOT NULL,
  edit_mode              TEXT    NOT NULL DEFAULT 'simple' CHECK (edit_mode IN ('simple', 'canvas')),
  target_platforms_json  TEXT    NOT NULL DEFAULT '["rofan","rplay"]' CHECK (json_valid(target_platforms_json)),
  sort_order             INTEGER NOT NULL DEFAULT 0,
  created_at             TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at             TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  deleted_at             TEXT
);
CREATE INDEX idx_chatbot_stories_user_id ON chatbot_stories (user_id);
CREATE INDEX idx_chatbot_stories_main_character_id ON chatbot_stories (main_character_id);

-- 카드(노드). 종류별 칸은 content_json (모양은 shared/lib/src/chatbot/node_content.dart 가 검사)
CREATE TABLE chatbot_nodes (
  id                      INTEGER PRIMARY KEY,
  chatbot_story_id        INTEGER NOT NULL REFERENCES chatbot_stories(id) ON DELETE CASCADE,
  kind                    TEXT    NOT NULL CHECK (kind IN ('story', 'character', 'user', 'image', 'macro', 'extra_cast',
                            'preset_note', 'variable', 'update_rule', 'trigger', 'status_view', 'achievement', 'hub')),
  title                   TEXT    NOT NULL,
  source_character_id     INTEGER REFERENCES characters(id) ON DELETE SET NULL,            -- 인물 카드가 가리키는 캐릭터
  chatbot_status_view_id  INTEGER REFERENCES chatbot_status_views(id) ON DELETE SET NULL,  -- 상태창 카드일 때
  content_json            TEXT    NOT NULL DEFAULT '{}' CHECK (json_valid(content_json)),
  is_enabled              INTEGER NOT NULL DEFAULT 1 CHECK (is_enabled IN (0, 1)),
  position_x              INTEGER,                        -- 캔버스 모드 자리 (간편 모드는 비움)
  position_y              INTEGER,
  sort_order              INTEGER NOT NULL DEFAULT 0,
  created_at              TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  updated_at              TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);
CREATE INDEX idx_chatbot_nodes_chatbot_story_id ON chatbot_nodes (chatbot_story_id);

-- 카드 사이 선 (간편 모드에선 "스토리에 붙이기"가 곧 선 하나)
CREATE TABLE chatbot_node_links (
  id                    INTEGER PRIMARY KEY,
  from_chatbot_node_id  INTEGER NOT NULL REFERENCES chatbot_nodes(id) ON DELETE CASCADE,
  to_chatbot_node_id    INTEGER NOT NULL REFERENCES chatbot_nodes(id) ON DELETE CASCADE,
  UNIQUE (from_chatbot_node_id, to_chatbot_node_id),
  CHECK (from_chatbot_node_id <> to_chatbot_node_id)
);
CREATE INDEX idx_chatbot_node_links_to_chatbot_node_id ON chatbot_node_links (to_chatbot_node_id);

-- 미리보기 대화 기록 (예전과 같은 모양, 주인만 작품으로)
CREATE TABLE chatbot_test_messages (
  id                INTEGER PRIMARY KEY,
  chatbot_story_id  INTEGER NOT NULL REFERENCES chatbot_stories(id) ON DELETE CASCADE,
  role              TEXT    NOT NULL CHECK (role IN ('user', 'assistant')),
  body              TEXT    NOT NULL,
  input_tokens      INTEGER,                              -- 비용 계산용 (assistant일 때)
  output_tokens     INTEGER,
  created_at        TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);
CREATE INDEX idx_chatbot_test_messages_chatbot_story_id ON chatbot_test_messages (chatbot_story_id);
