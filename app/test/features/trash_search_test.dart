// 휴지통(되살리기·영구 삭제)과 검색 화면 — 가짜 리포지토리로
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;
import 'package:loreshelf_app/core/theme/app_theme.dart';
import 'package:loreshelf_app/features/search/domain/search_result.dart';
import 'package:loreshelf_app/features/search/presentation/search_page.dart';
import 'package:loreshelf_app/features/trash/domain/trash_entry.dart';
import 'package:loreshelf_app/features/trash/presentation/trash_page.dart';

import 'fakes.dart';
import 'widget_test.dart' show fakeOverrides;

Future<void> pumpPage(WidgetTester tester, Widget page, List<Override> overrides) async {
  tester.view.physicalSize = const Size(1200, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(overrides: overrides, child: MaterialApp(theme: AppTheme.light(), home: page)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('휴지통: 되살리기 · 영구 삭제(확인 거침)', (tester) async {
    final repo = FakeTrashRepository(
      lists: const TrashLists(
        characters: [TrashEntry(id: 1, name: '리아', deletedAt: '2026-10-01T00:00:00Z', projectName: '잿빛 왕관')],
        projects: [TrashEntry(id: 2, name: '옛 기획', deletedAt: '2026-09-01T00:00:00Z', ownCharacterCount: 2)],
      ),
    );
    await pumpPage(tester, const TrashPage(), await fakeOverrides(user: me, trash: repo));

    expect(find.text('캐릭터 1'), findsOneWidget);
    expect(find.text('리아'), findsOneWidget);
    expect(find.textContaining('잿빛 왕관 전용'), findsOneWidget);
    expect(find.text('프로젝트 1'), findsOneWidget);
    expect(find.textContaining('전용 캐릭터 2명'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, '되살리기').first);
    await tester.pumpAndSettle();
    expect(repo.calls, ['restore characters 1']);

    await tester.tap(find.widgetWithText(TextButton, '영구 삭제').last); // 프로젝트 줄
    await tester.pumpAndSettle();
    expect(find.textContaining('남기고 싶으면'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '영구 삭제'));
    await tester.pumpAndSettle();
    expect(repo.calls, ['restore characters 1', 'purge projects 2']);
  });

  testWidgets('휴지통이 비어 있으면 안내 문구', (tester) async {
    await pumpPage(tester, const TrashPage(), await fakeOverrides(user: me));
    expect(find.text('휴지통이 비어 있어요'), findsOneWidget);
  });

  testWidgets('검색: 입력이 멈추면 찾아서 보여 준다', (tester) async {
    final repo = FakeSearchRepository(
      results: const SearchResults(
        characters: [SearchCharacterHit(id: 1, name: '리아 벨로트', tagline: '몰락한 왕가의 마지막 기사', matchedIn: 'tagline')],
        projects: [SearchProjectHit(id: 2, name: '잿빛 왕관', kind: 'game', summary: '2D 턴제 RPG')],
      ),
    );
    await pumpPage(tester, const SearchPage(), await fakeOverrides(user: me, search: repo));

    expect(find.text('찾을 말을 입력해 보세요'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '리아');
    await tester.pump(); // 입력칸 값이 바뀜 → 디바운스 타이머 걸림
    await tester.pump(const Duration(milliseconds: 350)); // 타이머 발동
    await tester.pumpAndSettle();

    expect(repo.asked, ['리아']);
    expect(find.text('리아 벨로트'), findsOneWidget);
    expect(find.textContaining('소개·대사에서 찾음'), findsOneWidget);
    expect(find.text('잿빛 왕관'), findsOneWidget);
    expect(find.textContaining("'리아' 검색 결과"), findsOneWidget);
  });
}
