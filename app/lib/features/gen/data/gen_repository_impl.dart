// 리포지토리 구현: GET /api/characters/:id/gen-presets, /gen-records, /api/gen/loras, /api/gen/tag-rules, /api/gen/negative-sets
// 만들기·고치기: POST·PUT /api/characters/:id/gen-presets|gen-records, /api/gen/presets|records/:id, 이미지 올리기 POST /api/assets
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../domain/gen.dart';
import '../domain/gen_draft.dart';
import '../domain/gen_repository.dart';

part 'gen_repository_impl.g.dart';

@Riverpod(keepAlive: true)
GenRepository genRepository(Ref ref) => GenRepositoryImpl(ref.watch(apiClientProvider));

class GenRepositoryImpl implements GenRepository {
  GenRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<List<GenPreset>> fetchPresets(int characterId) async =>
      (await _api.getList('/api/characters/$characterId/gen-presets')).map(GenPreset.fromJson).toList();

  @override
  Future<List<GenRecord>> fetchRecords(int characterId) async =>
      (await _api.getList('/api/characters/$characterId/gen-records')).map(GenRecord.fromJson).toList();

  @override
  Future<List<GenLora>> fetchLoras() async => (await _api.getList('/api/gen/loras')).map(GenLora.fromJson).toList();

  @override
  Future<Map<String, String>> fetchLearnedDictionary() async =>
      {for (final r in await _api.getList('/api/gen/tag-rules')) r['tag'] as String: r['category'] as String};

  @override
  Future<GenDefaults> fetchDefaults() async => GenDefaults.fromJson(await _api.getMap('/api/gen/defaults'));

  @override
  Future<GenDefaults> saveDefaults({List<String>? quality, List<String>? negative}) async =>
      GenDefaults.fromJson(await _api.put('/api/gen/defaults', {'quality': ?quality, 'negative': ?negative}));

  @override
  Future<List<GenNegativeSet>> fetchNegativeSets() async =>
      (await _api.getList('/api/gen/negative-sets')).map(GenNegativeSet.fromJson).toList();

  @override
  Future<GenPreset> savePreset(int characterId, int? id, GenPresetDraft draft) async => GenPreset.fromJson(
        id == null
            ? await _api.post('/api/characters/$characterId/gen-presets', draft.toPayload())
            : await _api.put('/api/gen/presets/$id', draft.toPayload()),
      );

  @override
  Future<void> deletePreset(int id) => _api.delete('/api/gen/presets/$id');

  @override
  Future<GenRecord> saveRecord(int characterId, int? id, GenRecordDraft draft) async => GenRecord.fromJson(
        id == null
            ? await _api.post('/api/characters/$characterId/gen-records', draft.toPayload())
            : await _api.put('/api/gen/records/$id', draft.toPayload()),
      );

  @override
  Future<void> deleteRecord(int id) => _api.delete('/api/gen/records/$id');

  @override
  Future<GenRecord> setCover(int id) async => GenRecord.fromJson(await _api.put('/api/gen/records/$id', {'is_cover': true}));

  @override
  Future<int> uploadImage(Uint8List bytes, String fileName) async => (await _api.upload('/api/assets', bytes, fileName))['id'] as int;
}
