// 챗봇 설정 DB (chatbot_stories + 카드 chatbot_nodes + 선 chatbot_node_links).
// 작품이 내 것인지는 여기서 확인하고, 카드·선은 작품을 거쳐서 내 것인지 안다 (딸린 테이블엔 user_id 없음).
// content_json 모양 검사는 shared의 normalizeNodeContent (routes에서).
import 'dart:convert';

import '../../core/db.dart';
import '../../core/http.dart';

class ChatbotRepository {
  final Db db;
  ChatbotRepository(this.db);

  static const storyColumns = ['main_character_id', 'project_id', 'title', 'edit_mode', 'target_platforms_json', 'sort_order'];
  static const nodeColumns = [
    'kind', 'title', 'source_character_id', 'chatbot_status_view_id', 'content_json', 'is_enabled', 'position_x', 'position_y', 'sort_order',
  ];

  // ───── 작품 ─────

  /// 작품 목록 (대표 캐릭터 이름·카드 수 포함). [characterId]면 그 캐릭터가 대표인 것만.
  List<Row> stories(int userId, {int? characterId}) {
    final rows = db.rows('''
        SELECT s.id, s.main_character_id, c.name AS main_character_name, s.project_id, s.title, s.edit_mode,
          s.target_platforms_json, s.sort_order, s.updated_at,
          (SELECT COUNT(*) FROM chatbot_nodes n WHERE n.chatbot_story_id = s.id) AS node_count
        FROM chatbot_stories s LEFT JOIN characters c ON c.id = s.main_character_id
        WHERE s.user_id = ? AND s.deleted_at IS NULL ${characterId == null ? '' : 'AND s.main_character_id = ?'}
        ORDER BY s.sort_order, s.updated_at DESC''', [userId, ?characterId]);
    return [for (final r in rows) _decodeStory(r)];
  }

  Row story(int userId, int id) {
    final r = db.one('SELECT * FROM chatbot_stories WHERE id = ? AND user_id = ? AND deleted_at IS NULL', [id, userId]) ??
        (throw ApiError('챗봇 작품을 찾을 수 없어요', 404));
    return _decodeStory(r);
  }

  /// 작품 + 카드 전부 + 선 전부 (편집 화면 한 번에)
  Row storyDetail(int userId, int id) => {
        ...story(userId, id),
        'nodes': [
          for (final n in db.rows('SELECT * FROM chatbot_nodes WHERE chatbot_story_id = ? ORDER BY sort_order, id', [id])) _decodeNode(n),
        ],
        'links': db.rows('''
            SELECT l.* FROM chatbot_node_links l JOIN chatbot_nodes n ON n.id = l.from_chatbot_node_id
            WHERE n.chatbot_story_id = ? ORDER BY l.id''', [id]),
      };

  int createStory(int userId, Map<String, Object?> v) => db.insert(
      'INSERT INTO chatbot_stories (user_id, ${storyColumns.join(', ')}) VALUES (?, ${List.filled(storyColumns.length, '?').join(', ')})',
      [userId, ...storyColumns.map((c) => v[c])]);

  void updateStory(int userId, int id, Map<String, Object?> v) {
    story(userId, id);
    db.exec('UPDATE chatbot_stories SET ${storyColumns.map((c) => '$c = ?').join(', ')}, updated_at = ? WHERE id = ?',
        [...storyColumns.map((c) => v[c]), nowAt(), id]);
  }

  void softDeleteStory(int userId, int id) {
    story(userId, id);
    db.exec('UPDATE chatbot_stories SET deleted_at = ? WHERE id = ?', [nowAt(), id]);
  }

  /// 카드·선이 바뀌면 작품의 updated_at도 (목록의 "최근 수정" 순서)
  void _touchStory(int storyId) => db.exec('UPDATE chatbot_stories SET updated_at = ? WHERE id = ?', [nowAt(), storyId]);

  // ───── 카드 ─────

  /// 내 작품의 카드 (휴지통에 간 작품의 카드는 못 찾음)
  Row node(int userId, int id) {
    final r = db.one('''
        SELECT n.* FROM chatbot_nodes n JOIN chatbot_stories s ON s.id = n.chatbot_story_id
        WHERE n.id = ? AND s.user_id = ? AND s.deleted_at IS NULL''', [id, userId]);
    return _decodeNode(r ?? (throw ApiError('카드를 찾을 수 없어요', 404)));
  }

  int createNode(int storyId, Map<String, Object?> v) {
    final id = db.insert(
        'INSERT INTO chatbot_nodes (chatbot_story_id, ${nodeColumns.join(', ')}) VALUES (?, ${List.filled(nodeColumns.length, '?').join(', ')})',
        [storyId, ...nodeColumns.map((c) => v[c])]);
    _touchStory(storyId);
    return id;
  }

  void updateNode(int userId, int id, Map<String, Object?> v) {
    final storyId = node(userId, id)['chatbot_story_id'] as int;
    db.exec('UPDATE chatbot_nodes SET ${nodeColumns.map((c) => '$c = ?').join(', ')}, updated_at = ? WHERE id = ?',
        [...nodeColumns.map((c) => v[c]), nowAt(), id]);
    _touchStory(storyId);
  }

  /// 카드를 지우면 이어진 선도 같이 지워진다 (ON DELETE CASCADE)
  void deleteNode(int userId, int id) {
    final storyId = node(userId, id)['chatbot_story_id'] as int;
    db.exec('DELETE FROM chatbot_nodes WHERE id = ?', [id]);
    _touchStory(storyId);
  }

  // ───── 선 ─────

  Row link(int userId, int id) =>
      db.one('''
          SELECT l.*, n.chatbot_story_id FROM chatbot_node_links l
          JOIN chatbot_nodes n ON n.id = l.from_chatbot_node_id JOIN chatbot_stories s ON s.id = n.chatbot_story_id
          WHERE l.id = ? AND s.user_id = ? AND s.deleted_at IS NULL''', [id, userId]) ??
      (throw ApiError('연결선을 찾을 수 없어요', 404));

  /// 같은 작품의 두 카드를 잇는다. 이미 이어져 있으면 그 선을 돌려준다.
  int createLink(int storyId, int fromNodeId, int toNodeId) {
    if (fromNodeId == toNodeId) throw ApiError('카드를 자기 자신과 이을 수 없어요');
    final same = db.scalar('SELECT COUNT(*) FROM chatbot_nodes WHERE id IN (?, ?) AND chatbot_story_id = ?', [fromNodeId, toNodeId, storyId]);
    if (same != 2) throw ApiError('같은 작품의 카드끼리만 이을 수 있어요', 404);
    final existing = db.scalar('SELECT id FROM chatbot_node_links WHERE from_chatbot_node_id = ? AND to_chatbot_node_id = ?', [fromNodeId, toNodeId]);
    if (existing != null) return existing as int;
    final id = db.insert('INSERT INTO chatbot_node_links (from_chatbot_node_id, to_chatbot_node_id) VALUES (?, ?)', [fromNodeId, toNodeId]);
    _touchStory(storyId);
    return id;
  }

  void deleteLink(int userId, int id) {
    final storyId = link(userId, id)['chatbot_story_id'] as int;
    db.exec('DELETE FROM chatbot_node_links WHERE id = ?', [id]);
    _touchStory(storyId);
  }

  // ───── 행 → 응답 ─────

  static Row _decodeStory(Row r) => {...r, 'target_platforms': jsonDecode(r['target_platforms_json'] as String)};
  static Row _decodeNode(Row r) => {...r, 'content': jsonDecode(r['content_json'] as String)};
}
