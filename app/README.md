# LoreShelf 앱 (Flutter)

서버의 `/api/...`를 그대로 불러 쓰는 **보기 전용** 앱이에요 (1차). 편집 화면은 다음 단계.

- 로그인 (쿠키 세션 `ls_session`, 기기에 저장해서 다시 켜도 유지)
- 홈: 숫자 요약, 최근 수정한 캐릭터, 프로젝트
- 캐릭터 목록: 전체 / 서재 / 프로젝트별 필터 + 검색
- 캐릭터 상세: 프로필(기본 정보·성격·대사·소개), 갤러리(눌러서 크게), 이미지·프롬프트(고정 프롬프트 줄별·전체 복사 SD/NovelAI 형식, 생성 기록 — 눌러서 자세히)
- 프로젝트 목록·상세: 종류·진행도·장르 태그(분류별), 전용/연결 캐릭터
- 라이트/다크 전환, 넓은 화면은 왼쪽 메뉴 · 폰은 아래 탭

프롬프트 글 만들기는 서버와 같은 `shared/` 패키지(`loreshelf_shared`)를 써요.

쓰는 것: **Riverpod**(`@riverpod` 코드 생성 + `hooks_riverpod`) · **flutter_hooks** · **freezed** · `http` · `shared_preferences`.
코드 설명은 [../docs/flutter-공부노트.md](../docs/flutter-공부노트.md).

## 폴더 구조

```
lib/
├─ main.dart, app.dart
├─ core/
│  ├─ theme/     app_colors · app_radii · app_text_styles · app_typography · app_theme · theme_mode_provider
│  ├─ utils/     labels · color_utils · time_ago · int_bool_converter
│  ├─ widgets/   여러 화면이 같이 쓰는 위젯 (app_chip, section_card, async_value_view, confirmation_dialog,
│  │             app_error_toast, double_back_to_exit ...)
│  ├─ network/   api_client (+ provider)
│  └─ storage/   preferences_provider
└─ features/<기능>/          auth · home · characters · projects · gen · shell
   ├─ data/                  리포지토리 구현 (API 호출) + 그 provider
   ├─ domain/                엔티티(freezed) · 리포지토리 인터페이스
   └─ presentation/
      ├─ widgets/            이 기능 전용 위젯
      ├─ <이름>_provider.dart  (+ .g.dart)
      ├─ <이름>_page.dart
      └─ <이름>_state.dart     (+ .freezed.dart)
```

각 층의 역할과 의존 방향은 공부노트 1장에 있어요.

## 실행

먼저 서버를 켜 둬요 (`server/`에서 `PORT=5091 DB_PATH=data/dev.db dart run bin/server.dart`).

```bash
cd app
flutter run -d windows
```

로그인 화면의 **서버 주소**는 기본 `http://localhost:5091`. NAS면 `http://<NAS 주소>:5090`, Android 에뮬레이터에서 내 PC 서버는 `http://10.0.2.2:5091`.
빌드할 때 기본 주소를 바꾸려면 `--dart-define=LORESHELF_URL=http://192.168.0.10:5090`.

**웹으로 띄우기**: `flutter run -d chrome` → `http://localhost:5092`. `web_dev_config.yaml`이 `/api/` 요청을 5091로 넘겨 줘서 같은 주소처럼 쿠키가 동작해요(서버 주소 칸은 안 보임). 웹 첫 로딩 때 한글 글꼴을 내려받는 동안 몇 글자가 잠깐 ☒로 보일 수 있어요.

## 코드 생성 (build_runner)

엔티티·상태(`@freezed`)나 provider(`@riverpod`)를 고치거나 새로 만들면:

```bash
dart run build_runner build --force-jit
```

작업하는 동안 켜 두기: `dart run build_runner watch --force-jit`.
생성 파일(`*.freezed.dart`, `*.g.dart`)도 저장소에 넣어요.

## 확인

```bash
flutter analyze
flutter test
```

테스트 폴더: `test/core/`(API 클라이언트·유틸), `test/features/`(엔티티, 위젯 — `fakes.dart`의 가짜 리포지토리로 서버 없이), `test/live_server_test.dart`(진짜 서버).

실제 개발 서버에 붙여 보는 테스트(평소엔 건너뜀) — 서버를 켜 두고:

```bash
LORESHELF_LIVE_PASSWORD=<개발 계정 비밀번호> flutter test test/live_server_test.dart
```

(PowerShell: `$env:LORESHELF_LIVE_PASSWORD='...'; flutter test test/live_server_test.dart`. 계정은 `private/dev-account.md`)

## 이 경로(한글·긴 경로)에서 생기는 문제

저장소가 `...\개인메모\버린파일\...` 아래에 있어서 도구 몇 개가 걸려요.

| 증상 | 해결 |
|---|---|
| `build_runner`가 "Unable to write file ... build.dart.aot" | `--force-jit` 붙이기 |
| `flutter analyze`가 "FormatException: Unterminated string"으로 분석 서버가 죽음 | `dart analyze`를 쓰거나(결과 같음), 영어 경로의 정션(`mklink /J C:\dev\loreshelf <저장소>`)에서 `flutter analyze` |
| `flutter build windows`가 FileTracker FTK1011 | 경로가 너무 길 때 남. 원래 경로나 짧은 경로에서 빌드 |
