# Flutter 공부 노트 — LoreShelf 앱에서 폴더 구조 · freezed · Riverpod · hooks가 쓰인 곳

Java는 읽을 수 있고 Flutter는 배우는 중인 사람을 위한 안내예요. 설명마다 **이 앱의 실제 파일**을 짚어 두었으니, 같이 열어 보면서 읽으면 좋아요.
앱 코드는 `app/lib/` 아래에 있어요.

쓰는 조합: **Riverpod(코드 생성 `@riverpod`) + hooks_riverpod(`HookConsumerWidget`) + flutter_hooks + freezed**.

---

## 0. Flutter를 Java 눈으로 보기 (아주 짧게)

| Flutter | Java로 치면 |
|---|---|
| `Widget` | 화면 조각을 **설명하는 불변 객체**. Swing 컴포넌트와 달리 매번 새로 만들어 버리고, 실제 그리기는 Flutter가 비교해서 바뀐 부분만 한다 |
| `build(context)` | "지금 상태라면 화면은 이렇게 생겼다"를 돌려주는 메서드. 상태가 바뀌면 다시 불린다 |
| `StatelessWidget` | 필드가 전부 `final`인 화면 조각 |
| `StatefulWidget` + `State` | 바뀌는 필드를 가진 화면 조각. `setState()`로 다시 그리기 요청 — **이 앱에선 안 쓰고 hooks로 대신** |
| `const` 생성자 | 컴파일 시점 상수. 같은 위젯을 매번 새로 안 만들어서 빠름 |
| `Future<T>` / `async`·`await` | `CompletableFuture<T>`와 같은 것. `await`가 `.get()`처럼 기다리지만 스레드는 막지 않음 |
| `required this.id` | 이름 붙은 매개변수. 호출할 때 `Foo(id: 3)` |
| `String?` | null이 될 수 있는 타입. `String`은 null 불가 (Kotlin과 같은 null 안전성) |
| `abstract interface class` | Java의 `interface` |
| `switch (x) { A() => ..., B(:final id) => ... }` | Java 21의 패턴 매칭 switch + record 분해와 거의 같음 |
| `part 'x.g.dart';` | "생성된 파일을 이 파일의 일부로 붙여라". 생성 코드(`_$...`)를 이 파일에서 쓸 수 있게 됨 |

---

## 1. 폴더 구조 — `core/` 와 `features/<기능>/{data, domain, presentation}`

```
app/lib/
├─ main.dart                      시작점: 저장소 열고 ProviderScope로 감싸기
├─ app.dart                       테마 + 로그인 여부에 따라 화면 고르기
├─ core/                          여러 기능이 같이 쓰는 것
│  ├─ theme/                      app_colors · app_radii · app_text_styles · app_typography · app_theme · theme_mode_provider
│  ├─ utils/                      labels(한글 이름표) · color_utils · time_ago · int_bool_converter
│  ├─ widgets/                    app_chip · section_card · async_value_view · confirmation_dialog · app_error_toast
│  │                              double_back_to_exit · brand · markdown_text · empty_note · app_progress_bar
│  ├─ network/                    api_client(HTTP + 쿠키) · api_client_provider
│  └─ storage/                    preferences_provider (SharedPreferences)
└─ features/
   ├─ auth/        로그인
   ├─ home/        홈 요약
   ├─ characters/  캐릭터 목록·상세
   ├─ projects/    프로젝트 목록·상세
   └─ shell/       메인 틀(메뉴) — 서버 데이터가 없어서 presentation/만
```

기능 폴더 하나를 펼치면 (예: `features/characters/`):

```
characters/
├─ domain/                         "무엇"  — 화면도 HTTP도 모르는 순수한 부분
│  ├─ character.dart               엔티티 (freezed)
│  ├─ character_scope.dart         엔티티: 전체/서재/프로젝트 (freezed 유니온)
│  └─ characters_repository.dart   리포지토리 인터페이스
├─ data/                           "어떻게" — 서버와 이야기하는 부분
│  └─ characters_repository_impl.dart   인터페이스 구현 (ApiClient로 /api/characters 호출) + 그 provider
└─ presentation/                   "보여 주기" — 화면과 화면 상태
   ├─ character_list_state.dart    화면 상태 (freezed)   + .freezed.dart
   ├─ character_list_provider.dart 상태를 들고 바꾸는 provider (@riverpod) + .g.dart
   ├─ character_list_page.dart     화면 (HookConsumerWidget)
   ├─ character_detail_provider.dart / character_detail_page.dart
   └─ widgets/                     이 기능 전용 위젯 (portrait, character_card, character_hero ...)
```

### 세 층의 역할 (Spring으로 치면)

| 층 | 하는 일 | 알아도 되는 것 | Spring 비유 |
|---|---|---|---|
| **domain** | 엔티티(데이터 모양)와 리포지토리 **인터페이스** | 다른 기능의 domain 정도 | `@Entity` + `interface XxxRepository` |
| **data** | 인터페이스 **구현**. HTTP 호출, JSON, 쿠키·저장 | core/network, core/storage, domain | `XxxRepositoryImpl`, `RestTemplate` 쓰는 클래스 |
| **presentation** | provider(상태)·page(화면)·widgets | domain, 그리고 data의 **provider 이름**만 | `@Controller` + 뷰 템플릿 |

의존 방향은 **presentation → domain ← data** 예요. 화면은 `CharactersRepository`(인터페이스)만 알고, 그게 HTTP로 동작하는지 가짜인지 몰라요. 그래서 테스트에서 가짜로 바꿔 끼우기 쉬워요(4장 참고).

### 이 앱에서 일부러 단순하게 한 것
- **DTO를 따로 두지 않았어요.** 정석은 `data/dto/`에 JSON용 클래스를 두고 domain 엔티티로 바꾸는 거지만, 지금은 서버 JSON과 엔티티 모양이 똑같아서 엔티티에 `fromJson`을 바로 붙였어요. 서버 모양과 화면에 필요한 모양이 달라지면 그때 `data/`에 DTO를 만들고 `toEntity()`로 바꾸면 돼요.
- **유스케이스(use case) 층이 없어요.** "목록 받아 오기" 정도라 provider가 리포지토리를 바로 불러요.
- 서버 검색 조건(`?scope=library`, `?project_id=3`)으로 바꾸는 건 **data** 쪽(`CharactersRepositoryImpl.queryOf`)에 있어요. domain의 `CharacterScope`는 "어디에서 볼지"라는 뜻만 담아요.

### 이름 규칙
- `*_page.dart` — 화면 하나 (`login_page`, `character_list_page`)
- `*_provider.dart` + `*_provider.g.dart` — `@riverpod` provider와 그 생성 파일
- `*_state.dart` + `*_state.freezed.dart` — 화면 상태 (freezed)
- `*_repository.dart`(domain, 인터페이스) / `*_repository_impl.dart`(data, 구현)

---

## 2. freezed — 엔티티와 상태 클래스

### 무엇을 해 주나
Java라면 `record`(또는 Lombok `@Value`) + Jackson으로 하는 일이에요.
- 불변 필드, `==`·`hashCode`·`toString` 자동
- `copyWith(name: '새 이름')` — 일부만 바꾼 새 객체
- `json_serializable`과 같이 쓰면 `fromJson`·`toJson` 자동
- `sealed` 유니온 — Java의 `sealed interface` + 여러 `record`

### 엔티티: `features/characters/domain/character.dart`

```dart
@freezed
abstract class CharacterSummary with _$CharacterSummary {
  const factory CharacterSummary({
    required int id,
    required String name,
    String? nameEn,                                  // 서버의 name_en
    @IntBool() @Default(false) bool isFavorite,      // 서버의 is_favorite (0/1)
    @Default([]) List<String> tags,
    ...
  }) = _CharacterSummary;

  factory CharacterSummary.fromJson(Map<String, Object?> json) => _$CharacterSummaryFromJson(json);
}
```

- `const factory ... = _CharacterSummary;` — 실제 구현 클래스는 `character.freezed.dart`에 생성돼요. 우리는 **필드 목록만** 적어요.
- `@Default(...)` — JSON에 키가 없거나 null일 때 쓸 기본값.
- `@IntBool()` — 직접 만든 변환기(`core/utils/int_bool_converter.dart`). SQLite의 `0`/`1`을 `bool`로.
- **snake_case ↔ camelCase**: `app/build.yaml`의 `field_rename: snake` 한 줄로 전부 자동.
- 직접 getter를 넣으려면 `const CharacterDetail._();` 한 줄이 필요해요 (`inLibrary`, 프로젝트의 `characterCount`·`ownCount`).

### 유니온: `features/characters/domain/character_scope.dart`

```dart
@freezed
sealed class CharacterScope with _$CharacterScope {
  const factory CharacterScope.all() = AllCharacters;
  const factory CharacterScope.library() = LibraryCharacters;
  const factory CharacterScope.project({required int id, required String name}) = ProjectCharacters;
}
```

Java로 쓰면 `sealed interface CharacterScope permits All, Library, Project` + record 셋이에요. `switch`에서 하나를 빼먹으면 **컴파일 에러**라 안전해요 (`CharactersRepositoryImpl.queryOf`, 목록 화면의 `_emptyText`).

### 화면 상태: `*_state.dart`

- `features/auth/presentation/login_state.dart` — `LoginState { submitting, error }`
- `features/characters/presentation/character_list_state.dart` — `CharacterListState { scope, text }`

상태를 바꿀 땐 필드를 고치는 게 아니라 `state = state.copyWith(submitting: true)`처럼 **새 객체로 바꿔 끼워요**. 그래야 Riverpod이 "바뀌었다"를 알아채고 화면을 다시 그려요.

---

## 3. Riverpod (코드 생성) — 앱 전체가 함께 쓰는 상태

### 왜 Riverpod?
- provider 패키지는 `ChangeNotifier`(옵저버)를 위젯 트리에 매달아 쓰는 방식이라 쉽지만, 비동기 로딩·에러를 직접 만들어야 해요.
- Riverpod은 같은 작성자의 후속작. provider를 **전역으로 선언**하고(Spring의 `@Bean`과 비슷), 비동기 결과를 `AsyncValue`(로딩/에러/데이터)로 자동 관리해요.
- **코드 생성(`@riverpod`)**: 함수나 클래스에 `@riverpod`만 붙이면 build_runner가 `xxxProvider`를 만들어 줘요. 손으로 `FutureProvider.autoDispose.family<...>` 같은 긴 타입을 안 써도 돼요.

### `@riverpod` 세 가지 모양

| 쓰는 모양 | 생기는 것 | 이 앱 |
|---|---|---|
| 함수 `Future<T> foo(Ref ref)` | 비동기 값 provider `fooProvider` | `homeSummary` → `homeSummaryProvider` (`home_provider.dart`) |
| 함수에 매개변수 추가 `Future<T> foo(Ref ref, int id)` | **family**: `fooProvider(3)`. id마다 따로 캐시 | `characterDetail`, `projectDetail` |
| 클래스 `class Foo extends _$Foo { T build() ...; 메서드 }` | 바꿀 수 있는 상태 `fooProvider` + `.notifier`로 메서드 호출 | `AuthSession`, `LoginController`, `CharacterListFilter`, `AppThemeMode` |

- `@riverpod`(소문자) = **autoDispose**: 보는 화면이 없어지면 값을 버려요 (다시 보면 새로 받음). 서버 데이터, 화면 상태에 써요.
- `@Riverpod(keepAlive: true)` = 앱이 켜져 있는 동안 유지. 로그인 상태, 테마, ApiClient, 리포지토리에 써요.
- 생성 파일을 열어 보면(`home_provider.g.dart`) `HomeSummaryProvider` 클래스가 있고 `isAutoDispose: true`가 보여요.

### 낱말 정리

| 낱말 | 뜻 |
|---|---|
| `ProviderScope` | 모든 provider 값이 사는 상자. `main.dart`에서 앱 전체를 감쌈 |
| `ref.watch(p)` | 값을 읽고 **바뀌면 나도 다시 실행/다시 그리기** — `build()` 안에서 |
| `ref.read(p)` | 지금 값만 한 번 (구독 안 함) — 버튼 누를 때 같은 이벤트에서 |
| `ref.read(p.notifier).메서드()` | 클래스형 provider의 메서드 호출 (`authSessionProvider.notifier`) |
| `ref.invalidate(p)` / `ref.refresh(p)` | 버리고 다시 받기 — "다시 시도", 당겨서 새로고침 |
| `ref.mounted` | 기다리는 사이에 provider가 버려졌는지 (`login_provider.dart`에서 씀) |

### 따라가 보기 ① — 리포지토리를 provider로: `features/home/data/home_repository_impl.dart`

```dart
@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) => HomeRepositoryImpl(ref.watch(apiClientProvider));
```

돌려주는 타입이 **인터페이스**(`HomeRepository`)라는 게 중요해요. 화면 쪽은 이 provider만 알고, 구현이 무엇인지는 여기 한 곳에서만 정해요 (Spring의 `@Bean` 메서드와 같은 역할).

### 따라가 보기 ② — 서버 데이터: `features/home/presentation/home_provider.dart` → `home_page.dart`

```dart
@riverpod
Future<HomeSummary> homeSummary(Ref ref) => ref.watch(homeRepositoryProvider).fetchSummary();
```

```dart
class HomePage extends ConsumerWidget {          // ref를 받을 수 있는 StatelessWidget
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeSummaryProvider); // AsyncValue<HomeSummary>
    return AsyncValueView(value: home, builder: (data) => ...);
  }
}
```

`core/widgets/async_value_view.dart`의 `AsyncValueView`가 로딩(동그라미) / 에러(문구 + 다시 시도) / 데이터를 한 번에 그려 줘요.

### 따라가 보기 ③ — provider 사슬: `features/characters/presentation/character_list_provider.dart`

```dart
@riverpod
class CharacterListFilter extends _$CharacterListFilter {     // 지금 필터·검색어
  CharacterListState build() => const CharacterListState();
  void selectScope(CharacterScope scope) => state = state.copyWith(scope: scope);
  void search(String text) { ... }
}

@riverpod
Future<List<CharacterSummary>> characterList(Ref ref) {      // 그 조건으로 받은 목록
  final filter = ref.watch(characterListFilterProvider);     // ← 필터가 바뀌면 목록도 다시 받음
  return ref.watch(charactersRepositoryProvider).fetchList(scope: filter.scope, text: filter.text);
}
```

필터 칩을 누르면 `selectScope()` → 필터 상태가 바뀜 → 그걸 `watch`하던 `characterList`가 다시 실행 → 화면이 새 목록으로. 화면 코드에는 "다시 받아라"가 한 줄도 없어요.

### 따라가 보기 ④ — 로그인 상태: `features/auth/presentation/auth_session_provider.dart`

```dart
@Riverpod(keepAlive: true)
class AuthSession extends _$AuthSession {
  Future<User?> build() async { ... 저장된 쿠키로 /api/auth/me ... }   // 처음 값
  Future<void> login(...) async { ...; state = AsyncData(user); }
  Future<void> logout() async { ...; state = const AsyncData(null); }
  Future<void> expire() async { ... }                                 // 세션 만료
}
```

`app.dart`의 `_Gate`가 이걸 지켜보다가 user가 있으면 메인, 없으면 로그인 화면을 보여 줘요. **상태만 바꾸면 화면은 따라온다** — 로그인/로그아웃 코드 어디에도 화면 이동 코드가 없어요.
다른 화면의 요청이 401(세션 만료)을 받으면 `ApiClient.onUnauthorized` → `expire()` → 로그인 화면으로 자동으로 돌아가요.

로그인 버튼의 "보내는 중/오류"는 따로 `LoginController`(`login_provider.dart`, 상태는 `LoginState`)가 맡아요. 로그인 화면이 사라지면 같이 버려지는(autoDispose) 짧은 상태예요.

### Riverpod 3의 자동 재시도
실패한 provider를 자동으로 다시 시도해요. 서버가 준 오류(401·404)는 다시 해도 같으니 `main.dart`의 `retry:`에서 `ApiException`이면 바로 멈추게 했어요.

---

## 4. 테스트에서 갈아 끼우기 — 폴더 구조의 보람

`test/features/fakes.dart`에 domain 인터페이스의 **가짜 구현**이 있어요 (`FakeCharactersRepository` 등). `test/features/widget_test.dart`에서:

```dart
ProviderScope(
  overrides: [
    charactersRepositoryProvider.overrideWithValue(FakeCharactersRepository()),
    authRepositoryProvider.overrideWithValue(FakeAuthRepository(user: me)),
    ...
  ],
  child: const LoreShelfApp(),
)
```

화면·provider 코드는 하나도 안 바꾸고 서버만 가짜로 바뀌어요. Spring 테스트의 `@MockBean`과 같아요. 가짜 리포지토리는 "어떤 조건으로 불렸는지"를 기록해서, 필터 칩을 눌렀을 때 전체 → 서재 → 프로젝트 순으로 물었는지 확인해요.
반대로 `test/live_server_test.dart`는 **진짜 구현**(data/)으로 실제 개발 서버에 붙어서 JSON ↔ 엔티티가 맞는지 확인해요.

---

## 5. flutter_hooks — StatefulWidget 대신 HookWidget

### 무엇을 해 주나
`StatefulWidget`은 클래스가 두 개고, 컨트롤러를 `initState`에서 만들고 `dispose`에서 직접 닫아야 해요. hooks는 이걸 `build()` 안의 한 줄로 바꿔 줘요.

```dart
// StatefulWidget이었다면
class _LoginState extends State<LoginPage> {
  late final TextEditingController loginName;
  @override void initState() { super.initState(); loginName = TextEditingController(); }
  @override void dispose() { loginName.dispose(); super.dispose(); }
}

// hooks로 (features/auth/presentation/login_page.dart)
final loginName = useTextEditingController();   // 만들기 + dispose 자동
```

**규칙 하나**: `use...()`는 `build()` 맨 위에서, **항상 같은 순서로** 불러야 해요 (`if`·반복문 안 금지). 훅은 "몇 번째로 불렸나"로 자기 값을 찾아요.

### hooks와 Riverpod, 어디에 무엇을?
`HookConsumerWidget`은 `build(context, ref)`를 가지고 있어서 **훅도 쓰고 `ref.watch`도** 해요. 이 앱의 기준:

- **위젯 하나 안에서만** 필요하고 화면이 사라지면 같이 없어져도 되는 것 → **hooks**: 입력칸 컨트롤러, 탭 컨트롤러, 지금 메뉴 탭, 디바운스 타이머, "마지막으로 뒤로 가기 누른 시각"
- **화면 상태(*_state)** 나 **여러 화면이 같이 보는 것**, 서버 데이터 → **Riverpod**: 로그인 상태·오류, 캐릭터 필터, 홈 데이터, 테마

### 이 앱에서 쓴 훅

| 훅 | 어디 | 하는 일 |
|---|---|---|
| `useTextEditingController()` | `login_page.dart`, `character_list_page.dart` | 입력칸 컨트롤러 (dispose 자동) |
| `useState(초기값)` | `shell_page.dart`의 지금 탭 | 작은 상태. `.value`를 바꾸면 다시 그려짐 |
| `useValueListenable(controller)` | `character_list_page.dart` | 입력칸 글자가 바뀔 때마다 다시 그리기 (✕ 버튼) |
| `useEffect(() {...; return 정리;}, [의존값])` | `character_list_page.dart` | 검색어 **디바운스**: 입력이 300ms 멈추면 그때 `filter.search()`. 또 바뀌면 이전 타이머를 정리 함수(`timer.cancel`)로 취소 |
| `useTabController(initialLength: 2)` | `character_detail_page.dart` | 탭 컨트롤러 (vsync·dispose 자동) |
| `useListenable(tabs)` | 같은 곳 | 탭이 바뀌면 다시 그려서 프로필 ↔ 갤러리 바꾸기 |
| `useRef(값)` | `core/widgets/double_back_to_exit.dart` | 값을 담아 두되 **바뀌어도 다시 그리지 않는** 상자 (Java의 일반 필드 같은 것) |

`useEffect`는 "의존값이 바뀔 때마다 실행되는 리스너 + 해제 콜백"이에요. `[]`(빈 목록)이면 처음 한 번만.

---

## 6. 코드 생성 (build_runner) — freezed와 Riverpod 둘 다

`*.freezed.dart`, `*.g.dart`(json, provider)는 전부 build_runner가 만들어요. `app/` 폴더에서:

```bash
dart run build_runner build --force-jit
```

작업하는 동안 켜 두면 저장할 때마다 다시 만들어요:

```bash
dart run build_runner watch --force-jit
```

- `--force-jit`: 저장소 경로에 한글이 있어서 기본(AOT) 모드가 실패해요. 결과는 같아요.
- 새 파일을 만들면 `part 'xxx.g.dart';` / `part 'xxx.freezed.dart';` 줄부터 쓰고 돌려요. 생성 전엔 빨간 줄이 보이는 게 정상이에요.
- 생성 파일도 저장소에 같이 넣어요 (받자마자 실행되게, 그리고 열어 보며 공부하게).

---

## 7. 그 밖에

- **쿠키 세션** (`core/network/api_client.dart`): 앱엔 브라우저가 없어서 `Set-Cookie: ls_session=...`를 직접 꺼내 두고 요청마다 붙여요. 기기에도 저장해서 다시 켜도 로그인 유지(30일). 이미지도 `Image.network(url, headers: api.imageHeaders)`.
- **화면 폭**: `LayoutBuilder`로 넓으면 왼쪽 메뉴(`NavigationRail`), 좁으면 아래 탭(`NavigationBar`). 격자는 `SliverGridDelegateWithMaxCrossAxisExtent`라 넓을수록 열이 늘어나 화면을 꽉 채워요.
- **테마** (`core/theme/`): `AppColors`가 웹 CSS 변수를 그대로 옮긴 것(`context.colors.accent`), `AppRadii`·`AppSpacing`이 모서리·간격, `AppTextStyles`가 글자 크기. 그라데이션·그림자 없음.
- **Sliver**: `CustomScrollView(slivers: [...])` 안의 "스크롤되는 조각". 일반 위젯은 `SliverToBoxAdapter`로 감싸요. `AsyncSliverView`는 그 안에서 쓰는 로딩/에러 표시예요.

## 8. 해 볼 만한 연습

1. 캐릭터 목록에 "즐겨찾기만" 칩 — 서버는 `?favorite=1`을 지원해요. `CharacterListState`에 `favoriteOnly` 추가 → 리포지토리 인터페이스·구현에 매개변수 추가 → build_runner.
2. 즐겨찾기 별 누르기 — `PUT /api/characters/:id/favorite`. 리포지토리에 `toggleFavorite(id)` 추가, 누른 뒤 `ref.invalidate(characterDetailProvider(id))`.
3. 프로젝트 목록에 장르 필터 — `GET /api/genres` + `GET /api/projects?genre_id=`. `projects/presentation/project_list_state.dart`를 만들어 보기.
