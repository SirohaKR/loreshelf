-- 0004_add_personality_props_and_negative_sets — 프롬프트 분류 칸 추가 + 내 네거티브 세트
-- 1) 내 분류 사전(gen_tag_rules)에 '성격·분위기'(personality)와 '소품'(props) 칸을 허용한다.
--    SQLite는 CHECK를 바로 못 바꾸므로, 새 테이블을 만들어 옮긴 뒤 이름을 바꾼다.
CREATE TABLE gen_tag_rules_new (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  tag            TEXT    NOT NULL,                        -- 소문자, 밑줄은 공백으로 바꿔서 저장
  category       TEXT    NOT NULL CHECK (category IN ('character', 'personality', 'outfit', 'props', 'expression', 'pose', 'background', 'style', 'quality', 'etc')),
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
  UNIQUE (user_id, tag)
);
INSERT INTO gen_tag_rules_new (id, user_id, tag, category, created_at)
  SELECT id, user_id, tag, category, created_at FROM gen_tag_rules;
DROP TABLE gen_tag_rules;
ALTER TABLE gen_tag_rules_new RENAME TO gen_tag_rules;

-- 2) 내가 만든 네거티브 세트 (기본 세트는 코드에 있고, 여기엔 사용자가 직접 만든 것만)
CREATE TABLE gen_negative_sets (
  id             INTEGER PRIMARY KEY,
  user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name           TEXT    NOT NULL,
  negative_json  TEXT    NOT NULL DEFAULT '[]' CHECK (json_valid(negative_json)),   -- ["lowres", "bad hands", …]
  sort_order     INTEGER NOT NULL DEFAULT 0,
  created_at     TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);
CREATE INDEX idx_gen_negative_sets_user_id ON gen_negative_sets (user_id);
