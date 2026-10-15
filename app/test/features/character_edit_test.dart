// 캐릭터 만들기·고치기 — 모델(CharacterDraft) 테스트 + 편집 화면 위젯 테스트 (가짜 리포지토리)
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loreshelf_app/core/theme/app_theme.dart';
import 'package:loreshelf_app/core/utils/pick_image.dart';
import 'package:loreshelf_app/features/characters/domain/character.dart';
import 'package:loreshelf_app/features/characters/domain/character_draft.dart';
import 'package:loreshelf_app/features/characters/presentation/character_detail_page.dart';
import 'package:loreshelf_app/features/characters/presentation/character_edit_page.dart';

import 'fakes.dart';
import 'widget_test.dart' show fakeOverrides;

/// 버튼 하나짜리 첫 화면 → 눌러서 편집 화면을 연다 (저장하면 닫히고 결과가 opened에 남는다)
Future<void> pumpEditor(WidgetTester tester, FakeCharactersRepository repo, {int? id, List<CharacterDetail?>? opened}) async {
  // 목록(ListView)은 화면에 보이는 것만 만들어서, 입력칸이 다 보이게 아주 긴 화면으로
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: await fakeOverrides(user: me, characters: repo),
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              final saved = await CharacterEditPage.open(context, id: id);
              opened?.add(saved);
            },
            child: const Text('열기'),
          ),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('열기'));
  await tester.pumpAndSettle();
}

Finder field(String label) => find.widgetWithText(TextField, label);

void main() {
  group('CharacterDraft', () {
    test('새 캐릭터는 기본 정보 칸 4개로 시작', () {
      final d = CharacterDraft.empty(projectId: 3);
      expect(d.fields.map((f) => f.label), defaultFieldLabels);
      expect(d.projectId, 3);
      expect(d.problem, '이름을 입력해 주세요');
    });

    test('상세 → 편집 값 → 서버 JSON (한쪽짜리 성격은 오른쪽이 빈 글자)', () {
      const c = CharacterDetail(
        id: 1,
        name: '리아',
        themeColor: '#C9573F',
        worldId: 2,
        isFavorite: true,
        sortOrder: 4,
        fields: [CharacterField(id: 1, label: '나이', value: '23', isSecret: true)],
        traits: [Trait(id: 1, leftLabel: '신중함', valuePercent: 80), Trait(id: 2, leftLabel: '내향', rightLabel: '외향', valuePercent: 28)],
        quotes: [Quote(id: 1, body: '검은 아직 내 손에 있어', situation: '결전')],
        tags: ['은발'],
      );
      final p = CharacterDraft.fromDetail(c).toPayload();
      expect(p['name'], '리아');
      expect(p['world_id'], 2);
      expect(p['is_favorite'], true);
      expect(p['sort_order'], 4);
      expect(p['fields'], [
        {'label': '나이', 'value': '23', 'is_secret': true},
      ]);
      expect((p['traits'] as List).first, {'left_label': '신중함', 'right_label': '', 'value_percent': 80});
      expect((p['quotes'] as List).first, {'body': '검은 아직 내 손에 있어', 'situation': '결전', 'is_secret': false});
      expect(p['tags'], ['은발']);
    });

    test('태그 글 나누기: # 떼기, 중복 빼기', () {
      final d = const CharacterDraft(tags: ['은발']).withTagsFrom('#은발, #복선  기사');
      expect(d.tags, ['은발', '복선', '기사']);
    });
  });

  group('편집 화면', () {
    testWidgets('이름 없이 만들면 막고, 채우면 저장 후 닫힌다', (tester) async {
      final repo = FakeCharactersRepository();
      final opened = <CharacterDetail?>[];
      await pumpEditor(tester, repo, opened: opened);

      await tester.tap(find.text('만들기'));
      await tester.pumpAndSettle();
      expect(find.text('이름을 입력해 주세요'), findsOneWidget);
      expect(repo.saved, isEmpty);

      await tester.enterText(field('이름 *'), '세라');
      await tester.tap(find.text('+ 축 추가'));
      await tester.pumpAndSettle();
      await tester.enterText(field('왼쪽 (예: 내향)'), '대담함');
      await tester.enterText(field('#은발 #복선 …'), '#은발');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('#은발'), findsOneWidget);

      await tester.ensureVisible(find.text('만들기'));
      await tester.tap(find.text('만들기'));
      await tester.pumpAndSettle();
      final p = repo.saved.single;
      expect(p['name'], '세라');
      expect(p['tags'], ['은발']);
      expect((p['traits'] as List).single, {'left_label': '대담함', 'right_label': '', 'value_percent': 50});
      expect((p['fields'] as List).length, 4);
      expect(opened.single?.name, '세라');
      expect(find.text('열기'), findsOneWidget); // 편집 화면이 닫혔다
    });

    testWidgets('서버가 거절하면 문구를 보여 주고 화면은 그대로', (tester) async {
      final repo = FakeCharactersRepository();
      await pumpEditor(tester, repo);
      await tester.enterText(field('이름 *'), '실패');
      await tester.tap(find.text('만들기'));
      await tester.pumpAndSettle();
      expect(find.text('이름이 이상해요'), findsOneWidget);
      expect(find.text('새 캐릭터'), findsOneWidget);
    });

    testWidgets('고치기: 원래 값이 채워지고, 대표 이미지를 올려 바꾼다', (tester) async {
      final repo = FakeCharactersRepository()
        ..details[5] = const CharacterDetail(id: 5, name: '미르', tagline: '말하는 고양이', tags: ['고양이']);
      final old = pickImage;
      pickImage = () async => (bytes: Uint8List.fromList([1, 2, 3]), name: 'mir.png');
      addTearDown(() => pickImage = old);

      await pumpEditor(tester, repo, id: 5);
      expect(find.text('캐릭터 편집'), findsOneWidget);
      expect(find.text('말하는 고양이'), findsOneWidget);
      expect(find.text('#고양이'), findsOneWidget);

      await tester.tap(find.text('이미지 고르기'));
      await tester.pumpAndSettle();
      expect(repo.calls, ['upload mir.png']);

      await tester.ensureVisible(find.text('저장'));
      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();
      expect(repo.saved.single['portrait_asset_id'], 77);
      expect(repo.saved.single['tagline'], '말하는 고양이');
    });
  });

  group('캐릭터 화면 버튼', () {
    Future<FakeCharactersRepository> pumpDetail(WidgetTester tester) async {
      final repo = FakeCharactersRepository()..details[5] = const CharacterDetail(id: 5, name: '미르', projectId: 1);
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: await fakeOverrides(user: me, characters: repo),
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(onPressed: () => CharacterDetailPage.open(context, 5), child: const Text('열기')),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      return repo;
    }

    testWidgets('갤러리: 이미지 추가 칸을 누르면 올리고 갤러리에 넣는다', (tester) async {
      final old = pickImage;
      pickImage = () async => (bytes: Uint8List.fromList([1]), name: 'a.png');
      addTearDown(() => pickImage = old);
      final repo = await pumpDetail(tester);
      await tester.tap(find.text('갤러리 0'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('이미지 추가'));
      await tester.pumpAndSettle();
      expect(repo.calls, ['upload a.png', 'gallery+ 77']);
    });

    testWidgets('즐겨찾기 별, 서재로 꺼내기, 휴지통으로(확인 후 화면 닫힘)', (tester) async {
      final repo = await pumpDetail(tester);
      await tester.tap(find.byTooltip('즐겨찾기'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('더 보기'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('공용 서재로 꺼내기'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('더 보기'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('휴지통으로').last);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, '휴지통으로'));
      await tester.pumpAndSettle();

      expect(repo.calls, ['favorite 5 true', 'move 5 null', 'delete 5']);
      expect(find.text('열기'), findsOneWidget);
    });
  });
}
