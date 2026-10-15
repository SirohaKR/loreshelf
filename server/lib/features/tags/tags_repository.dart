// 태그 DB (tags, character_tags).
import '../../core/db.dart';

class TagsRepository {
  final Db db;
  TagsRepository(this.db);

  /// 태그 이름 정리: 앞의 # 떼고, 공백 정리. 빈 이름은 null.
  static String? clean(Object? name) {
    final s = (name ?? '').toString().trim().replaceFirst(RegExp(r'^#+'), '').trim();
    return s.isEmpty || s.length > 40 ? null : s;
  }

  /// 내 태그 목록 + 몇 번 쓰였는지 (자동완성용).
  List<Row> list(int userId) => db.rows('''
      SELECT t.id, t.name, t.color, COUNT(ct.id) AS character_count
      FROM tags t LEFT JOIN character_tags ct ON ct.tag_id = t.id
      WHERE t.user_id = ? GROUP BY t.id ORDER BY character_count DESC, t.name''', [userId]);

  /// 이름으로 태그 찾기, 없으면 만들기.
  int ensure(int userId, String name) {
    db.exec('INSERT INTO tags (user_id, name) VALUES (?, ?) ON CONFLICT (user_id, name) DO NOTHING', [userId, name]);
    return db.scalar('SELECT id FROM tags WHERE user_id = ? AND name = ?', [userId, name]) as int;
  }

  List<String> namesForCharacter(int characterId) => db
      .rows('SELECT t.name FROM character_tags ct JOIN tags t ON t.id = ct.tag_id WHERE ct.character_id = ? ORDER BY t.name', [characterId])
      .map((r) => r['name'] as String)
      .toList();

  /// 캐릭터 태그를 이 목록으로 바꾸기.
  void setForCharacter(int userId, int characterId, Iterable<Object?> names) {
    db.exec('DELETE FROM character_tags WHERE character_id = ?', [characterId]);
    for (final name in names.map(clean).whereType<String>().toSet()) {
      db.exec('INSERT INTO character_tags (character_id, tag_id) VALUES (?, ?)', [characterId, ensure(userId, name)]);
    }
  }

  /// 어디에도 안 쓰이는 태그 지우기.
  void deleteUnused(int userId) => db.exec('''
      DELETE FROM tags WHERE user_id = ?
        AND id NOT IN (SELECT tag_id FROM character_tags)
        AND id NOT IN (SELECT tag_id FROM memo_tags)
        AND id NOT IN (SELECT tag_id FROM board_card_tags)''', [userId]);
}
