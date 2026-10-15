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
    expect(find.text('네거티브'), findsOneWidget);

    expect(find.text('생성 기록 1'), findsOneWidget);
    expect(find.text('전투복 · 노을 폐허'), findsOneWidget);
    expect(find.text('★ 대표'), findsOneWidget);
    expect(find.text('2984471023 · Euler a · 28스텝'), findsOneWidget);
  });
}
