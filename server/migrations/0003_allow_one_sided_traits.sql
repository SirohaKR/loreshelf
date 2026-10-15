-- 0003_allow_one_sided_traits — 한쪽짜리 성격 축 허용
-- 오른쪽(right_label)을 비우면 "신중함 ■■■■□ 80%" 처럼 한쪽 성격의 강도로 쓴다.
-- SQLite는 칸의 NOT NULL 을 바로 못 바꾸므로, 새 테이블을 만들어 옮긴 뒤 이름을 바꾼다.

CREATE TABLE character_traits_new (
  id             INTEGER PRIMARY KEY,
  character_id   INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  left_label     TEXT    NOT NULL,
  right_label    TEXT,                                                     -- NULL = 한쪽짜리 (강도 막대)
  value_percent  INTEGER NOT NULL DEFAULT 50 CHECK (value_percent BETWEEN 0 AND 100),
  sort_order     INTEGER NOT NULL DEFAULT 0
);
INSERT INTO character_traits_new (id, character_id, left_label, right_label, value_percent, sort_order)
  SELECT id, character_id, left_label, right_label, value_percent, sort_order FROM character_traits;
DROP TABLE character_traits;
ALTER TABLE character_traits_new RENAME TO character_traits;
CREATE INDEX idx_character_traits_character_id ON character_traits (character_id);
