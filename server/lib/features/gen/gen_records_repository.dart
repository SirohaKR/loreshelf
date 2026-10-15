// 캐릭터별 고정 프롬프트(gen_presets + gen_preset_loras)와 생성 기록(gen_records + gen_record_loras) DB.
// 캐릭터가 내 것인지는 routes에서 ownedId로 먼저 확인한다.
import 'dart:convert';

import '../../core/db.dart';
import '../../core/http.dart';

const recordColumns = [
  'asset_id', 'gen_platform_id', 'gen_model_id', 'gen_preset_id', 'title', 'prompt_raw', 'tags_json', 'negative_json', //
  'seed', 'sampler', 'steps', 'cfg_scale', 'width', 'height', 'extra_json', 'note', 'is_cover',
];

/// LoRA 한 줄: 목록에 있으면 gen_lora_id, 없으면 이름만
typedef LoraUse = ({int? loraId, String name, double weight});

class GenRecordsRepository {
  final Db db;
  GenRecordsRepository(this.db);

  // ───── 고정 프롬프트 ─────

  List<Row> presets(int characterId) {
    final list = db.rows('SELECT * FROM gen_presets WHERE character_id = ? ORDER BY sort_order, id', [characterId]);
    return [for (final p in list) _decodePreset(p)];
  }

  Row preset(int userId, int id) {
    final p = db.one('''SELECT gp.* FROM gen_presets gp JOIN characters c ON c.id = gp.character_id
        WHERE gp.id = ? AND c.user_id = ? AND c.deleted_at IS NULL''', [id, userId]);
    if (p == null) throw ApiError('고정 프롬프트를 찾을 수 없어요', 404);
    return _decodePreset(p);
  }

  Row _decodePreset(Row p) => {
        ...p,
        'tags': jsonDecode(p['tags_json'] as String),
        'negative': jsonDecode(p['negative_json'] as String),
        'loras': db.rows('''
            SELECT pl.gen_lora_id, l.name, pl.weight, l.trigger_words FROM gen_preset_loras pl
            JOIN gen_loras l ON l.id = pl.gen_lora_id WHERE pl.gen_preset_id = ? ORDER BY l.name''', [p['id']]),
      }
        ..remove('tags_json')
        ..remove('negative_json');

  int addPreset(int characterId, {required String name, required String tagsJson, required String negativeJson, required List<LoraUse> loras}) =>
      db.tx(() {
        final id = db.insert('''INSERT INTO gen_presets (character_id, name, tags_json, negative_json, sort_order)
            VALUES (?, ?, ?, ?, (SELECT COALESCE(MAX(sort_order), -1) + 1 FROM gen_presets WHERE character_id = ?))''',
            [characterId, name, tagsJson, negativeJson, characterId]);
        _setPresetLoras(id, loras);
        return id;
      });

  void updatePreset(int id, {String? name, String? tagsJson, String? negativeJson, List<LoraUse>? loras}) => db.tx(() {
        db.exec('''UPDATE gen_presets SET name = COALESCE(?, name), tags_json = COALESCE(?, tags_json),
            negative_json = COALESCE(?, negative_json), updated_at = ? WHERE id = ?''', [name, tagsJson, negativeJson, nowAt(), id]);
        if (loras != null) _setPresetLoras(id, loras);
      });

  // 고정 프롬프트의 LoRA는 목록에 있는 것만 (gen_lora_id 필수)
  void _setPresetLoras(int presetId, List<LoraUse> loras) {
    db.exec('DELETE FROM gen_preset_loras WHERE gen_preset_id = ?', [presetId]);
    for (final l in loras) {
      if (l.loraId == null) continue;
      db.exec('''INSERT INTO gen_preset_loras (gen_preset_id, gen_lora_id, weight) VALUES (?, ?, ?)
          ON CONFLICT (gen_preset_id, gen_lora_id) DO UPDATE SET weight = excluded.weight''', [presetId, l.loraId, l.weight]);
    }
  }

  void deletePreset(int id) => db.exec('DELETE FROM gen_presets WHERE id = ?', [id]);

  // ───── 생성 기록 ─────

  static const _recordSelect = '''
      SELECT r.*, p.name AS platform_name, m.name AS model_name, gp.name AS preset_name, c.user_id
      FROM gen_records r
      JOIN characters c ON c.id = r.character_id
      LEFT JOIN gen_platforms p ON p.id = r.gen_platform_id
      LEFT JOIN gen_models m ON m.id = r.gen_model_id
      LEFT JOIN gen_presets gp ON gp.id = r.gen_preset_id''';

  /// ★대표가 먼저, 그다음 최근 것부터
  List<Row> records(int characterId) {
    final list = db.rows('$_recordSelect WHERE r.character_id = ? AND r.deleted_at IS NULL ORDER BY r.is_cover DESC, r.created_at DESC, r.id DESC',
        [characterId]);
    return [for (final r in list) _decodeRecord(r)];
  }

  Row record(int userId, int id) {
    final r = db.one('$_recordSelect WHERE r.id = ? AND c.user_id = ? AND c.deleted_at IS NULL AND r.deleted_at IS NULL', [id, userId]);
    if (r == null) throw ApiError('생성 기록을 찾을 수 없어요', 404);
    return _decodeRecord(r);
  }

  Row _decodeRecord(Row r) => {
        ...r,
        'tags': jsonDecode(r['tags_json'] as String),
        'negative': jsonDecode(r['negative_json'] as String),
        'extra': jsonDecode(r['extra_json'] as String),
        'loras': db.rows('SELECT gen_lora_id, lora_name AS name, weight FROM gen_record_loras WHERE gen_record_id = ? ORDER BY id', [r['id']]),
      }
        ..remove('tags_json')
        ..remove('negative_json')
        ..remove('extra_json')
        ..remove('user_id');

  int addRecord(int characterId, Map<String, Object?> v, List<LoraUse> loras) => db.tx(() {
        final cols = recordColumns.where(v.containsKey).toList();
        final id = db.insert(
            'INSERT INTO gen_records (character_id, ${cols.join(', ')}) VALUES (?, ${cols.map((_) => '?').join(', ')})',
            [characterId, for (final c in cols) v[c]]);
        _setRecordLoras(id, loras);
        if (v['is_cover'] == 1) _onlyCover(characterId, id);
        return id;
      });

  void updateRecord(int characterId, int id, Map<String, Object?> v, List<LoraUse>? loras) => db.tx(() {
        final cols = recordColumns.where(v.containsKey).toList();
        db.exec('UPDATE gen_records SET ${[...cols.map((c) => '$c = ?'), 'updated_at = ?'].join(', ')} WHERE id = ?',
            [for (final c in cols) v[c], nowAt(), id]);
        if (loras != null) _setRecordLoras(id, loras);
        if (v['is_cover'] == 1) _onlyCover(characterId, id);
      });

  void _setRecordLoras(int recordId, List<LoraUse> loras) {
    db.exec('DELETE FROM gen_record_loras WHERE gen_record_id = ?', [recordId]);
    for (final l in loras) {
      db.exec('INSERT INTO gen_record_loras (gen_record_id, gen_lora_id, lora_name, weight) VALUES (?, ?, ?, ?)',
          [recordId, l.loraId, l.name, l.weight]);
    }
  }

  // ★대표는 캐릭터마다 하나
  void _onlyCover(int characterId, int keepId) =>
      db.exec('UPDATE gen_records SET is_cover = 0 WHERE character_id = ? AND id <> ? AND is_cover = 1', [characterId, keepId]);

  /// 생성 기록은 바로 지운다 (휴지통 대상 아님. 연결된 이미지 파일은 남는다)
  void deleteRecord(int id) => db.exec('DELETE FROM gen_records WHERE id = ?', [id]);
}
