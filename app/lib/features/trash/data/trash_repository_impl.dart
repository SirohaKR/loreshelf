// 리포지토리 구현: GET /api/trash, POST /api/trash/:kind/:id/restore, DELETE /api/trash/:kind/:id
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../domain/trash_entry.dart';
import '../domain/trash_repository.dart';

part 'trash_repository_impl.g.dart';

@Riverpod(keepAlive: true)
TrashRepository trashRepository(Ref ref) => TrashRepositoryImpl(ref.watch(apiClientProvider));

class TrashRepositoryImpl implements TrashRepository {
  TrashRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<TrashLists> fetchAll() async {
    final json = await _api.getMap('/api/trash');
    List<TrashEntry> rows(String key) =>
        ((json[key] as List?) ?? const []).map((e) => TrashEntry.fromJson((e as Map).cast<String, Object?>())).toList();
    return TrashLists(characters: rows('characters'), worlds: rows('worlds'), projects: rows('projects'));
  }

  @override
  Future<void> restore(TrashKind kind, int id) => _api.post('/api/trash/${kind.path}/$id/restore');

  @override
  Future<void> purge(TrashKind kind, int id) => _api.delete('/api/trash/${kind.path}/$id');
}
