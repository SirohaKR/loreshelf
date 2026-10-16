// 이미지·프롬프트(2단계) — 엔티티 JSON, 프롬프트 글 만들기, 탭 화면(가짜 리포지토리)
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loreshelf_app/core/storage/preferences_provider.dart';
import 'package:loreshelf_app/core/theme/app_theme.dart';
import 'package:loreshelf_app/features/gen/data/gen_repository_impl.dart';
import 'package:loreshelf_app/features/gen/domain/gen.dart';
import 'package:loreshelf_app/features/gen/domain/gen_draft.dart';
import 'package:loreshelf_app/features/gen/domain/gen_repository.dart';
import 'package:loreshelf_app/features/gen/presentation/widgets/character_gen_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 서버 GET /api/characters/1/gen-records 가 보내는 한 줄 그대로
final recordJson = <String, Object?>{
  'id': 7,
  'character_id': 1,
  'asset_id': null,
  'title': '전투복 · 노을 폐허',
  'platform_name': 'Stable Diffusion WebUI',
  'model_name': 'illustriousXL_v01',
  'preset_name': '전투복',
  'tags': {
    'character': [
      {'tag': '1girl', 'weight': 1},
      {'tag': 'silver hair', 'weight': 1.2},
    ],
    'quality': [
      {'tag': 'masterpiece', 'weight': 1.0},
    ],
  },
  'negative': ['lowres'],
  'loras': [
    {'gen_lora_id': 3, 'name': 'liaBellot_v2', 'weight': 0.8},
    {'gen_lora_id': null, 'name': 'unknown', 'weight': 1},
  ],
  'extra': {'Model hash': 'abc'},
  'seed': 2984471023,
  'sampler': 'Euler a',
  'steps': 28,
  'cfg_scale': 6,
  'is_cover': 1,
  'created_at': '2026-10-15T07:00:00Z',
};

class FakeGenRepository implements GenRepository {
  @override
  Future<List<GenPreset>> fetchPresets(int characterId) async => [
        const GenPreset(id: 1, name: '기본 외형', tags: {
          'character': [GenTag(tag: 'silver hair', weight: 1.2)],
        }),
        const GenPreset(id: 2, name: '전투복', tags: {
          'outfit': [GenTag(tag: 'silver armor')],
        }, negative: ['lowres']),
      ];

  @override
  Future<List<GenRecord>> fetchRecords(int characterId) async => [GenRecord.fromJson(recordJson)];

  @override
  Future<List<GenLora>> fetchLoras() async => const [GenLora(id: 3, name: 'liaBellot_v2', defaultWeight: 0.8)];

  @override
  Future<Map<String, String>> fetchLearnedDictionary() async => const {};

  var defaults = const GenDefaults(quality: ['masterpiece'], negative: ['lowres']);

  @override
  Future<GenDefaults> fetchDefaults() async => defaults;

  @override
  Future<GenDefaults> saveDefaults({List<String>? quality, List<String>? negative}) async =>
      defaults = GenDefaults(quality: quality ?? defaults.quality, negative: negative ?? defaults.negative);

  @override
  Future<List<GenNegativeSet>> fetchNegativeSets() async => const [
        GenNegativeSet(name: '품질', negative: ['lowres', 'worst quality'], builtin: true),
        GenNegativeSet(id: 1, name: '내 세트', negative: ['nsfw']),
      ];

  final savedPresets = <Map<String, Object?>>[];
  final savedRecords = <Map<String, Object?>>[];
  final calls = <String>[];

  @override
  Future<GenPreset> savePreset(int characterId, int? id, GenPresetDraft draft) async {
    savedPresets.add(draft.toPayload());
    return GenPreset(id: id ?? 90, name: draft.name, tags: draft.tags, negative: draft.negative, loras: draft.loras);
  }

  @override
  Future<void> deletePreset(int id) async => calls.add('deletePreset $id');

  @override
  Future<GenRecord> saveRecord(int characterId, int? id, GenRecordDraft draft) async {
    savedRecords.add(draft.toPayload());
    return GenRecord(
      id: id ?? 91,
      title: draft.title,
      assetId: draft.assetId,
      platformName: draft.platform,
      modelName: draft.model,
      tags: draft.tags,
      negative: draft.negative,
      loras: draft.loras,
      seed: draft.seed,
      sampler: draft.sampler,
      steps: draft.steps,
      cfgScale: draft.cfgScale,
      width: draft.width,
      height: draft.height,
      note: draft.note,
      isCover: draft.isCover,
    );
  }

  @override
  Future<void> deleteRecord(int id) async => calls.add('deleteRecord $id');

  @override
  Future<GenRecord> setCover(int id) async {
    calls.add('setCover $id');
    return GenRecord.fromJson({...recordJson, 'id': id, 'is_cover': 1});
  }

  @override
  Future<int> uploadImage(Uint8List bytes, String fileName) async {
    calls.add('upload $fileName');
    return 77;
  }
}

void main() {
  test('생성 기록 JSON → 엔티티 (정수 가중치·0/1 대표·큰 시드)', () {
    final r = GenRecord.fromJson(recordJson);
    expect(r.isCover, isTrue);
    expect(r.cfgScale, 6.0);
    expect(r.seed, 2984471023);
    expect(r.tags['character']![0].weight, 1.0);
    expect(r.loras[1].genLoraId, isNull);
    expect(r.seedLine, '2984471023 · Euler a · 28스텝');
    expect(r.usedCategories, ['character', 'quality']);
  });

  test('프롬프트 글 — 서버·웹과 같은 shared 규칙', () {
    final r = GenRecord.fromJson(recordJson);
    expect(r.promptText(), '1girl, (silver hair:1.2), masterpiece, <lora:liaBellot_v2:0.8>, <lora:unknown:1>\nNegative prompt: lowres');
    expect(r.promptText(novelai: true), '1girl, 1.2::silver hair::, masterpiece\n네거티브: lowres');
    expect(r.lineOf('character'), '1girl, (silver hair:1.2)');
  });

  test('기록 복사 = 고정 프롬프트 + 기록 (겹치는 태그는 한 번만)', () {
    const preset = GenPreset(id: 1, name: '기본 외형', tags: {
      'character': [GenTag(tag: 'silver hair', weight: 1.2)],
    }, negative: ['lowres']);
    final r = GenRecord.fromJson(recordJson);
    expect(MergedPrompt(preset, r).promptText(),
        '(silver hair:1.2), 1girl, masterpiece, <lora:liaBellot_v2:0.8>, <lora:unknown:1>\nNegative prompt: lowres');
    const d = GenDefaults(quality: ['best quality', 'masterpiece'], negative: ['bad hands']);
    expect(WithDefaults(d, MergedPrompt(preset, r)).promptText(),
        '(silver hair:1.2), 1girl, best quality, masterpiece, <lora:liaBellot_v2:0.8>, <lora:unknown:1>\nNegative prompt: bad hands, lowres');
  });

  test('칩 ✕ 도우미', () {
    final tags = {
      'character': [const GenTag(tag: 'a'), const GenTag(tag: 'b')],
      'pose': [const GenTag(tag: 'c')],
    };
    expect(tagsWithout(tags, 'character', 0)['character'], [const GenTag(tag: 'b')]);
    expect(tagsWithout(tags, 'pose', 0).containsKey('pose'), isFalse);
    expect(negativeWithout(['x', 'y'], 1), ['x']);
  });

  Future<FakeGenRepository> pumpTab(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = FakeGenRepository();
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs), genRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: SingleChildScrollView(child: CharacterGenTab(1))),
      ),
    ));
    await tester.pumpAndSettle();
    return repo;
  }

  testWidgets('고정 프롬프트 칩: 누르면 ✕, ✕로 지우면 저장', (tester) async {
    final repo = await pumpTab(tester);
    expect(find.byIcon(Icons.close), findsNothing);
    await tester.tap(find.text('silver hair 1.2'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(repo.savedPresets.last['tags'], isEmpty);
  });

  testWidgets('공통 기본값: 네거티브 세트 넣기, 글로 더하기, ✕로 빼기', (tester) async {
    final repo = await pumpTab(tester);
    expect(find.text('모든 캐릭터 공통 기본값'), findsOneWidget);
    await tester.tap(find.text('+ 품질'));
    await tester.pumpAndSettle();
    expect(repo.defaults.negative, ['lowres', 'worst quality']);

    await tester.enterText(find.widgetWithText(TextField, '태그 추가 (쉼표로 나눠서)'), 'absurdres, masterpiece');
    await tester.tap(find.text('추가'));
    await tester.pumpAndSettle();
    expect(repo.defaults.quality, ['masterpiece', 'absurdres']);

    await tester.tap(find.text('absurdres'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(repo.defaults.quality, ['masterpiece']);
  });

  testWidgets('붙여 넣으면 공통 기본값과 겹치는 태그는 빠지고 작게 보인다', (tester) async {
    await pumpTab(tester);
    await tester.enterText(find.widgetWithText(TextField, '프롬프트 붙여넣기'), 'masterpiece, 1boy\nNegative prompt: lowres, extra ears');
    await tester.pump();
    await tester.tap(find.text('자동 분류'));
    await tester.pumpAndSettle();
    expect(find.text('공통 기본값과 겹쳐서 뺐어요: masterpiece, lowres'), findsOneWidget);
    expect(find.text('extra ears'), findsOneWidget);
  });

  testWidgets('붙여넣기 → 고정 / 이번만 나눠서 저장 (이미 있는 태그는 빼고)', (tester) async {
    final repo = await pumpTab(tester);
    await tester.enterText(find.widgetWithText(TextField, '프롬프트 붙여넣기'), '1boy, silver hair, shy, black vest, bouquet, smile, portrait, white background');
    await tester.pump();
    await tester.tap(find.text('자동 분류'));
    await tester.pumpAndSettle();
    expect(find.text('성격·분위기'), findsOneWidget);
    expect(find.text('소품'), findsOneWidget);
    expect(find.text('이번만'), findsWidgets);

    // 의상은 이번만으로 바꿔 본다
    final outfitRow = find.ancestor(of: find.text('의상'), matching: find.byType(Column)).first;
    await tester.tap(find.descendant(of: outfitRow, matching: find.text('이번만')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('고정 / 이번만 나눠서 저장'));
    await tester.pumpAndSettle();
    expect(find.text("고정 프롬프트 '기본 외형'에 추가돼요 · 2개"), findsOneWidget); // 1boy, shy (silver hair는 이미 있음)
    expect(find.text('이미 들어 있는 1개는 건너뛰어요'), findsOneWidget);
    expect(find.text('이번 생성 기록에 들어가요 · 5개'), findsOneWidget);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인하고 저장'));
    await tester.pumpAndSettle();

    final saved = repo.savedPresets.last['tags'] as Map;
    expect([for (final t in saved['character'] as List) (t as Map)['tag']], ['silver hair', '1boy']);
    expect([for (final t in saved['personality'] as List) (t as Map)['tag']], ['shy']);
    expect(saved.containsKey('outfit'), isFalse);
    expect(saved.containsKey('pose'), isFalse);
    expect(repo.savedRecords, isEmpty);
  });

  testWidgets('이미지·프롬프트 탭: 프리셋 고르기, 기록 보기', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs), genRepositoryProvider.overrideWithValue(FakeGenRepository())],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: SingleChildScrollView(child: CharacterGenTab(1))),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('silver hair 1.2'), findsOneWidget); // 첫 프리셋 (가중치가 태그 옆에)
    expect(find.text('인물·외형'), findsOneWidget);
    await tester.tap(find.text('전투복').first);
    await tester.pumpAndSettle();
    expect(find.text('silver armor'), findsOneWidget);
    expect(find.text('네거티브'), findsWidgets);

    expect(find.text('생성 기록 1'), findsOneWidget);
    expect(find.text('전투복 · 노을 폐허'), findsOneWidget);
    expect(find.text('★ 대표'), findsOneWidget);
    expect(find.text('2984471023 · Euler a · 28스텝'), findsOneWidget);
  });
}
