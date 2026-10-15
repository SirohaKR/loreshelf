// 통합 검색 DB — 캐릭터(이름·소개·대사·배경·기본 정보·태그), 세계관, 프로젝트.
// 1인용 데이터 양이라 LIKE로 충분. 많아지면 SQLite FTS5로 바꾼다.
import '../../core/db.dart';
import '../characters/characters_repository.dart' show likePattern;

class SearchRepository {
  final Db db;
  SearchRepository(this.db);

  static const _e = "ESCAPE '\\'";

  Map<String, List<Row>> search(int userId, String q) {
    final like = likePattern(q);
    final characters = db.rows('''
        SELECT c.id, c.name, c.name_en, c.tagline, c.portrait_asset_id, c.theme_color, p.name AS project_name,
          CASE
            WHEN c.name LIKE ?1 $_e OR c.name_en LIKE ?1 $_e THEN 'name'
            WHEN c.tagline LIKE ?1 $_e OR c.quote LIKE ?1 $_e THEN 'tagline'
            WHEN EXISTS (SELECT 1 FROM character_tags ct JOIN tags t ON t.id = ct.tag_id WHERE ct.character_id = c.id AND t.name LIKE ?1 $_e) THEN 'tag'
            WHEN EXISTS (SELECT 1 FROM character_fields f WHERE f.character_id = c.id AND (f.label LIKE ?1 $_e OR f.value LIKE ?1 $_e)) THEN 'field'
            WHEN EXISTS (SELECT 1 FROM character_quotes q WHERE q.character_id = c.id AND q.body LIKE ?1 $_e) THEN 'quote'
            ELSE 'body'
          END AS matched_in
        FROM characters c LEFT JOIN projects p ON p.id = c.project_id
        WHERE c.user_id = ?2 AND c.deleted_at IS NULL AND (c.project_id IS NULL OR p.deleted_at IS NULL) AND (
          c.name LIKE ?1 $_e OR c.name_en LIKE ?1 $_e OR c.tagline LIKE ?1 $_e OR c.quote LIKE ?1 $_e OR c.body_md LIKE ?1 $_e
          OR EXISTS (SELECT 1 FROM character_tags ct JOIN tags t ON t.id = ct.tag_id WHERE ct.character_id = c.id AND t.name LIKE ?1 $_e)
          OR EXISTS (SELECT 1 FROM character_fields f WHERE f.character_id = c.id AND (f.label LIKE ?1 $_e OR f.value LIKE ?1 $_e))
          OR EXISTS (SELECT 1 FROM character_quotes q WHERE q.character_id = c.id AND q.body LIKE ?1 $_e))
        ORDER BY (c.name LIKE ?1 $_e) DESC, c.updated_at DESC LIMIT 50''', [like, userId]);
    final worlds = db.rows('''
        SELECT id, name, summary FROM worlds
        WHERE user_id = ?2 AND deleted_at IS NULL AND (name LIKE ?1 $_e OR summary LIKE ?1 $_e OR body_md LIKE ?1 $_e)
        ORDER BY (name LIKE ?1 $_e) DESC, updated_at DESC LIMIT 20''', [like, userId]);
    final projects = db.rows('''
        SELECT id, name, kind, summary FROM projects
        WHERE user_id = ?2 AND deleted_at IS NULL AND (name LIKE ?1 $_e OR summary LIKE ?1 $_e OR body_md LIKE ?1 $_e)
        ORDER BY (name LIKE ?1 $_e) DESC, updated_at DESC LIMIT 20''', [like, userId]);
    return {'characters': characters, 'worlds': worlds, 'projects': projects};
  }
}
