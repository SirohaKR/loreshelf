// 캐릭터 DB (characters + 딸린 테이블 character_fields / _traits / _quotes / _assets).
// 저장 위치: characters.project_id 가 있으면 그 프로젝트 전용, NULL이면 공용 서재.
import 'dart:convert';

import '../../core/db.dart';
import '../../core/http.dart';
import '../tags/tags_repository.dart';

class CharactersRepository {
  final Db db;
  final TagsRepository tags;
  CharactersRepository(this.db) : tags = TagsRepository(db);

  /// 저장할 때 쓰는 칸 (화면 값 검사는 routes에서).
  static const columns = [
    'world_id', 'project_id', 'character_template_id', 'name', 'name_en', 'tagline', 'quote', 'theme_color',
    'portrait_asset_id', 'body_md', 'visibility', 'is_card_downloadable', 'is_favorite', 'sort_order',
  ];

  // 목록에 보일 칸. 휴지통에 있는 프로젝트의 전용 캐릭터는 같이 숨긴다.
  static const _listSelect = '''
      SELECT c.id, c.name, c.name_en, c.tagline, c.theme_color, c.portrait_asset_id, c.visibility, c.is_favorite,
        c.world_id, w.name AS world_name, c.project_id, p.name AS project_name, c.source_character_id, c.sort_order, c.updated_at,
        (SELECT json_group_array(t.name) FROM character_tags ct JOIN tags t ON t.id = ct.tag_id WHERE ct.character_id = c.id) AS tags_json
      FROM characters c
        LEFT JOIN projects p ON p.id = c.project_id
        LEFT JOIN worlds w ON w.id = c.world_id
      WHERE c.user_id = ? AND c.deleted_at IS NULL AND (c.project_id IS NULL OR p.deleted_at IS NULL)''';

  static Row _withTags(Row r) {
    final out = Map<String, Object?>.from(r);
    final raw = out.remove('tags_json') as String?;
    out['tags'] = raw == null ? <String>[] : (jsonDecode(raw) as List).cast<String>()..sort();
    return out;
  }

  /// 캐릭터 목록.
  /// [scope]: 'all' 전체, 'library' 공용 서재만. [projectId]: 그 프로젝트의 전용 + 연결 캐릭터.
  /// [recent]: true면 최근 수정 순, 아니면 정렬 순서·이름 순.
  List<Row> list(int userId,
      {String scope = 'all', int? projectId, int? worldId, String? tag, String? query, bool favoriteOnly = false, bool recent = false, int? limit}) {
    final where = <String>[], args = <Object?>[userId];
    var select = _listSelect;
    if (projectId != null) {
      // 전용이면 own, 연결이면 linked + 역할
      select = select.replaceFirst('c.updated_at,', '''c.updated_at,
        CASE WHEN c.project_id = ? THEN 'own' ELSE 'linked' END AS membership,
        (SELECT pc.role FROM project_characters pc WHERE pc.project_id = ? AND pc.character_id = c.id) AS role,''');
      args.insertAll(0, [projectId, projectId]); // 위 SELECT 칸의 ? 두 개가 WHERE보다 앞에 온다
      where.add('(c.project_id = ? OR c.id IN (SELECT character_id FROM project_characters WHERE project_id = ?))');
      args.addAll([projectId, projectId]);
    }
    if (scope == 'library') where.add('c.project_id IS NULL');
    if (worldId != null) {
      where.add('c.world_id = ?');
      args.add(worldId);
    }
    if (tag != null) {
      where.add('c.id IN (SELECT ct.character_id FROM character_tags ct JOIN tags t ON t.id = ct.tag_id WHERE t.user_id = ? AND t.name = ?)');
      args.addAll([userId, tag]);
    }
    if (query != null) {
      where.add("(c.name LIKE ? ESCAPE '\\' OR c.name_en LIKE ? ESCAPE '\\' OR c.tagline LIKE ? ESCAPE '\\')");
      final like = likePattern(query);
      args.addAll([like, like, like]);
    }
    if (favoriteOnly) where.add('c.is_favorite = 1');
    final sql = StringBuffer(select);
    for (final w in where) {
      sql.write(' AND $w');
    }
    sql.write(recent ? ' ORDER BY c.updated_at DESC, c.id DESC' : ' ORDER BY c.is_favorite DESC, c.sort_order, c.name');
    if (limit != null) sql.write(' LIMIT $limit');
    return db.rows(sql.toString(), args).map(_withTags).toList();
  }

  /// 캐릭터 한 명 (기본 칸만). 없거나 남의 것이면 오류.
  Row get(int userId, int id) =>
      db.one('''
        SELECT c.*, p.name AS project_name, p.kind AS project_kind, w.name AS world_name, s.name AS source_character_name
        FROM characters c
          LEFT JOIN projects p ON p.id = c.project_id
          LEFT JOIN worlds w ON w.id = c.world_id
          LEFT JOIN characters s ON s.id = c.source_character_id
        WHERE c.id = ? AND c.user_id = ? AND c.deleted_at IS NULL''', [id, userId]) ??
      (throw ApiError('캐릭터를 찾을 수 없어요', 404));

  /// 상세 화면용: 기본 칸 + 딸린 것 전부.
  Map<String, Object?> detail(int userId, int id) => {
        ...get(userId, id),
        'fields': db.rows('SELECT id, label, value, is_secret FROM character_fields WHERE character_id = ? ORDER BY sort_order, id', [id]),
        'traits': db.rows('SELECT id, left_label, right_label, value_percent FROM character_traits WHERE character_id = ? ORDER BY sort_order, id', [id]),
        'quotes': db.rows('SELECT id, body, situation, is_secret FROM character_quotes WHERE character_id = ? ORDER BY sort_order, id', [id]),
        'tags': tags.namesForCharacter(id),
        'gallery': db.rows('''
            SELECT a.id, a.width, a.height, a.caption, a.original_name FROM character_assets ca JOIN assets a ON a.id = ca.asset_id
            WHERE ca.character_id = ? AND a.deleted_at IS NULL ORDER BY ca.sort_order, ca.id''', [id]),
      };

  int create(int userId, Map<String, Object?> v) => db.insert(
      'INSERT INTO characters (user_id, ${columns.join(', ')}) VALUES (?, ${List.filled(columns.length, '?').join(', ')})',
      [userId, ...columns.map((c) => v[c])]);

  void update(int userId, int id, Map<String, Object?> v) {
    get(userId, id);
    db.exec('UPDATE characters SET ${columns.map((c) => '$c = ?').join(', ')}, updated_at = ? WHERE id = ?',
        [...columns.map((c) => v[c]), nowAt(), id]);
    // 전용이 된 프로젝트의 "연결" 줄은 필요 없다
    if (v['project_id'] != null) db.exec('DELETE FROM project_characters WHERE project_id = ? AND character_id = ?', [v['project_id'], id]);
  }

  void touch(int id) => db.exec('UPDATE characters SET updated_at = ? WHERE id = ?', [nowAt(), id]);

  /// 딸린 칸들을 이 목록으로 바꾸기 (순서 = 목록 순서).
  void replaceChildren(int userId, int id, {
    required List<Map<String, Object?>> fields,
    required List<Map<String, Object?>> traits,
    required List<Map<String, Object?>> quotes,
    required List<Object?> tagNames,
  }) {
    db.exec('DELETE FROM character_fields WHERE character_id = ?', [id]);
    for (final (i, f) in fields.indexed) {
      db.exec('INSERT INTO character_fields (character_id, label, value, is_secret, sort_order) VALUES (?, ?, ?, ?, ?)',
          [id, f['label'], f['value'], f['is_secret'], i]);
    }
    db.exec('DELETE FROM character_traits WHERE character_id = ?', [id]);
    for (final (i, t) in traits.indexed) {
      db.exec('INSERT INTO character_traits (character_id, left_label, right_label, value_percent, sort_order) VALUES (?, ?, ?, ?, ?)',
          [id, t['left_label'], t['right_label'], t['value_percent'], i]);
    }
    db.exec('DELETE FROM character_quotes WHERE character_id = ?', [id]);
    for (final (i, q) in quotes.indexed) {
      db.exec('INSERT INTO character_quotes (character_id, body, situation, is_secret, sort_order) VALUES (?, ?, ?, ?, ?)',
          [id, q['body'], q['situation'], q['is_secret'], i]);
    }
    tags.setForCharacter(userId, id, tagNames);
    tags.deleteUnused(userId);
  }

  void setFavorite(int userId, int id, int flag) {
    get(userId, id);
    db.exec('UPDATE characters SET is_favorite = ? WHERE id = ?', [flag, id]);
  }

  /// 저장 위치 옮기기: projectId가 null이면 서재로 꺼내기, 아니면 그 프로젝트 전용으로.
  void move(int userId, int id, int? projectId) {
    get(userId, id);
    db.tx(() {
      db.exec('UPDATE characters SET project_id = ?, updated_at = ? WHERE id = ?', [projectId, nowAt(), id]);
      // 전용이 됐으면 같은 프로젝트의 "연결" 줄은 필요 없다
      if (projectId != null) db.exec('DELETE FROM project_characters WHERE project_id = ? AND character_id = ?', [projectId, id]);
    });
  }

  /// 분기: 캐릭터를 통째로 복사해서 projectId 전용으로. 원본 번호는 source_character_id에 남긴다.
  int fork(int userId, int id, int? projectId) => db.tx(() {
        get(userId, id);
        final copy = ['world_id', 'character_template_id', 'name', 'name_en', 'tagline', 'quote', 'theme_color',
            'portrait_asset_id', 'body_md', 'visibility', 'is_card_downloadable', 'sort_order'];
        final newId = db.insert('''
            INSERT INTO characters (user_id, project_id, source_character_id, ${copy.join(', ')})
            SELECT user_id, ?, id, ${copy.join(', ')} FROM characters WHERE id = ?''', [projectId, id]);
        db.exec('''INSERT INTO character_fields (character_id, label, value, is_secret, sort_order)
                   SELECT ?, label, value, is_secret, sort_order FROM character_fields WHERE character_id = ?''', [newId, id]);
        db.exec('''INSERT INTO character_traits (character_id, left_label, right_label, value_percent, sort_order)
                   SELECT ?, left_label, right_label, value_percent, sort_order FROM character_traits WHERE character_id = ?''', [newId, id]);
        db.exec('''INSERT INTO character_quotes (character_id, body, situation, is_secret, sort_order)
                   SELECT ?, body, situation, is_secret, sort_order FROM character_quotes WHERE character_id = ?''', [newId, id]);
        db.exec('INSERT INTO character_tags (character_id, tag_id) SELECT ?, tag_id FROM character_tags WHERE character_id = ?', [newId, id]);
        db.exec('''INSERT INTO character_assets (character_id, asset_id, sort_order)
                   SELECT ?, asset_id, sort_order FROM character_assets WHERE character_id = ?''', [newId, id]);
        return newId;
      });

  void softDelete(int userId, int id) {
    get(userId, id);
    db.exec('UPDATE characters SET deleted_at = ? WHERE id = ?', [nowAt(), id]);
  }

  /// 갤러리에 이미지 추가 (이미 있으면 그대로).
  void addAsset(int characterId, int assetId) => db.exec('''
      INSERT INTO character_assets (character_id, asset_id, sort_order)
      VALUES (?, ?, (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM character_assets WHERE character_id = ?))
      ON CONFLICT (character_id, asset_id) DO NOTHING''', [characterId, assetId, characterId]);

  void setPortrait(int characterId, int assetId) =>
      db.exec('UPDATE characters SET portrait_asset_id = ? WHERE id = ?', [assetId, characterId]);

  /// 대표 이미지가 이 파일이면 비우기 (갤러리에서 뺄 때).
  void clearPortraitIf(int characterId, int assetId) =>
      db.exec('UPDATE characters SET portrait_asset_id = NULL WHERE id = ? AND portrait_asset_id = ?', [characterId, assetId]);

  void removeAsset(int characterId, int assetId) =>
      db.exec('DELETE FROM character_assets WHERE character_id = ? AND asset_id = ?', [characterId, assetId]);
}

/// LIKE 검색어: %, _, \ 를 글자 그대로 찾게 바꾸고 앞뒤에 % (ESCAPE '\' 와 같이 쓴다).
String likePattern(String q) => '%${q.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}')}%';
