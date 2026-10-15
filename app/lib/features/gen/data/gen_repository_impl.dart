// 리포지토리 구현: GET /api/characters/:id/gen-presets, /api/characters/:id/gen-records
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../domain/gen.dart';
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
}
