// 휴지통 DB — deleted_at 이 채워진 캐릭터·세계관·프로젝트. 되살리기, 영구 삭제.
import '../../core/db.dart';
import '../../core/http.dart';

/// 주소의 종류 이름 → 테이블 (주소 값을 테이블 이름으로 바로 쓰지 않는다).
const trashTables = {'characters': 'characters', 'worlds': 'worlds', 'projects': 'projects'};

class TrashRepository {
  final Db db;
  TrashRepository(this.db);

  Map<String, List<Row>> list(int userId) => {
        'characters': db.rows('''SELECT c.id, c.name, c.deleted_at, p.name AS project_name FROM characters c
              LEFT JOIN projects p ON p.id = c.project_id
              WHERE c.user_id = ? AND c.deleted_at IS NOT NULL ORDER BY c.deleted_at DESC''', [userId]),
        'worlds': db.rows('SELECT id, name, deleted_at FROM worlds WHERE user_id = ? AND deleted_at IS NOT NULL ORDER BY deleted_at DESC', [userId]),
        'projects': db.rows('''SELECT p.id, p.name, p.deleted_at,
              (SELECT COUNT(*) FROM characters c WHERE c.project_id = p.id) AS own_character_count
              FROM projects p WHERE p.user_id = ? AND p.deleted_at IS NOT NULL ORDER BY p.deleted_at DESC''', [userId]),
      };

  String _table(String kind) => trashTables[kind] ?? (throw ApiError('없는 종류예요', 404));

  void _requireDeleted(String table, int userId, int id) {
    if (db.scalar('SELECT 1 FROM $table WHERE id = ? AND user_id = ? AND deleted_at IS NOT NULL', [id, userId]) == null) {
      throw ApiError('휴지통에서 찾을 수 없어요', 404);
    }
  }

  void restore(int userId, String kind, int id) {
    final table = _table(kind);
    _requireDeleted(table, userId, id);
    db.exec('UPDATE $table SET deleted_at = NULL, updated_at = ? WHERE id = ?', [nowAt(), id]);
  }

  /// 영구 삭제. 프로젝트를 지우면 그 전용 캐릭터도 같이 지워진다 (DB의 ON DELETE CASCADE).
  void purge(int userId, String kind, int id) {
    final table = _table(kind);
    _requireDeleted(table, userId, id);
    db.exec('DELETE FROM $table WHERE id = ?', [id]);
  }
}
