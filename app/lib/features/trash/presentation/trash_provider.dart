// 휴지통 목록 + 되살리기·영구 삭제 (누르면 바로 하는 일들)
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../characters/presentation/character_list_provider.dart';
import '../../home/presentation/home_provider.dart';
import '../../projects/presentation/project_list_provider.dart';
import '../data/trash_repository_impl.dart';
import '../domain/trash_entry.dart';

part 'trash_provider.g.dart';

@riverpod
Future<TrashLists> trash(Ref ref) => ref.watch(trashRepositoryProvider).fetchAll();

@Riverpod(keepAlive: true)
TrashActions trashActions(Ref ref) => TrashActions(ref);

class TrashActions {
  TrashActions(this._ref);
  final Ref _ref;

  Future<void> restore(TrashKind kind, int id) => _run(() => _ref.read(trashRepositoryProvider).restore(kind, id));

  Future<void> purge(TrashKind kind, int id) => _run(() => _ref.read(trashRepositoryProvider).purge(kind, id));

  Future<void> _run(Future<void> Function() work) async {
    await work();
    _ref
      ..invalidate(trashProvider)
      ..invalidate(characterListProvider)
      ..invalidate(projectListProvider)
      ..invalidate(homeSummaryProvider);
  }
}
