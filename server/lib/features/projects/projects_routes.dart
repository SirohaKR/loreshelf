// 프로젝트 API — 목록, 상세(전용 + 연결 캐릭터), 만들기, 고치기, 서재 캐릭터 연결·해제, 휴지통으로.
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/db.dart';
import '../../core/http.dart';
import '../../core/owned.dart';
import '../characters/characters_repository.dart';
import '../genres/genres_repository.dart';
import 'projects_repository.dart';

class ProjectsRoutes {
  final Db db;
  final ProjectsRepository projects;
  final CharactersRepository characters;
  final GenresRepository genres;

  ProjectsRoutes(AppContext app)
      : db = app.db,
        projects = ProjectsRepository(app.db),
        characters = CharactersRepository(app.db),
        genres = GenresRepository(app.db);

  void register(Router r) {
    r.get('/api/projects', (Request req) => json(projects.list(req.ctx.user, genreId: toIntOrNull(req.url.queryParameters['genre_id']))));
    r.post('/api/projects', _create);
    r.get('/api/projects/<id>', _detail);
    r.put('/api/projects/<id>', _update);
    r.delete('/api/projects/<id>', _delete);
    r.post('/api/projects/<id>/characters', _link);
    r.delete('/api/projects/<id>/characters/<characterId>', _unlink);
  }

  Map<String, Object?> _values(int uid, Map<String, Object?> b) => {
        'world_id': ownedIdOrNull(db, 'worlds', uid, b['world_id'], '세계관'),
        'kind': oneOf(b['kind'], projectKinds, 'etc'),
        'name': requireStr(b['name'], '이름', max: 60),
        'summary': strOrNull(b['summary']),
        'body_md': strOrNull(b['body_md']),
        'cover_asset_id': ownedIdOrNull(db, 'assets', uid, b['cover_asset_id'], '대표 이미지'),
        'progress_percent': (toIntOrNull(b['progress_percent']) ?? 0).clamp(0, 100),
        'visibility': oneOf(b['visibility'], visibilities, 'private'),
        'sort_order': toIntOrNull(b['sort_order']) ?? 0,
      };

  Map<String, Object?> _detail0(int uid, int id) => {
        ...projects.get(uid, id),
        'characters': characters.list(uid, projectId: id),
      };

  /// 장르 태그 번호 목록 검사 (기본 제공이거나 내가 만든 것만, 30개까지).
  List<int> _genreIds(int uid, Object? v) {
    final ids = (v is List ? v : const []).map(toIntOrNull).whereType<int>().toSet().toList();
    if (ids.length > 30) throw ApiError('장르 태그는 30개까지예요');
    for (final id in ids) {
      if (!genres.usable(uid, id)) throw ApiError('없는 장르 태그예요', 404);
    }
    return ids;
  }

  Future<Response> _create(Request req) async {
    final uid = req.ctx.user, b = await body(req);
    final id = db.tx(() {
      final id = projects.create(uid, _values(uid, b));
      genres.setForProject(id, _genreIds(uid, b['genre_ids']));
      return id;
    });
    return json(_detail0(uid, id), status: 201);
  }

  Response _detail(Request req, String id) => json(_detail0(req.ctx.user, pathInt(id)));

  Future<Response> _update(Request req, String id) async {
    final uid = req.ctx.user, pid = pathInt(id), b = await body(req);
    db.tx(() {
      projects.update(uid, pid, _values(uid, b));
      if (b.containsKey('genre_ids')) genres.setForProject(pid, _genreIds(uid, b['genre_ids']));
    });
    return json(_detail0(uid, pid));
  }

  Response _delete(Request req, String id) {
    projects.softDelete(req.ctx.user, pathInt(id));
    return ok();
  }

  /// 서재 캐릭터 연결. 이 프로젝트 전용 캐릭터는 이미 소속이라 연결할 필요가 없다.
  Future<Response> _link(Request req, String id) async {
    final uid = req.ctx.user, pid = pathInt(id), b = await body(req);
    projects.get(uid, pid);
    final c = characters.get(uid, ownedId(db, 'characters', uid, b['character_id'], '캐릭터'));
    if (c['project_id'] == pid) throw ApiError('이미 이 프로젝트 전용 캐릭터예요');
    projects.link(pid, c['id'] as int, strOrNull(b['role']));
    return json(_detail0(uid, pid));
  }

  Response _unlink(Request req, String id, String characterId) {
    final uid = req.ctx.user, pid = pathInt(id);
    projects.get(uid, pid);
    projects.unlink(pid, pathInt(characterId));
    return json(_detail0(uid, pid));
  }
}
