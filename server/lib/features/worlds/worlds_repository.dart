// 세계관 DB (worlds).
import '../../core/db.dart';
import '../../core/http.dart';

class WorldsRepository {
  final Db db;
  WorldsRepository(this.db);

  static const _columns = ['name', 'summary', 'body_md', 'cover_asset_id', 'visibility', 'sort_order'];

  List<Row> list(int userId) => db.rows('''
      SELECT w.id, w.name, w.summary, w.cover_asset_id, w.visibility, w.sort_order, w.updated_at,
        (SELECT COUNT(*) FROM characters c WHERE c.world_id = w.id AND c.deleted_at IS NULL) AS character_count,
        (SELECT COUNT(*) FROM projects p WHERE p.world_id = w.id AND p.deleted_at IS NULL) AS project_count
      FROM worlds w WHERE w.user_id = ? AND w.deleted_at IS NULL
      ORDER BY w.sort_order, w.name''', [userId]);

  Row get(int userId, int id) =>
      db.one('SELECT * FROM worlds WHERE id = ? AND user_id = ? AND deleted_at IS NULL', [id, userId]) ??
      (throw ApiError('세계관을 찾을 수 없어요', 404));

  int create(int userId, Map<String, Object?> v) => db.insert(
      'INSERT INTO worlds (user_id, ${_columns.join(', ')}) VALUES (?, ${List.filled(_columns.length, '?').join(', ')})',
      [userId, ..._columns.map((c) => v[c])]);

  void update(int userId, int id, Map<String, Object?> v) {
    get(userId, id);
    db.exec('UPDATE worlds SET ${_columns.map((c) => '$c = ?').join(', ')}, updated_at = ? WHERE id = ?',
        [..._columns.map((c) => v[c]), nowAt(), id]);
  }

  void softDelete(int userId, int id) {
    get(userId, id);
    db.exec('UPDATE worlds SET deleted_at = ? WHERE id = ?', [nowAt(), id]);
  }
}
