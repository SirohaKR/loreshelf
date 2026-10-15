// 프로젝트 DB (projects, project_characters). 장르·세계관 태그는 project_genres.
import 'dart:convert';

import '../../core/db.dart';
import '../../core/http.dart';
import '../genres/genres_repository.dart';

const projectKinds = ['game', 'chatbot', 'etc'];

class ProjectsRepository {
  final Db db;
  ProjectsRepository(this.db);

  static const _columns = ['world_id', 'kind', 'name', 'summary', 'body_md', 'cover_asset_id', 'progress_percent', 'visibility', 'sort_order'];

  // 프로젝트에 붙은 장르 태그 [{id, category, name}] (JSON 한 칸으로 받아서 _withGenres가 풀어 줌)
  static const _genresSelect = '''(SELECT json_group_array(json_object('id', g.id, 'category', g.category, 'name', g.name))
        FROM (SELECT g.* FROM project_genres pg JOIN genres g ON g.id = pg.genre_id WHERE pg.project_id = p.id
              ORDER BY $genreCategoryOrder, g.sort_order) g) AS genres_json''';

  static Row _withGenres(Row r) {
    final out = Map<String, Object?>.from(r);
    out['genres'] = jsonDecode(out.remove('genres_json') as String? ?? '[]');
    return out;
  }

  /// 목록. 캐릭터 수 = 전용 + 연결. [genreId]: 그 태그가 붙은 프로젝트만.
  List<Row> list(int userId, {int? worldId, int? genreId}) => db.rows('''
      SELECT p.id, p.world_id, w.name AS world_name, p.kind, p.name, p.summary, p.cover_asset_id,
        p.progress_percent, p.visibility, p.sort_order, p.updated_at,
        (SELECT COUNT(*) FROM characters c WHERE c.project_id = p.id AND c.deleted_at IS NULL) AS own_character_count,
        (SELECT COUNT(*) FROM project_characters pc JOIN characters c ON c.id = pc.character_id
          WHERE pc.project_id = p.id AND c.deleted_at IS NULL) AS linked_character_count,
        $_genresSelect
      FROM projects p LEFT JOIN worlds w ON w.id = p.world_id
      WHERE p.user_id = ? AND p.deleted_at IS NULL AND (? IS NULL OR p.world_id = ?)
        AND (? IS NULL OR p.id IN (SELECT project_id FROM project_genres WHERE genre_id = ?))
      ORDER BY p.sort_order, p.updated_at DESC''', [userId, worldId, worldId, genreId, genreId]).map(_withGenres).toList();

  Row get(int userId, int id) => _withGenres(
      db.one('''SELECT p.*, w.name AS world_name, $_genresSelect FROM projects p LEFT JOIN worlds w ON w.id = p.world_id
                WHERE p.id = ? AND p.user_id = ? AND p.deleted_at IS NULL''', [id, userId]) ??
      (throw ApiError('프로젝트를 찾을 수 없어요', 404)));

  int create(int userId, Map<String, Object?> v) => db.insert(
      'INSERT INTO projects (user_id, ${_columns.join(', ')}) VALUES (?, ${List.filled(_columns.length, '?').join(', ')})',
      [userId, ..._columns.map((c) => v[c])]);

  void update(int userId, int id, Map<String, Object?> v) {
    get(userId, id);
    db.exec('UPDATE projects SET ${_columns.map((c) => '$c = ?').join(', ')}, updated_at = ? WHERE id = ?',
        [..._columns.map((c) => v[c]), nowAt(), id]);
  }

  void softDelete(int userId, int id) {
    get(userId, id);
    db.exec('UPDATE projects SET deleted_at = ? WHERE id = ?', [nowAt(), id]);
  }

  /// 서재 캐릭터를 프로젝트에 연결 (이미 연결돼 있으면 역할만 바꿈).
  void link(int projectId, int characterId, String? role) => db.exec('''
      INSERT INTO project_characters (project_id, character_id, role, sort_order)
      VALUES (?, ?, ?, (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM project_characters WHERE project_id = ?))
      ON CONFLICT (project_id, character_id) DO UPDATE SET role = excluded.role''', [projectId, characterId, role, projectId]);

  void unlink(int projectId, int characterId) =>
      db.exec('DELETE FROM project_characters WHERE project_id = ? AND character_id = ?', [projectId, characterId]);

  /// 캐릭터가 연결된 프로젝트들 (캐릭터 상세 화면용).
  List<Row> linkedToCharacter(int characterId) => db.rows('''
      SELECT p.id, p.name, p.kind, pc.role FROM project_characters pc JOIN projects p ON p.id = pc.project_id
      WHERE pc.character_id = ? AND p.deleted_at IS NULL ORDER BY p.name''', [characterId]);
}
