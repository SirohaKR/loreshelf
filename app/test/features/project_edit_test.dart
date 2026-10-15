// 프로젝트 만들기·고치기 + 장르 태그 고르기 창 (가짜 리포지토리)
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loreshelf_app/core/theme/app_theme.dart';
import 'package:loreshelf_app/features/projects/domain/genre.dart';
import 'package:loreshelf_app/features/projects/domain/project.dart';
import 'package:loreshelf_app/features/projects/domain/project_draft.dart';
import 'package:loreshelf_app/features/projects/presentation/project_detail_page.dart';
import 'package:loreshelf_app/features/projects/presentation/project_edit_page.dart';

import 'fakes.dart';
import 'widget_test.dart' show fakeOverrides;

void main() {
  test('ProjectDraft: 상세 → 서버 JSON (장르는 번호만)', () {
    const p = ProjectDetail(
      id: 1,
      name: '잿빛 왕관',
      kind: 'game',
      progressPercent: 60,
      worldId: 4,
      genres: [Genre(id: 1, category: 'genre', name: '로맨스 판타지'), Genre(id: 7, category: 'mood', name: '복수')],
    );
    final json = ProjectDraft.fromDetail(p).toPayload();
    expect(json['genre_ids'], [1, 7]);
    expect(json['progress_percent'], 60);
    expect(json['world_id'], 4);
    expect(const ProjectDraft().problem, '이름을 입력해 주세요');
  });

  testWidgets('새 프로젝트: 태그 고르기 창(찾기·고르기·직접 추가) → 만들기', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = FakeProjectsRepository();
    await tester.pumpWidget(ProviderScope(
      overrides: await fakeOverrides(user: me, projects: repo),
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(onPressed: () => ProjectEditPage.open(context), child: const Text('열기')),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, '이름 *'), '별의 학원');
    await tester.tap(find.text('# 태그 고르기'));
    await tester.pumpAndSettle();
    expect(find.text('배경·무대'), findsOneWidget); // 카테고리 제목

    await tester.tap(find.widgetWithText(FilterChip, '학원'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, '태그 찾기 (예: 로판, 학원, 복수)'), '복');
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilterChip, '학원'), findsNothing); // 찾기로 걸러짐
    expect(find.widgetWithText(FilterChip, '복수'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '직접 추가할 태그'), '사이버펑크');
    await tester.tap(find.text('+ 추가'));
    await tester.pumpAndSettle();
    expect(find.text('2개 고름'), findsOneWidget);

    await tester.tap(find.text('넣기'));
    await tester.pumpAndSettle();
    expect(find.text('사이버펑크'), findsOneWidget); // 편집 화면의 칩

    await tester.tap(find.text('만들기'));
    await tester.pumpAndSettle();
    expect(repo.saved.single['name'], '별의 학원');
    expect(repo.saved.single['genre_ids'], [2, 93]);
    expect(find.text('열기'), findsOneWidget);
  });

  testWidgets('프로젝트 상세: 서재에서 연결 → 역할 보기 → 연결 끊기', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final projects = FakeProjectsRepository();
    await tester.pumpWidget(ProviderScope(
      overrides: await fakeOverrides(user: me, projects: projects),
      child: MaterialApp(theme: AppTheme.light(), home: const ProjectDetailPage(id: 1)),
    ));
    await tester.pumpAndSettle();
    expect(find.text('연결된 서재 캐릭터'), findsNothing); // 아직 연결 없음

    await tester.tap(find.text('서재에서 연결'));
    await tester.pumpAndSettle();
    expect(find.text('미르'), findsOneWidget); // 서재 캐릭터(mir)가 후보로 보임

    await tester.tap(find.text('미르'));
    await tester.enterText(find.widgetWithText(TextField, '역할 (선택)'), '조언자');
    await tester.tap(find.text('연결'));
    await tester.pumpAndSettle();

    expect(projects.linkedByProject[1]!.single.role, '조언자');
    expect(find.text('연결된 서재 캐릭터'), findsOneWidget);
    expect(find.text('조언자'), findsWidgets);

    await tester.tap(find.text('연결 끊기'));
    await tester.pumpAndSettle();
    expect(projects.linkedByProject[1], isEmpty);
    expect(find.text('연결된 서재 캐릭터'), findsNothing);
  });

  testWidgets('프로젝트 상세: 휴지통으로(확인 후 화면 닫힘)', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final projects = FakeProjectsRepository();
    await tester.pumpWidget(ProviderScope(
      overrides: await fakeOverrides(user: me, projects: projects),
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(onPressed: () => ProjectDetailPage.open(context, 1), child: const Text('열기')),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('휴지통으로'));
    await tester.pumpAndSettle();
    expect(find.textContaining('휴지통으로 옮길까요'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '휴지통으로'));
    await tester.pumpAndSettle();

    expect(projects.deleted, [1]);
    expect(find.text('열기'), findsOneWidget); // 화면이 닫히고 이전 화면으로
  });
}
