// 장르·세계관 태그 DB (genres, project_genres). user_id 가 NULL이면 기본 제공 태그.
import '../../core/db.dart';
import '../../core/http.dart';

const genreCategories = ['genre', 'setting', 'mood', 'trope', 'game', 'custom'];

/// 화면에 보일 순서: 장르 → 배경·무대 → 분위기·관계 → 소재·설정 → 게임·형식 → 직접 추가 (SQL ORDER BY에 그대로 씀)
const genreCategoryOrder = "CASE g.category WHEN 'genre' THEN 1 WHEN 'setting' THEN 2 WHEN 'mood' THEN 3 WHEN 'trope' THEN 4 WHEN 'game' THEN 5 ELSE 6 END";

class GenresRepository {
  final Db db;
  GenresRepository(this.db);

  /// 기본 제공 + 내가 추가한 태그, 몇 개 프로젝트에 쓰였는지 포함.
  List<Row> list(int userId) => db.rows('''
      SELECT g.id, g.category, g.name, g.user_id IS NOT NULL AS is_custom,
        (SELECT COUNT(*) FROM project_genres pg JOIN projects p ON p.id = pg.project_id
          WHERE pg.genre_id = g.id AND p.user_id = ? AND p.deleted_at IS NULL) AS project_count
      FROM genres g WHERE g.user_id IS NULL OR g.user_id = ?
      ORDER BY $genreCategoryOrder, g.sort_order, g.id''', [userId, userId]);

  /// 내가 쓸 수 있는 태그인지 (기본 제공이거나 내가 만든 것).
  bool usable(int userId, int id) =>
      db.scalar('SELECT 1 FROM genres WHERE id = ? AND (user_id IS NULL OR user_id = ?)', [id, userId]) != null;

  /// 직접 추가. 같은 이름이 이미 있으면(기본 제공 포함) 그 태그를 돌려준다.
  Row add(int userId, String name) {
    final existing = db.one('SELECT id, category, name FROM genres WHERE name = ? AND (user_id IS NULL OR user_id = ?)', [name, userId]);
    if (existing != null) return existing;
    final id = db.insert('''INSERT INTO genres (user_id, category, name, sort_order)
        VALUES (?, 'custom', ?, (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM genres WHERE user_id = ?))''', [userId, name, userId]);
    return db.one('SELECT id, category, name FROM genres WHERE id = ?', [id])!;
  }

  /// 내가 추가한 태그만 지울 수 있다 (붙어 있던 프로젝트에서도 빠진다).
  void deleteCustom(int userId, int id) {
    if (db.exec('DELETE FROM genres WHERE id = ? AND user_id = ?', [id, userId]) == 0) {
      throw ApiError('직접 추가한 태그만 지울 수 있어요', 404);
    }
  }

  /// 프로젝트 태그를 이 목록으로 바꾸기.
  void setForProject(int projectId, Iterable<int> genreIds) {
    db.exec('DELETE FROM project_genres WHERE project_id = ?', [projectId]);
    for (final id in genreIds.toSet()) {
      db.exec('INSERT INTO project_genres (project_id, genre_id) VALUES (?, ?)', [projectId, id]);
    }
  }
}
