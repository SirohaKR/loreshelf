// 이미지·프롬프트 API (2단계)
// - 목록: 플랫폼·모델, LoRA, 내 분류 사전
// - 붙여넣은 프롬프트 자동 분류, 올린 PNG에서 생성 정보 읽기
// - 캐릭터별 고정 프롬프트(의상 프리셋)와 생성 기록
import 'dart:convert';
import 'dart:io';

import 'package:loreshelf_shared/loreshelf_shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/db.dart';
import '../../core/http.dart';
import '../../core/owned.dart';
import '../assets/assets_repository.dart';
import '../assets/assets_service.dart';
import '../settings/settings_repository.dart';
import 'gen_catalog_repository.dart';
import 'gen_records_repository.dart';

class GenRoutes {
  final Db db;
  final GenCatalogRepository catalog;
  final GenNegativeSetsRepository negativeSets;
  final SettingsRepository settings;
  final GenRecordsRepository records;
  final AssetsRepository assets;
  final AssetsService files;

  GenRoutes(AppContext app)
      : db = app.db,
        catalog = GenCatalogRepository(app.db),
        negativeSets = GenNegativeSetsRepository(app.db),
        settings = SettingsRepository(app.db),
        records = GenRecordsRepository(app.db),
        assets = AssetsRepository(app.db),
        files = AssetsService(app);

  void register(Router r) {
    // 플랫폼 · 모델
    r.get('/api/gen/platforms', (Request req) => json(catalog.platforms(req.ctx.user)));
    r.post('/api/gen/platforms', (Request req) async {
      final b = await body(req);
      final id = catalog.addPlatform(req.ctx.user, requireStr(b['name'], '플랫폼 이름', max: 60));
      return json(catalog.platform(req.ctx.user, id), status: 201);
    });
    r.put('/api/gen/platforms/<id>', (Request req, String id) async {
      final b = await body(req);
      catalog.renamePlatform(req.ctx.user, pathInt(id), requireStr(b['name'], '플랫폼 이름', max: 60));
      return json(catalog.platform(req.ctx.user, pathInt(id)));
    });
    r.delete('/api/gen/platforms/<id>', (Request req, String id) {
      catalog.deletePlatform(req.ctx.user, pathInt(id));
      return ok();
    });
    r.post('/api/gen/models', (Request req) async {
      final b = await body(req);
      final platformId = catalog.platform(req.ctx.user, toIntOrNull(b['gen_platform_id']) ?? -1)['id'] as int;
      final id = catalog.addModel(platformId, _modelValues(b, creating: true));
      return json(catalog.model(req.ctx.user, id), status: 201);
    });
    r.put('/api/gen/models/<id>', (Request req, String id) async {
      catalog.updateModel(req.ctx.user, pathInt(id), _modelValues(await body(req), creating: false));
      return json(catalog.model(req.ctx.user, pathInt(id)));
    });
    r.delete('/api/gen/models/<id>', (Request req, String id) {
      catalog.deleteModel(req.ctx.user, pathInt(id));
      return ok();
    });

    // LoRA
    r.get('/api/gen/loras', (Request req) => json(catalog.loras(req.ctx.user)));
    r.post('/api/gen/loras', (Request req) async {
      final id = catalog.addLora(req.ctx.user, _loraValues(await body(req), creating: true));
      return json(catalog.lora(req.ctx.user, id), status: 201);
    });
    r.put('/api/gen/loras/<id>', (Request req, String id) async {
      catalog.updateLora(req.ctx.user, pathInt(id), _loraValues(await body(req), creating: false));
      return json(catalog.lora(req.ctx.user, pathInt(id)));
    });
    r.delete('/api/gen/loras/<id>', (Request req, String id) {
      catalog.deleteLora(req.ctx.user, pathInt(id));
      return ok();
    });

    // 내 분류 사전 + 자동 분류
    r.get('/api/gen/tag-rules', (Request req) => json(catalog.tagRules(req.ctx.user)));
    r.post('/api/gen/tag-rules', (Request req) async {
      final b = await body(req);
      final tag = normalizeTag(requireStr(b['tag'], '태그', max: 200));
      final category = oneOf(b['category'], promptCategoryKeys, 'etc');
      return json(catalog.learn(req.ctx.user, tag, category), status: 201);
    });
    r.delete('/api/gen/tag-rules/<id>', (Request req, String id) {
      catalog.forget(req.ctx.user, pathInt(id));
      return ok();
    });
    // 모든 캐릭터 공통 기본값 (settings: gen_default_quality, gen_default_negative — JSON 문자열 배열).
    // 아직 저장한 적이 없으면 shared의 처음 기본값을 돌려준다.
    r.get('/api/gen/defaults', (Request req) => json(_defaults(req.ctx.user)));
    r.put('/api/gen/defaults', (Request req) async {
      final b = await body(req);
      settings.db.tx(() {
        if (b.containsKey('quality')) settings.put(req.ctx.user, 'gen_default_quality', _negativeJson(b['quality']));
        if (b.containsKey('negative')) settings.put(req.ctx.user, 'gen_default_negative', _negativeJson(b['negative']));
      });
      return json(_defaults(req.ctx.user));
    });

    // 네거티브 세트: 기본 세트(고칠 수 없음) + 내가 만든 세트
    r.get('/api/gen/negative-sets', (Request req) => json([
          for (final s in defaultNegativeSets) s.toJson(),
          for (final s in negativeSets.list(req.ctx.user)) _negativeSetJson(s),
        ]));
    r.post('/api/gen/negative-sets', (Request req) async {
      final b = await body(req);
      final id = negativeSets.add(req.ctx.user, requireStr(b['name'], '세트 이름', max: 60), _negativeJson(b['negative']));
      return json(_negativeSetJson(negativeSets.one(req.ctx.user, id)), status: 201);
    });
    r.put('/api/gen/negative-sets/<id>', (Request req, String id) async {
      final b = await body(req);
      negativeSets.update(req.ctx.user, pathInt(id),
          name: b.containsKey('name') ? requireStr(b['name'], '세트 이름', max: 60) : null,
          negativeJson: b.containsKey('negative') ? _negativeJson(b['negative']) : null);
      return json(_negativeSetJson(negativeSets.one(req.ctx.user, pathInt(id))));
    });
    r.delete('/api/gen/negative-sets/<id>', (Request req, String id) {
      negativeSets.delete(req.ctx.user, pathInt(id));
      return ok();
    });
    r.get('/api/gen/categories', (Request req) => json([
          for (final k in promptCategoryKeys) {'key': k, 'label': promptCategoryLabels[k]},
        ]));
    r.post('/api/gen/parse', (Request req) async {
      final b = await body(req);
      final text = (b['text'] ?? '').toString();
      if (text.length > 20000) throw ApiError('프롬프트가 너무 길어요 (2만 자까지)');
      return json(parsePrompt(text, learned: catalog.learnedMap(req.ctx.user)).toJson());
    });
    r.get('/api/gen/png-info/<assetId>', (Request req, String assetId) async {
      final uid = req.ctx.user;
      final a = assets.get(uid, pathInt(assetId));
      if (a['mime_type'] != 'image/png') return json({'info': null, 'reason': 'PNG 파일만 생성 정보를 읽을 수 있어요'});
      final file = File(files.absolute(a['file_path'] as String));
      if (!file.existsSync()) throw ApiError('파일이 디스크에 없어요', 404);
      final info = readGenerationInfo(await file.readAsBytes(), learned: catalog.learnedMap(uid));
      return json({'info': info?.toJson(), if (info == null) 'reason': '이 이미지에는 생성 정보가 없어요'});
    });

    // 고정 프롬프트
    r.get('/api/characters/<id>/gen-presets', (Request req, String id) {
      final cid = ownedId(db, 'characters', req.ctx.user, id, '캐릭터');
      return json(records.presets(cid));
    });
    r.post('/api/characters/<id>/gen-presets', (Request req, String id) async {
      final uid = req.ctx.user;
      final cid = ownedId(db, 'characters', uid, id, '캐릭터');
      final b = await body(req);
      final pid = records.addPreset(cid,
          name: requireStr(b['name'], '프리셋 이름', max: 60),
          tagsJson: _tagsJson(b['tags']),
          negativeJson: _negativeJson(b['negative']),
          loras: _loras(uid, b['loras']));
      return json(records.preset(uid, pid), status: 201);
    });
    r.put('/api/gen/presets/<id>', (Request req, String id) async {
      final uid = req.ctx.user;
      final pid = records.preset(uid, pathInt(id))['id'] as int;
      final b = await body(req);
      records.updatePreset(pid,
          name: b.containsKey('name') ? requireStr(b['name'], '프리셋 이름', max: 60) : null,
          tagsJson: b.containsKey('tags') ? _tagsJson(b['tags']) : null,
          negativeJson: b.containsKey('negative') ? _negativeJson(b['negative']) : null,
          loras: b.containsKey('loras') ? _loras(uid, b['loras']) : null);
      return json(records.preset(uid, pid));
    });
    r.delete('/api/gen/presets/<id>', (Request req, String id) {
      records.deletePreset(records.preset(req.ctx.user, pathInt(id))['id'] as int);
      return ok();
    });

    // 생성 기록
    r.get('/api/characters/<id>/gen-records', (Request req, String id) {
      final cid = ownedId(db, 'characters', req.ctx.user, id, '캐릭터');
      return json(records.records(cid));
    });
    r.post('/api/characters/<id>/gen-records', (Request req, String id) async {
      final uid = req.ctx.user;
      final cid = ownedId(db, 'characters', uid, id, '캐릭터');
      final b = await body(req);
      final rid = db.tx(() => records.addRecord(cid, _recordValues(uid, cid, b), _loras(uid, b['loras'], keepUnknown: true)));
      return json(records.record(uid, rid), status: 201);
    });
    r.get('/api/gen/records/<id>', (Request req, String id) => json(records.record(req.ctx.user, pathInt(id))));
    r.put('/api/gen/records/<id>', (Request req, String id) async {
      final uid = req.ctx.user;
      final rec = records.record(uid, pathInt(id));
      final cid = rec['character_id'] as int;
      final b = await body(req);
      db.tx(() => records.updateRecord(cid, rec['id'] as int, _recordValues(uid, cid, b),
          b.containsKey('loras') ? _loras(uid, b['loras'], keepUnknown: true) : null));
      return json(records.record(uid, rec['id'] as int));
    });
    r.delete('/api/gen/records/<id>', (Request req, String id) {
      records.deleteRecord(records.record(req.ctx.user, pathInt(id))['id'] as int);
      return ok();
    });
  }

  // ───── 값 검사 ─────

  Map<String, Object?> _modelValues(Map<String, Object?> b, {required bool creating}) => {
        if (creating || b.containsKey('name')) 'name': requireStr(b['name'], '모델 이름', max: 120),
        for (final k in ['base_model', 'file_name', 'sha256', 'source_url', 'note'])
          if (b.containsKey(k)) k: _text(b[k], k == 'note' ? 2000 : 300),
      };

  Map<String, Object?> _loraValues(Map<String, Object?> b, {required bool creating}) => {
        if (creating || b.containsKey('name')) 'name': requireStr(b['name'], 'LoRA 이름', max: 120),
        for (final k in ['file_name', 'base_model', 'trigger_words', 'sha256', 'source_url', 'note'])
          if (b.containsKey(k)) k: _text(b[k], k == 'note' || k == 'trigger_words' ? 2000 : 300),
        if (b.containsKey('default_weight')) 'default_weight': _weight(b['default_weight']) ?? 1.0,
        if (b.containsKey('civitai_version_id')) 'civitai_version_id': toIntOrNull(b['civitai_version_id']),
      };

  String? _text(Object? v, int max) {
    final s = strOrNull(v);
    if (s != null && s.length > max) throw ApiError('$max자까지 쓸 수 있어요');
    return s;
  }

  double? _weight(Object? v) {
    if (v == null || v == '') return null;
    final w = v is num ? v.toDouble() : double.tryParse(v.toString());
    if (w == null || w < -10 || w > 10) throw ApiError('가중치는 -10 ~ 10 사이 숫자로 써 주세요');
    return w;
  }

  /// {카테고리: [{tag, weight}]} — 모르는 카테고리는 미분류로
  String _tagsJson(Object? v) {
    if (v == null) return '{}';
    if (v is! Map) throw ApiError('태그 형식이 잘못됐어요');
    final out = <String, List<Map<String, Object?>>>{};
    var count = 0;
    v.forEach((key, list) {
      final k = promptCategoryKeys.contains(key) ? key as String : 'etc';
      for (final item in list is List ? list : const []) {
        final tag = strOrNull(item is Map ? item['tag'] : item);
        if (tag == null) continue;
        if (tag.length > 200) throw ApiError('태그는 200자까지 쓸 수 있어요');
        if (++count > 500) throw ApiError('태그가 너무 많아요 (500개까지)');
        out.putIfAbsent(k, () => []).add({'tag': tag, 'weight': (item is Map ? _weight(item['weight']) : null) ?? 1.0});
      }
    });
    return jsonEncode({for (final k in promptCategoryKeys) if (out[k] != null) k: out[k]});
  }

  Map<String, Object?> _defaults(int uid) {
    List<String> read(String name, List<String> initial) {
      final v = settings.one(uid, name);
      return v == null ? initial : [for (final t in jsonDecode(v) as List) '$t'];
    }

    return {
      'quality': read('gen_default_quality', initialDefaultQuality),
      'negative': read('gen_default_negative', initialDefaultNegative),
    };
  }

  Map<String, Object?> _negativeSetJson(Row r) =>
      {'id': r['id'], 'name': r['name'], 'negative': jsonDecode(r['negative_json'] as String), 'builtin': false};

  String _negativeJson(Object? v) {
    final list = v is String ? v.split(RegExp(r'[,\n]')) : (v is List ? v : const []);
    final out = [for (final s in list) ?strOrNull(s)];
    if (out.length > 500) throw ApiError('네거티브 태그가 너무 많아요 (500개까지)');
    return jsonEncode(out);
  }

  /// [{name 또는 gen_lora_id, weight}] → 목록과 맞춤. keepUnknown이면 목록에 없는 이름도 남긴다(생성 기록).
  List<LoraUse> _loras(int uid, Object? v, {bool keepUnknown = false}) {
    final out = <LoraUse>[];
    for (final m in listOfMaps(v)) {
      final byId = toIntOrNull(m['gen_lora_id']);
      final weight = _weight(m['weight']);
      if (byId != null) {
        final l = catalog.lora(uid, byId);
        out.add((loraId: byId, name: l['name'] as String, weight: weight ?? (l['default_weight'] as num).toDouble()));
        continue;
      }
      final name = strOrNull(m['name']);
      if (name == null) continue;
      if (name.length > 120) throw ApiError('LoRA 이름은 120자까지 쓸 수 있어요');
      final id = catalog.loraIdByName(uid, name);
      if (id == null && !keepUnknown) throw ApiError('LoRA 목록에 없는 이름이에요: $name');
      final fallback = id == null ? 1.0 : (catalog.lora(uid, id)['default_weight'] as num).toDouble();
      out.add((loraId: id, name: name, weight: weight ?? fallback));
    }
    return out;
  }

  /// 생성 기록 칸 (요청에 있는 칸만). 플랫폼·모델은 이름으로 와도 되고, 목록에 없으면 추가한다.
  Map<String, Object?> _recordValues(int uid, int characterId, Map<String, Object?> b) {
    final v = <String, Object?>{};
    int? platformId;
    if (b.containsKey('gen_platform_id')) {
      final n = toIntOrNull(b['gen_platform_id']);
      platformId = n == null ? null : catalog.platform(uid, n)['id'] as int;
      v['gen_platform_id'] = platformId;
    } else if (b.containsKey('platform')) {
      final name = _text(b['platform'], 60);
      platformId = name == null ? null : catalog.addPlatform(uid, name);
      v['gen_platform_id'] = platformId;
    }
    if (b.containsKey('gen_model_id')) {
      final n = toIntOrNull(b['gen_model_id']);
      v['gen_model_id'] = n == null ? null : catalog.model(uid, n)['id'];
    } else if (b.containsKey('model')) {
      final name = _text(b['model'], 120);
      if (name != null && platformId == null) throw ApiError('모델을 넣으려면 플랫폼을 먼저 골라 주세요');
      v['gen_model_id'] = name == null ? null : catalog.addModel(platformId!, {'name': name});
    }
    if (b.containsKey('gen_preset_id')) {
      final n = toIntOrNull(b['gen_preset_id']);
      if (n != null && records.preset(uid, n)['character_id'] != characterId) throw ApiError('이 캐릭터의 고정 프롬프트가 아니에요');
      v['gen_preset_id'] = n;
    }
    if (b.containsKey('asset_id')) v['asset_id'] = ownedIdOrNull(db, 'assets', uid, b['asset_id'], '이미지');
    if (b.containsKey('title')) v['title'] = _text(b['title'], 120);
    if (b.containsKey('prompt_raw')) v['prompt_raw'] = _text(b['prompt_raw'], 20000);
    if (b.containsKey('note')) v['note'] = _text(b['note'], 5000);
    if (b.containsKey('sampler')) v['sampler'] = _text(b['sampler'], 120);
    if (b.containsKey('tags')) v['tags_json'] = _tagsJson(b['tags']);
    if (b.containsKey('negative')) v['negative_json'] = _negativeJson(b['negative']);
    for (final k in ['seed', 'steps', 'width', 'height']) {
      if (!b.containsKey(k)) continue;
      final n = toIntOrNull(b[k]);
      if (b[k] != null && b[k] != '' && n == null) throw ApiError('$k 칸에는 숫자를 써 주세요');
      if (n != null && n < 0) throw ApiError('$k 칸에는 0 이상 숫자를 써 주세요');
      v[k] = n;
    }
    if (b.containsKey('cfg_scale')) {
      final s = b['cfg_scale'];
      final d = s == null || s == '' ? null : (s is num ? s.toDouble() : double.tryParse(s.toString()));
      if (s != null && s != '' && d == null) throw ApiError('CFG 칸에는 숫자를 써 주세요');
      v['cfg_scale'] = d;
    }
    if (b.containsKey('extra')) {
      if (b['extra'] is! Map) throw ApiError('추가 정보 형식이 잘못됐어요');
      final e = jsonEncode(b['extra']);
      if (e.length > 200000) throw ApiError('추가 정보가 너무 커요');
      v['extra_json'] = e;
    }
    if (b.containsKey('is_cover')) v['is_cover'] = toFlag(b['is_cover']);
    return v;
  }
}
