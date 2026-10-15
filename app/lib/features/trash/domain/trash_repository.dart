// 리포지토리 인터페이스: 휴지통을 "무엇을" 할 수 있나
import 'trash_entry.dart';

abstract interface class TrashRepository {
  Future<TrashLists> fetchAll();

  Future<void> restore(TrashKind kind, int id);

  /// 영구 삭제. 되돌릴 수 없다
  Future<void> purge(TrashKind kind, int id);
}
