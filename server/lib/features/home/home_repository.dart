// 홈 화면 숫자 요약 DB.
import '../../core/db.dart';

class HomeRepository {
  final Db db;
  HomeRepository(this.db);

  Map<String, Object?> counts(int userId) => db.one('''
      SELECT
        (SELECT COUNT(*) FROM characters c LEFT JOIN projects p ON p.id = c.project_id
          WHERE c.user_id = ?1 AND c.deleted_at IS NULL AND (c.project_id IS NULL OR p.deleted_at IS NULL)) AS characters,
        (SELECT COUNT(*) FROM worlds WHERE user_id = ?1 AND deleted_at IS NULL) AS worlds,
        (SELECT COUNT(*) FROM projects WHERE user_id = ?1 AND deleted_at IS NULL) AS projects,
        (SELECT COUNT(*) FROM characters WHERE user_id = ?1 AND deleted_at IS NULL AND visibility = 'public')
          + (SELECT COUNT(*) FROM worlds WHERE user_id = ?1 AND deleted_at IS NULL AND visibility = 'public')
          + (SELECT COUNT(*) FROM projects WHERE user_id = ?1 AND deleted_at IS NULL AND visibility = 'public') AS public_items''', [userId])!;
}
