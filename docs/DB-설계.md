# DB 설계 · 이름 규칙

> 이 문서의 목적: **나중에 내가 DB를 직접 고칠 때, 이름만 보고 뜻과 연결을 알 수 있게** 하는 것.
> 규칙에 예외를 만들지 않는 게 핵심이에요. 예외가 꼭 필요하면 이 문서의 "예외 목록"에 적어요.

- 스키마 원본: [server/migrations/](../server/migrations/) (SQLite, 테이블 48개). 지금 모습 = 0001부터 마지막 번호까지 차례로 실행한 결과
- 그림: [erd.html](erd.html) — `server` 폴더에서 `dart run tool/make_erd.dart`로 마이그레이션에서 자동 생성
- 규칙 자동 검사: [server/test/schema_rules_test.dart](../server/test/schema_rules_test.dart)
- 언어 선택: [언어-선택.md](언어-선택.md)

---

## 1. 기본 원칙 5가지

1. **영어 소문자 + 밑줄(snake_case)**. 한글·대문자·띄어쓰기 금지. → `character_fields` (O), `CharacterFields` / `캐릭터필드` (X)
2. **줄임말 금지**. 길어도 풀어 씀. → `character_id` (O), `char_id` (X) / `description` (O), `desc` (X)
3. **같은 뜻이면 어디서나 같은 이름**. 정렬 순서는 모든 테이블에서 `sort_order`, 삭제 표시는 모두 `deleted_at`.
4. **이름만 보고 종류를 알 수 있게** — 접미사·접두사로 자료형과 역할을 표시 (아래 2-3절).
5. **모든 테이블은 첫 칸이 `id INTEGER PRIMARY KEY`**. 연결 테이블도 예외 없음.

---

## 2. 이름 규칙

### 2-1. 테이블

| 규칙 | 예 | 틀린 예 |
|---|---|---|
| **복수형** | `characters`, `worlds`, `memos` | `character`, `world` |
| **기능 묶음은 접두사**로 표시하고, 접두사 = 서버의 기능 폴더 이름 | `chatbot_stories`, `gen_records`, `game_stats`, `board_cards` | `versions`, `records` |
| **딸린 테이블은 `주인(단수)_내용(복수)`** | `character_fields`, `character_quotes`, `chatbot_status_view_items` | `fields`, `quotes_of_character` |
| **연결 테이블(다대다)은 `A(단수)_B(복수)`** — 주인 쪽을 앞에 | `character_tags`, `project_characters`, `memo_tags` | `tags_characters`, `char_tag_map` |

접두사 목록 (새 기능 묶음을 만들면 여기에 추가):

| 접두사 | 뜻 | 서버 폴더 |
|---|---|---|
| (없음) | 핵심 데이터: users, worlds, projects, characters, docs, memos, tags, assets … | `features/<테이블명>/` |
| `character_` | 캐릭터에 딸린 것 | `features/characters/` |
| `chatbot_` | 챗봇 설정 | `features/chatbot/` |
| `ai_` | AI 호출 기록 (상태창 만들기 등, 회사: Claude·GPT·Gemini) | `features/ai/` |
| `gen_` | 이미지 생성 기록 (generation) | `features/gen/` |
| `game_` | 게임 데이터 | `features/game/` |
| `board_` | 기획 보드 | `features/board/` |
| `timeline_` | 연표 | `features/timeline/` |

### 2-2. 칸(컬럼) — 이름 끝에 붙는 말

| 끝말 | 뜻 · 자료형 | 예 |
|---|---|---|
| `id` | 이 행의 번호 (기본키) | `id` |
| `_id` | **다른 테이블 참조**. `참조하는 테이블 단수형 + _id` | `character_id` → characters, `gen_lora_id` → gen_loras |
| `역할_테이블단수_id` | 같은 테이블을 두 번 이상 참조하거나 역할을 밝힐 때 | `from_character_id`, `to_character_id`, `source_character_id`, `portrait_asset_id`, `cover_asset_id` |
| `_at` | 시각. TEXT `2026-10-15T09:30:00Z` (UTC, 끝에 Z) | `created_at`, `expires_at` |
| `_json` | JSON 문자열. 저장할 때 `json_valid` 검사 | `tags_json`, `keywords_json` |
| `_md` | 마크다운 본문 | `body_md` |
| `_percent` | 0~100 정수 | `progress_percent`, `value_percent` |
| `_count` | 개수 | (앞으로 생기면) `download_count` |
| `_tokens` | AI 토큰 수 (정수) | `input_tokens`, `output_tokens` |
| `_microdollars` | 돈. 100만분의 1달러 **정수** (소수로 저장하면 반올림 오차가 쌓여서) | `cost_microdollars` (1달러 = 1,000,000) |
| `_label` | 사람이 읽는 자유 글 (계산에 안 씀) | `when_label`, `cost_label` |
| `_url` / `_path` | 인터넷 주소 / 서버 안 파일 경로 | `source_url`, `file_path` |
| `_hash` / `sha256` | 해시값 | `password_hash`, `token_hash` |
| `_en` | 영어 버전 | `name_en` |

### 2-3. 칸 — 앞에 붙는 말

| 앞말 | 뜻 · 자료형 | 예 |
|---|---|---|
| `is_` | 참/거짓. **INTEGER 0 또는 1**, NOT NULL, 기본값 필수 | `is_secret`, `is_favorite`, `is_current`, `is_cover` |

`has_`, `can_`, `flag_`, `_yn` 같은 다른 형태는 쓰지 않아요. 전부 `is_`로 통일. (예: "카드 다운로드 가능" → `is_card_downloadable`)

### 2-4. 자주 쓰는 칸 이름 — 정해진 것만 씀

| 뜻 | 이름 | 쓰지 않는 이름 |
|---|---|---|
| 사람·사물·항목의 이름 | `name` | `title`, `nm` |
| 글·문서·기록의 제목 | `title` | `name`, `subject` |
| 한 줄 소개 | `summary` (캐릭터만 `tagline`) | `desc`, `intro` |
| 긴 본문 | `body_md` (마크다운) / `body` (일반 글) | `content`, `text` |
| 메모 | `note` | `memo`, `comment` |
| 화면 정렬 순서 | `sort_order` | `sort`, `order`, `seq`, `position` |
| 종류 구분 | `kind` | `type` (SQL·Dart에서 헷갈림) |
| 진행 상태 | `status` | `state` |
| 공개 범위 | `visibility` | `is_public` (단, 파일은 공개/비공개 둘뿐이라 `assets.is_public`) |
| 색 | `color`, `theme_color` — TEXT `#RRGGBB` | |
| 만든 / 고친 / 지운 시각 | `created_at` / `updated_at` / `deleted_at` | `reg_date`, `modified` |

### 2-5. 정해진 값(선택지)

선택지가 있는 칸은 **영어 소문자 snake_case 값**을 쓰고 `CHECK`로 막아요. 화면에 보이는 한글은 코드에서 바꿔 보여줌.

| 칸 | 값 | 화면 표시 |
|---|---|---|
| `visibility` | `private` / `unlisted` / `public` | 비공개 / 링크 공개 / 블로그 공개 |
| `projects.kind` | `game` / `chatbot` / `etc` | 게임 / 챗봇 / 기타 |
| `character_relations.direction` | `one_way` / `two_way` | 한쪽 / 서로 |
| `game_quests.status` | `draft` / `planned` / `done` | 초안 / 기획 중 / 확정 |
| `chatbot_test_messages.role` | `user` / `assistant` | 나 / 캐릭터 |
| `chatbot_stories.edit_mode` | `simple` / `canvas` | 간편 / 캔버스 |
| `chatbot_nodes.kind` | `story` / `character` / `user` / `image` / `macro` / `extra_cast` / `preset_note` / `variable` / `update_rule` / `trigger` / `status_view` / `achievement` / `hub` | 스토리 / 인물 / 유저 / 이미지 / 매크로 / 기타 인물 / 프리셋 노트 / 변수 / 업데이트 규칙 / 트리거 / 상태창 / 업적 / 허브 |
| `chatbot_status_views.theme` | `dark` / `light` | 어두운 / 밝은 |
| `chatbot_status_view_items.value_kind` | `text` / `number` / `boolean` | 글 / 숫자 / 참거짓 |
| `ai_usage_logs.provider` | `anthropic` / `openai` / `google` | Claude / GPT / Gemini |
| `genres.category` | `genre` / `setting` / `mood` / `trope` / `game` / `custom` | 장르 / 배경·무대 / 분위기·관계 / 소재·설정 / 게임·형식 / 직접 추가 |
| `gen_tag_rules.category` | `character` / `personality` / `outfit` / `props` / `expression` / `pose` / `background` / `style` / `quality` / `etc` | 인물·외형 / 성격·분위기 / 의상 / 소품 / 표정 / 포즈·구도 / 배경·조명 / 스타일·화풍 / 품질 / 미분류 (personality·props는 0004에서 추가) |

### 2-6. 인덱스 · 제약 이름

| 종류 | 형식 | 예 |
|---|---|---|
| 일반 인덱스 | `idx_테이블_칸` | `idx_characters_project_id` |
| 유니크 인덱스 | `uq_테이블_칸` | `uq_genres_user_id_name` |

---

## 3. 공통 칸 · 동작 약속

| 약속 | 내용 |
|---|---|
| 시각 칸 | 내용이 바뀌는 테이블은 `created_at` + `updated_at`. 기본값은 DB가 넣고, `updated_at`은 저장할 때 서버(Dart repository)가 갱신 |
| 휴지통 | 사용자가 직접 만드는 큰 단위(worlds, projects, characters, docs, memos, assets, gen_records, chatbot_stories, chatbot_status_views)는 `deleted_at`으로 **소프트 삭제**. 목록 조회는 항상 `WHERE deleted_at IS NULL` |
| 하위 행 삭제 | 주인에 딸린 행은 `ON DELETE CASCADE` (캐릭터를 영구 삭제하면 칸·대사·관계도 같이 삭제) |
| 참조만 하는 행 | 선택 참조는 `ON DELETE SET NULL` (대표 이미지 파일을 지워도 캐릭터는 남음) |
| 소유자 | 맨 위 단위(worlds, projects, characters, assets, tags, memos, gen_platforms, gen_loras …)에 `user_id`. 딸린 테이블은 주인을 통해 알 수 있으므로 `user_id`를 다시 넣지 않음 |
| 외래키 | 연결할 때마다 `PRAGMA foreign_keys = ON` (SQLite는 기본이 꺼짐) |
| 비밀 | `is_secret = 1`인 행은 블로그 API가 **서버에서 빼고** 보냄 (CSS로 숨기지 않음) |

### 장르·세계관 태그 (0002에서 추가)
- 세계관은 프로젝트마다 설명(`projects.body_md`)에 쓰고, 프로젝트에는 `genres` 목록에서 골라 `project_genres`로 붙여요 (로판, 학원, 청춘, 복수 …).
- `genres.user_id`가 **NULL이면 기본 제공 태그**(0002 마이그레이션이 넣음), 값이 있으면 그 사용자가 직접 추가한 태그. 기본 제공 태그는 지울 수 없어요.
- 이름은 같은 사람 안에서(기본 제공 포함) 겹치지 않아요: `uq_genres_user_id_name`.
- 캐릭터 태그(`tags`, 자유 입력)와는 별개예요. 장르 태그 = 작품의 성격, 캐릭터 태그 = 캐릭터 키워드.
- `worlds` 테이블과 `world_id` 칸은 데이터 보존을 위해 남겨 뒀지만 화면에서는 더 이상 쓰지 않아요.

### 챗봇 카드 구조 (0005에서 추가)
- `chatbot_stories`(작품) 하나에 `chatbot_nodes`(카드 13종)가 여럿, 카드 사이는 `chatbot_node_links`(선). 간편 모드의 "스토리에 붙이기"도 선 하나라서 캔버스 모드와 같은 데이터예요.
- 작품과 상태창(`chatbot_status_views`)은 맨 위 단위라 `user_id` + `deleted_at`이 있어요. 카드·선·항목은 주인을 거쳐서 누구 것인지 알아요.
- 카드 종류별 칸은 `content_json` 한 칸에 담아요(플랫폼이 칸을 자주 바꿔서). JSON 키도 snake_case(`key_info`, `start_messages`, `duration_turns` …).
- 상태창은 작품과 따로 만들고 상태창 카드(`chatbot_nodes.chatbot_status_view_id`)로 이어요. 여러 작품이 같은 상태창을 쓸 수 있어요.
- 자세한 기획: [planning/챗봇-설정-기획서.md](planning/챗봇-설정-기획서.md) 3절.

### 소속 표현 — "여러 곳 중 하나에 속함"
`docs`처럼 세계관 / 프로젝트 / 캐릭터 중 하나에 속하는 경우, `owner_type + owner_id` 대신 **참조 칸을 각각 두고 CHECK로 정확히 하나만** 채우게 해요. 이렇게 하면 외래키가 살아 있어서 잘못된 번호가 들어갈 수 없어요.

```sql
world_id INTEGER REFERENCES worlds(id),
project_id INTEGER REFERENCES projects(id),
character_id INTEGER REFERENCES characters(id),
CHECK ((world_id IS NOT NULL) + (project_id IS NOT NULL) + (character_id IS NOT NULL) = 1)
```

### 프로젝트 전용 / 서재 캐릭터
| 상황 | 저장 방식 |
|---|---|
| 프로젝트 전용 | `characters.project_id = 프로젝트 번호` |
| 공용 서재 | `characters.project_id = NULL` |
| 서재 캐릭터를 프로젝트에 연결 | `project_characters` 에 한 줄 추가 |
| 이 프로젝트용으로 분기 | 캐릭터 행을 복사하고 `source_character_id = 원본 번호`, `project_id = 프로젝트 번호` |
| 프로젝트를 영구 삭제 | 전용 캐릭터도 같이 삭제됨(CASCADE) → 삭제 전에 "서재로 꺼내기" 안내 |

---

## 4. JSON 칸 형식

JSON은 **목록·묶음이라서 테이블로 쪼개면 오히려 불편한 것**에만 써요. 검색·연결이 필요한 건 테이블로.

| 칸 | 형식 | 예 |
|---|---|---|
| `gen_presets.tags_json`, `gen_records.tags_json` | `{카테고리: [{tag, weight}]}` — 카테고리 키는 2-5절 값 | `{"character":[{"tag":"silver hair","weight":1.2}],"outfit":[{"tag":"silver armor","weight":1}]}` |
| `*.negative_json` | 문자열 배열 | `["lowres","bad hands"]` |
| `settings.value` (이름 `gen_default_quality`, `gen_default_negative`) | 문자열 배열 (JSON 글로 저장) — 모든 캐릭터 공통 기본 품질 태그·네거티브. 행이 없으면 shared의 처음 기본값. 읽고 쓰기는 `/api/gen/defaults`에서만(값 검사 때문에 `/api/settings` 허용 목록엔 안 넣음) | `["masterpiece","best quality"]` |
| `chatbot_stories.target_platforms_json` | 내보낼 플랫폼 배열 (`rofan`, `rplay`) | `["rofan","rplay"]` |
| `chatbot_nodes.content_json` | 카드 종류별 칸 묶음. 모양은 `shared/lib/src/chatbot/node_content.dart` 한 곳에서 검사(서버·앱 같이) | `{"mode":"keyword","keywords":["편의점"],"body":"…","priority":0,"duration_turns":1}` |
| `chatbot_status_view_drafts.items_json` | 그때의 상태창 항목 배열 | `[{"name":"호감도","instruction":"0~5를 ♥♡로","value_kind":"text","sample_value":"♥♥♡♡♡"}]` |
| `character_templates.fields_json` | 칸 이름 배열 | `["나이","생일","키"]` |
| `gen_records.extra_json` | 자유 객체 (플랫폼별 추가 정보) | `{"--ar":"2:3","workflow_asset_id":12}` |
| `revisions.snapshot_json` | 그 시점 행 + 딸린 행 전체 | `{"row":{…},"character_fields":[…]}` |

JSON 안의 키 이름도 **snake_case 영어**로 써요.

---

## 5. Dart 코드와 이름 맞추기

| DB | Dart | 예 |
|---|---|---|
| 테이블 (복수, snake) | 클래스 (단수, PascalCase) | `chatbot_stories` → `ChatbotStory` |
| 칸 (snake) | 필드 (camelCase) | `first_message` → `firstMessage`, `is_secret` → `isSecret` (bool로 변환) |
| `_at` (TEXT) | `DateTime` | `createdAt` |
| `_json` (TEXT) | `Map` / `List` (읽을 때 decode) | `tagsJson` → `tags` |
| 접두사 | 기능 폴더 | `gen_*` → `features/gen/gen_repository.dart` |

변환은 각 기능의 repository 한 곳에서만 해요 (`fromRow` / `toRow`). 화면·서비스 코드에는 snake_case가 나오지 않게.

---

## 6. DB 바꾸는 방법 (마이그레이션)

나중에 칸을 추가하거나 바꿀 때 지키는 순서:

1. `server/migrations/`에 **번호 붙은 새 파일**을 만듦: `0002_add_character_birthday.sql`
   - 파일 이름: `4자리번호_무엇을_했는지.sql` (영어 snake_case)
2. **이미 적용된 파일은 절대 고치지 않음** (NAS의 실제 DB는 그 파일이 이미 실행된 상태라서)
3. 서버가 켜질 때 `PRAGMA user_version`을 보고 아직 안 한 번호만 순서대로 실행
4. 새 테이블이면 `server/tool/make_erd.dart`의 묶음 목록에 넣고, `dart run tool/make_erd.dart`로 `docs/erd.html`을 다시 생성
5. `dart test`로 규칙 검사(`test/schema_rules_test.dart`)까지 통과 확인. 규칙의 예외가 생기면 이 문서 8절과 테스트의 예외 목록을 같이 고침

자주 하는 변경 예:
```sql
-- 0002_add_character_birthday.sql : 캐릭터에 생일 칸 추가
ALTER TABLE characters ADD COLUMN birthday_label TEXT;   -- 작품 속 날짜라 자유 글 → _label

-- 0003_add_game_items.sql : 게임 아이템 테이블 추가 (접두사 game_, 복수형, id부터)
CREATE TABLE game_items (
  id          INTEGER PRIMARY KEY,
  project_id  INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name        TEXT    NOT NULL,
  summary     TEXT,
  sort_order  INTEGER NOT NULL DEFAULT 0
);
```

> maple-ledger는 "서버가 켜질 때 없는 칸을 자동 추가"하는 방식이에요. 편하지만 칸 이름 바꾸기·삭제는 못 하고, 언제 무엇이 바뀌었는지 기록이 안 남아요. LoreShelf는 오래 고쳐 쓸 거라 번호 붙은 마이그레이션 파일로 갈게요.

---

## 7. 규칙 자동 검사

이 문서의 규칙은 사람이 기억하는 게 아니라 **테스트가 검사**해요 (`server/test/schema_rules_test.dart`, `dart test`로 실행). 검사 항목:

- [x] 테이블명: snake_case, 복수형, 줄임말 없음
- [x] 모든 테이블 첫 칸이 `id INTEGER PRIMARY KEY`
- [x] `_id`로 끝나는 칸은 외래키이고, 이름이 참조 테이블 단수형으로 끝남
- [x] 외래키 칸은 반드시 `_id`로 끝남
- [x] `is_` 칸은 INTEGER NOT NULL + `IN (0, 1)` 검사
- [x] `_at` 칸은 TEXT, `_json` 칸은 `json_valid` 검사
- [x] 금지 이름(`type`, `sort`, `order`, `desc`, `image`, `date`) 없음
- [x] `updated_at`이 있으면 `created_at`도 있음
- [x] 인덱스 이름 `idx_/uq_테이블_` 형식

2026-10-16 기준 `0005_chatbot_nodes.sql`까지: **테이블 48개 · 위반 0개** (0005에서 예전 챗봇 테이블 4개를 지우고 8개를 새로 만듦, `revisions.target_table`의 `chatbot_versions` → `chatbot_stories`).
2026-10-15 기준 `0002_add_genres.sql`까지: **테이블 43개 · 위반 0개**. 제약도 샘플 데이터로 확인함 (docs 소속 0개/2개, 현재 챗봇 버전 2개, 잘못된 visibility·JSON, 자기 자신과의 관계, 없는 캐릭터 참조 → 모두 거부됨).

---

## 8. 예외 목록

규칙을 어긴 곳은 전부 여기에 이유와 함께 적어요. 여기에 없는 예외는 버그예요.

| 위치 | 예외 | 이유 |
|---|---|---|
| `revisions.target_table` + `target_id` | 여러 테이블을 가리키는 칸 (외래키 없음) | 변경 기록은 어느 테이블이든 스냅샷을 남겨야 해서. `target_table`은 CHECK로 허용 테이블만 |
| `gen_loras.civitai_version_id` | `_id`인데 우리 DB 참조가 아님 | Civitai 쪽 번호. 외부 서비스 번호는 `서비스명_..._id`로 표시 |
| `gen_records.cfg_scale` | `cfg`는 줄임말 | 이미지 생성 분야에서 모두 쓰는 정식 용어 (WebUI 표기 그대로) |
| `assets.is_public` | `visibility` 대신 `is_` | 파일은 공개/비공개 두 가지뿐 |
| `characters.tagline` | `summary` 대신 | 캐릭터의 한 줄 문구는 소개라기보다 캐치프레이즈라서 구분 |
