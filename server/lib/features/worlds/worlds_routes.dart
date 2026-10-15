// 세계관 API — 목록, 상세(속한 캐릭터·프로젝트 포함), 만들기, 고치기, 휴지통으로.
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/db.dart';
import '../../core/http.dart';
import '../../core/owned.dart';
import '../characters/characters_repository.dart';
import '../projects/projects_repository.dart';
import 'worlds_repository.dart';

class WorldsRoutes {
  final Db db;
  final WorldsRepository worlds;
  final CharactersRepository characters;
  final ProjectsRepository projects;

  WorldsRoutes(AppContext app)
      : db = app.db,
        worlds = WorldsRepository(app.db),
        characters = CharactersRepository(app.db),
        projects = ProjectsRepository(app.db);

  void register(Router r) {
    r.get('/api/worlds', (Request req) => json(worlds.list(req.ctx.user)));
    r.post('/api/worlds', _create);
    r.get('/api/worlds/<id>', _detail);
    r.put('/api/worlds/<id>', _update);
    r.delete('/api/worlds/<id>', _delete);
  }

  /// 화면에서 온 값 검사 → 저장할 값.
  Map<String, Object?> _values(int uid, Map<String, Object?> b) => {
        'name': requireStr(b['name'], '이름', max: 60),
        'summary': strOrNull(b['summary']),
        'body_md': strOrNull(b['body_md']),
        'cover_asset_id': ownedIdOrNull(db, 'assets', uid, b['cover_asset_id'], '대표 이미지'),
        'visibility': oneOf(b['visibility'], visibilities, 'private'),
        'sort_order': toIntOrNull(b['sort_order']) ?? 0,
      };

  Future<Response> _create(Request req) async {
    final uid = req.ctx.user;
    final id = worlds.create(uid, _values(uid, await body(req)));
    return json(worlds.get(uid, id), status: 201);
  }

  Response _detail(Request req, String id) {
    final uid = req.ctx.user, wid = pathInt(id);
    return json({
      ...worlds.get(uid, wid),
      'characters': characters.list(uid, worldId: wid),
      'projects': projects.list(uid, worldId: wid),
    });
  }

  Future<Response> _update(Request req, String id) async {
    final uid = req.ctx.user, wid = pathInt(id);
    worlds.update(uid, wid, _values(uid, await body(req)));
    return json(worlds.get(uid, wid));
  }

  Response _delete(Request req, String id) {
    worlds.softDelete(req.ctx.user, pathInt(id));
    return ok();
  }
}
