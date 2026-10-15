// 위젯 테스트 — 서버 없이 리포지토리 provider를 가짜 구현으로 바꿔 끼워(overrides) 앱 전체를 그려 본다
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;
import 'package:loreshelf_app/app.dart';
import 'package:loreshelf_app/core/storage/preferences_provider.dart';
import 'package:loreshelf_app/core/theme/app_colors.dart';
import 'package:loreshelf_app/features/auth/data/auth_repository_impl.dart';
import 'package:loreshelf_app/features/auth/domain/user.dart';
import 'package:loreshelf_app/features/characters/data/characters_repository_impl.dart';
import 'package:loreshelf_app/features/characters/domain/character_scope.dart';
import 'package:loreshelf_app/features/home/data/home_repository_impl.dart';
import 'package:loreshelf_app/features/projects/data/projects_repository_impl.dart';
import 'package:loreshelf_app/features/search/data/search_repository_impl.dart';
import 'package:loreshelf_app/features/trash/data/trash_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

Future<List<Override>> fakeOverrides({
  User? user,
  FakeCharactersRepository? characters,
  FakeProjectsRepository? projects,
  FakeTrashRepository? trash,
  FakeSearchRepository? search,
}) async {
  SharedPreferences.setMockInitialValues({});
  return [
    sharedPreferencesProvider.overrideWithValue(await SharedPreferences.getInstance()),
    authRepositoryProvider.overrideWithValue(FakeAuthRepository(user: user)),
    homeRepositoryProvider.overrideWithValue(FakeHomeRepository()),
    projectsRepositoryProvider.overrideWithValue(projects ?? FakeProjectsRepository()),
    charactersRepositoryProvider.overrideWithValue(characters ?? FakeCharactersRepository()),
    trashRepositoryProvider.overrideWithValue(trash ?? FakeTrashRepository()),
    searchRepositoryProvider.overrideWithValue(search ?? FakeSearchRepository()),
  ];
}

void wideScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('로그인: 틀리면 오류 문구, 맞으면 홈으로', (tester) async {
    wideScreen(tester);
    await tester.pumpWidget(ProviderScope(overrides: await fakeOverrides(), child: const LoreShelfApp()));
    await tester.pumpAndSettle();
    expect(find.text('서버 주소'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('login-name')), 'dev');
    await tester.enterText(find.byKey(const Key('login-password')), 'wrong');
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();
    expect(find.text('아이디 또는 비밀번호가 맞지 않아요'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('login-password')), 'pw');
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();
    expect(find.text('안녕하세요, 주인장님'), findsOneWidget);
  });

  testWidgets('홈: 숫자, 최근 캐릭터, 프로젝트와 장르 태그, 넓은 화면은 왼쪽 메뉴', (tester) async {
    wideScreen(tester);
    await tester.pumpWidget(ProviderScope(overrides: await fakeOverrides(user: me), child: const LoreShelfApp()));
    await tester.pumpAndSettle();

    expect(find.text('6'), findsOneWidget);
    expect(find.text('리아 벨로트'), findsOneWidget);
    expect(find.text('잿빛 왕관'), findsOneWidget);
    expect(find.text('#로맨스 판타지'), findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);
  });

  testWidgets('캐릭터 목록: 필터 칩을 누르면 그 조건으로 다시 묻는다', (tester) async {
    wideScreen(tester);
    final repo = FakeCharactersRepository();
    await tester.pumpWidget(
      ProviderScope(overrides: await fakeOverrides(user: me, characters: repo), child: const LoreShelfApp()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('캐릭터').first); // 왼쪽 메뉴
    await tester.pumpAndSettle();

    await tester.tap(find.text('서재'));
    await tester.pumpAndSettle();
    expect(find.text('말하는 고양이'), findsWidgets);

    await tester.tap(find.text('잿빛 왕관'));
    await tester.pumpAndSettle();
    expect(repo.asked, [
      const CharacterScope.all(),
      const CharacterScope.library(),
      const CharacterScope.project(id: 1, name: '잿빛 왕관'),
    ]);
  });

  testWidgets('로그아웃은 확인 창을 거쳐 로그인 화면으로', (tester) async {
    wideScreen(tester);
    await tester.pumpWidget(ProviderScope(overrides: await fakeOverrides(user: me), child: const LoreShelfApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('로그아웃 (주인장)'));
    await tester.pumpAndSettle();
    expect(find.text('로그아웃할까요?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '로그아웃'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('login-name')), findsOneWidget);
  });

  testWidgets('다크 모드 전환 버튼', (tester) async {
    wideScreen(tester);
    await tester.pumpWidget(ProviderScope(overrides: await fakeOverrides(user: me), child: const LoreShelfApp()));
    await tester.pumpAndSettle();

    Theme theme() => tester.widget<Theme>(find.byType(Theme).last);
    final before = theme().data.brightness;
    await tester.tap(find.byTooltip('라이트/다크 전환'));
    await tester.pumpAndSettle();
    final after = theme().data.brightness;

    expect(after, isNot(before));
    expect(theme().data.scaffoldBackgroundColor, after == Brightness.dark ? AppColors.dark.bg : AppColors.light.bg);
  });
}
