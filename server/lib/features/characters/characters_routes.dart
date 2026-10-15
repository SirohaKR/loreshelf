// 캐릭터 API — 목록(전체/서재/프로젝트별), 상세, 만들기, 고치기, 즐겨찾기, 옮기기, 분기, 갤러리, 휴지통으로.
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/db.dart';
import '../../core/http.dart';
import '../../core/owned.dart';
import '../projects/projects_repository.dart';
import 'characters_repository.dart';

class CharactersRoutes {
  final Db db;
  final CharactersRepository characters;
  final ProjectsRepository projects;

  CharactersRoutes(AppContext app)
      : db = app.db,
        characters = CharactersRepository(app.db),
        projects = ProjectsRepository(app.db);

  void register(Router r) {
    r.get('/api/characters', _list);
    r.post('/api/characters', _create);
    r.get('/api/characters/<id>', _detail);
    r.put('/api/characters/<id>', _update);
    r.delete('/api/characters/<id>', _delete);
    r.put('/api/characters/<id>/favorite', _favorite);
    r.post('/api/characters/<id>/move', _move);
    r.post('/api/characters/<id>/fork', _fork);
    r.post('/api/characters/<id>/assets', _addAsset);
    r.delete('/api/characters/<id>/assets/<assetId>', _removeAsset);
  }

  Response _list(Request req) {
    final uid = req.ctx.user, q = req.url.queryParameters;
    return json(characters.list(
      uid,
      scope: q['scope'] == 'library' ? 'library' : 'all',
      projectId: ownedIdOrNull(db, 'projects', uid, q['project_id'], '프로젝트'),
      worldId: toIntOrNull(q['world_id']),
      tag: strOrNull(q['tag']),
      query: strOrNull(q['q']),
      favoriteOnly: q['favorite'] == '1',
      recent: q['recent'] == '1',
      limit: toIntOrNull(q['limit'])?.clamp(1, 500),
    ));
  }

  Map<String, Object?> _detail0(int uid, int id) => {
        ...characters.detail(uid, id),
        'linked_projects': projects.linkedToCharacter(id),
      };

  Response _detail(Request req, String id) => json(_detail0(req.ctx.user, pathInt(id)));

  /// 화면에서 온 기본 칸 검사 → 저장할 값.
  Map<String, Object?> _values(int uid, Map<String, Object?> b) => {
        'world_id': ownedIdOrNull(db, 'worlds', uid, b['world_id'], '세계관'),
        'project_id': ownedIdOrNull(db, 'projects', uid, b['project_id'], '프로젝트'),
        'character_template_id': null, // 템플릿은 다음 단계
        'name': requireStr(b['name'], '이름', max: 60),
        'name_en': _short(b['name_en'], '영문 이름', 60),
        'tagline': _short(b['tagline'], '한 줄 소개', 120),
        'quote': _short(b['quote'], '대표 대사', 200),
        'theme_color': colorOrNull(b['theme_color']),
        'portrait_asset_id': ownedIdOrNull(db, 'assets', uid, b['portrait_asset_id'], '대표 이미지'),
        'body_md': _short(b['body_md'], '배경 이야기', 50000),
        'visibility': oneOf(b['visibility'], visibilities, 'private'),
        'is_card_downloadable': toFlag(b['is_card_downloadable']),
        'is_favorite': toFlag(b['is_favorite']),
        'sort_order': toIntOrNull(b['sort_order']) ?? 0,
      };

  String? _short(Object? v, String label, int max) {
    final s = strOrNull(v);
    if (s != null && s.length > max) throw ApiError('$label은(는) $max자까지 쓸 수 있어요');
    return s;
  }

  List<Map<String, Object?>> _limited(Object? v, String label) {
    final list = listOfMaps(v);
    if (list.length > 100) throw ApiError('$label은(는) 100개까지예요');
    return list;
  }

  /// 딸린 칸 검사. 완전히 빈 줄은 버린다.
  void _saveChildren(int uid, int id, Map<String, Object?> b) {
    final fields = [
      for (final f in _limited(b['fields'], '기본 정보'))
        if (strOrNull(f['label']) != null || strOrNull(f['value']) != null)
          {'label': requireStr(f['label'], '기본 정보 항목 이름', max: 40), 'value': _short(f['value'], '기본 정보 값', 2000), 'is_secret': toFlag(f['is_secret'])},
    ];
    final traits = [
      for (final t in _limited(b['traits'], '성격 축'))
        if (strOrNull(t['left_label']) != null || strOrNull(t['right_label']) != null)
          {
            'left_label': requireStr(t['left_label'], '성격 축 왼쪽', max: 20),
            'right_label': requireStr(t['right_label'], '성격 축 오른쪽', max: 20),
            'value_percent': (toIntOrNull(t['value_percent']) ?? 50).clamp(0, 100),
          },
    ];
    final quotes = [
      for (final q in _limited(b['quotes'], '대표 대사'))
        if (strOrNull(q['body']) != null)
          {'body': _short(q['body'], '대사', 1000), 'situation': _short(q['situation'], '상황', 100), 'is_secret': toFlag(q['is_secret'])},
    ];
    final tagNames = b['tags'] is List ? (b['tags'] as List).cast<Object?>() : <Object?>[];
    if (tagNames.length > 30) throw ApiError('태그는 30개까지예요');
    characters.replaceChildren(uid, id, fields: fields, traits: traits, quotes: quotes, tagNames: tagNames);
  }

  Future<Response> _create(Request req) async {
    final uid = req.ctx.user, b = await body(req);
    final id = db.tx(() {
      final v = _values(uid, b);
      final id = characters.create(uid, v);
      _saveChildren(uid, id, b);
      if (v['portrait_asset_id'] != null) characters.addAsset(id, v['portrait_asset_id'] as int); // 대표 이미지는 갤러리에도
      return id;
    });
    return json(_detail0(uid, id), status: 201);
  }

  Future<Response> _update(Request req, String id) async {
    final uid = req.ctx.user, cid = pathInt(id), b = await body(req);
    db.tx(() {
      final v = _values(uid, b);
      characters.update(uid, cid, v);
      _saveChildren(uid, cid, b);
      if (v['portrait_asset_id'] != null) characters.addAsset(cid, v['portrait_asset_id'] as int);
    });
    return json(_detail0(uid, cid));
  }

  Response _delete(Request req, String id) {
    characters.softDelete(req.ctx.user, pathInt(id));
    return ok();
  }

  Future<Response> _favorite(Request req, String id) async {
    final b = await body(req);
    characters.setFavorite(req.ctx.user, pathInt(id), toFlag(b['is_favorite']));
    return ok();
  }

  Future<Response> _move(Request req, String id) async {
    final uid = req.ctx.user, cid = pathInt(id), b = await body(req);
    characters.move(uid, cid, ownedIdOrNull(db, 'projects', uid, b['project_id'], '프로젝트'));
    return json(_detail0(uid, cid));
  }

  Future<Response> _fork(Request req, String id) async {
    final uid = req.ctx.user, b = await body(req);
    final newId = characters.fork(uid, pathInt(id), ownedIdOrNull(db, 'projects', uid, b['project_id'], '프로젝트'));
    return json(_detail0(uid, newId), status: 201);
  }

  Future<Response> _addAsset(Request req, String id) async {
    final uid = req.ctx.user, cid = pathInt(id), b = await body(req);
    characters.get(uid, cid);
    final assetId = ownedId(db, 'assets', uid, b['asset_id'], '이미지');
    db.tx(() {
      characters.addAsset(cid, assetId);
      if (b['set_portrait'] == true) characters.setPortrait(cid, assetId);
      characters.touch(cid);
    });
    return json(_detail0(uid, cid));
  }

  Response _removeAsset(Request req, String id, String assetId) {
    final uid = req.ctx.user, cid = pathInt(id), aid = pathInt(assetId);
    characters.get(uid, cid);
    db.tx(() {
      characters.removeAsset(cid, aid);
      characters.clearPortraitIf(cid, aid);
      characters.touch(cid);
    });
    return json(_detail0(uid, cid));
  }
}
