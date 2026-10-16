// 생성 도구 목록 DB — 플랫폼(gen_platforms) · 모델(gen_models) · LoRA(gen_loras) · 내 분류 사전(gen_tag_rules).
import '../../core/db.dart';
import '../../core/http.dart';

/// 처음 목록을 열 때 넣어 주는 기본 플랫폼 (지우거나 이름을 바꿔도 된다)
const defaultPlatforms = ['NovelAI', 'Stable Diffusion WebUI', 'ComfyUI', 'Midjourney'];

const loraColumns = ['name', 'file_name', 'base_model', 'trigger_words', 'default_weight', 'sha256', 'source_url', 'civitai_version_id', 'note'];
const modelColumns = ['name', 'base_model', 'file_name', 'sha256', 'source_url', 'note'];

class GenCatalogRepository {
  final Db db;
  GenCatalogRepository(this.db);

  // ───── 플랫폼 · 모델 ─────

  /// 플랫폼마다 모델 목록을 붙여서. 아직 하나도 없으면 기본 플랫폼을 만들어 둔다.
  List<Row> platforms(int userId) {
    if (db.scalar('SELECT 1 FROM gen_platforms WHERE user_id = ?', [userId]) == null) {
      db.tx(() {
        for (final (i, name) in defaultPlatforms.indexed) {
          db.exec('INSERT INTO gen_platforms (user_id, name, sort_order) VALUES (?, ?, ?)', [userId, name, i]);
        }
      });
    }
    final list = db.rows('SELECT id, name, sort_order FROM gen_platforms WHERE user_id = ? ORDER BY sort_order, id', [userId]);
    final models = db.rows('''
        SELECT m.* FROM gen_models m JOIN gen_platforms p ON p.id = m.gen_platform_id
        WHERE p.user_id = ? ORDER BY m.sort_order, m.name''', [userId]);
    return [
      for (final p in list) {...p, 'models': models.where((m) => m['gen_platform_id'] == p['id']).toList()},
    ];
  }

  Row platform(int userId, int id) =>
      db.one('SELECT id, name, sort_order FROM gen_platforms WHERE id = ? AND user_id = ?', [id, userId]) ??
      (throw ApiError('플랫폼을 찾을 수 없어요', 404));

  int? platformIdByName(int userId, String name) =>
      db.scalar('SELECT id FROM gen_platforms WHERE user_id = ? AND name = ? COLLATE NOCASE', [userId, name]) as int?;

  int addPlatform(int userId, String name) {
    final existing = platformIdByName(userId, name);
    if (existing != null) return existing;
    return db.insert('''INSERT INTO gen_platforms (user_id, name, sort_order)
        VALUES (?, ?, (SELECT COALESCE(MAX(sort_order), -1) + 1 FROM gen_platforms WHERE user_id = ?))''', [userId, name, userId]);
  }

  void renamePlatform(int userId, int id, String name) {
    platform(userId, id);
    final other = platformIdByName(userId, name);
    if (other != null && other != id) throw ApiError('같은 이름의 플랫폼이 있어요', 409);
    db.exec('UPDATE gen_platforms SET name = ? WHERE id = ?', [name, id]);
  }

  /// 지우면 그 플랫폼의 모델도 같이 지워지고, 생성 기록에서는 "플랫폼 없음"이 된다.
  void deletePlatform(int userId, int id) {
    if (db.exec('DELETE FROM gen_platforms WHERE id = ? AND user_id = ?', [id, userId]) == 0) {
      throw ApiError('플랫폼을 찾을 수 없어요', 404);
    }
  }

  Row model(int userId, int id) =>
      db.one('''SELECT m.* FROM gen_models m JOIN gen_platforms p ON p.id = m.gen_platform_id
          WHERE m.id = ? AND p.user_id = ?''', [id, userId]) ??
      (throw ApiError('모델을 찾을 수 없어요', 404));

  int? modelIdByName(int platformId, String name) =>
      db.scalar('SELECT id FROM gen_models WHERE gen_platform_id = ? AND name = ? COLLATE NOCASE', [platformId, name]) as int?;

  int addModel(int platformId, Map<String, Object?> v) {
    final existing = modelIdByName(platformId, v['name'] as String);
    if (existing != null) return existing;
    final cols = modelColumns.where(v.containsKey).toList();
    return db.insert(
        'INSERT INTO gen_models (gen_platform_id, ${cols.join(', ')}) VALUES (?, ${cols.map((_) => '?').join(', ')})',
        [platformId, for (final c in cols) v[c]]);
  }

  void updateModel(int userId, int id, Map<String, Object?> v) {
    final m = model(userId, id);
    if (v['name'] != null) {
      final other = modelIdByName(m['gen_platform_id'] as int, v['name'] as String);
      if (other != null && other != id) throw ApiError('같은 이름의 모델이 있어요', 409);
    }
    final cols = modelColumns.where(v.containsKey).toList();
    if (cols.isEmpty) return;
    db.exec('UPDATE gen_models SET ${cols.map((c) => '$c = ?').join(', ')} WHERE id = ?', [for (final c in cols) v[c], id]);
  }

  void deleteModel(int userId, int id) {
    model(userId, id);
    db.exec('DELETE FROM gen_models WHERE id = ?', [id]);
  }

  // ───── LoRA ─────

  /// 몇 번 썼는지(생성 기록 수) 포함
  List<Row> loras(int userId) => db.rows('''
      SELECT l.*, (SELECT COUNT(*) FROM gen_record_loras rl WHERE rl.gen_lora_id = l.id) AS use_count
      FROM gen_loras l WHERE l.user_id = ? ORDER BY l.name COLLATE NOCASE''', [userId]);

  Row lora(int userId, int id) =>
      db.one('SELECT * FROM gen_loras WHERE id = ? AND user_id = ?', [id, userId]) ?? (throw ApiError('LoRA를 찾을 수 없어요', 404));

  int? loraIdByName(int userId, String name) =>
      db.scalar('SELECT id FROM gen_loras WHERE user_id = ? AND name = ? COLLATE NOCASE', [userId, name]) as int?;

  int addLora(int userId, Map<String, Object?> v) {
    if (loraIdByName(userId, v['name'] as String) != null) throw ApiError('같은 이름의 LoRA가 있어요', 409);
    final cols = loraColumns.where(v.containsKey).toList();
    return db.insert('INSERT INTO gen_loras (user_id, ${cols.join(', ')}) VALUES (?, ${cols.map((_) => '?').join(', ')})',
        [userId, for (final c in cols) v[c]]);
  }

  void updateLora(int userId, int id, Map<String, Object?> v) {
    lora(userId, id);
    if (v['name'] != null) {
      final other = loraIdByName(userId, v['name'] as String);
      if (other != null && other != id) throw ApiError('같은 이름의 LoRA가 있어요', 409);
    }
    final cols = loraColumns.where(v.containsKey).toList();
    if (cols.isEmpty) return;
    db.exec('UPDATE gen_loras SET ${cols.map((c) => '$c = ?').join(', ')}, updated_at = ? WHERE id = ?',
        [for (final c in cols) v[c], nowAt(), id]);
  }

  /// 지워도 생성 기록에는 LoRA 이름이 남는다 (gen_record_loras.lora_name)
  void deleteLora(int userId, int id) {
    lora(userId, id);
    db.exec('DELETE FROM gen_loras WHERE id = ?', [id]);
  }

  // ───── 내 분류 사전 ─────

  List<Row> tagRules(int userId) =>
      db.rows('SELECT id, tag, category, created_at FROM gen_tag_rules WHERE user_id = ? ORDER BY category, tag', [userId]);

  /// 분류기에 넘길 {태그: 카테고리}
  Map<String, String> learnedMap(int userId) => {
        for (final r in db.rows('SELECT tag, category FROM gen_tag_rules WHERE user_id = ?', [userId]))
          r['tag'] as String: r['category'] as String,
      };

  /// 같은 태그가 있으면 카테고리만 바꾼다
  Row learn(int userId, String tag, String category) {
    db.exec('''INSERT INTO gen_tag_rules (user_id, tag, category) VALUES (?, ?, ?)
        ON CONFLICT (user_id, tag) DO UPDATE SET category = excluded.category''', [userId, tag, category]);
    return db.one('SELECT id, tag, category, created_at FROM gen_tag_rules WHERE user_id = ? AND tag = ?', [userId, tag])!;
  }

  void forget(int userId, int id) {
    if (db.exec('DELETE FROM gen_tag_rules WHERE id = ? AND user_id = ?', [id, userId]) == 0) {
      throw ApiError('사전에 없는 태그예요', 404);
    }
  }
}

/// 내가 만든 네거티브 세트 (gen_negative_sets). 기본 세트는 shared 패키지의 defaultNegativeSets.
class GenNegativeSetsRepository {
  final Db db;
  GenNegativeSetsRepository(this.db);

  List<Row> list(int userId) =>
      db.rows('SELECT id, name, negative_json, sort_order FROM gen_negative_sets WHERE user_id = ? ORDER BY sort_order, id', [userId]);

  Row one(int userId, int id) =>
      db.one('SELECT id, name, negative_json, sort_order FROM gen_negative_sets WHERE id = ? AND user_id = ?', [id, userId]) ??
      (throw ApiError('네거티브 세트를 찾을 수 없어요', 404));

  int add(int userId, String name, String negativeJson) => db.insert('''INSERT INTO gen_negative_sets (user_id, name, negative_json, sort_order)
      VALUES (?, ?, ?, (SELECT COALESCE(MAX(sort_order), -1) + 1 FROM gen_negative_sets WHERE user_id = ?))''', [userId, name, negativeJson, userId]);

  void update(int userId, int id, {String? name, String? negativeJson}) {
    one(userId, id);
    if (name != null) db.exec('UPDATE gen_negative_sets SET name = ? WHERE id = ?', [name, id]);
    if (negativeJson != null) db.exec('UPDATE gen_negative_sets SET negative_json = ? WHERE id = ?', [negativeJson, id]);
  }

  void delete(int userId, int id) {
    if (db.exec('DELETE FROM gen_negative_sets WHERE id = ? AND user_id = ?', [id, userId]) == 0) {
      throw ApiError('네거티브 세트를 찾을 수 없어요', 404);
    }
  }
}
