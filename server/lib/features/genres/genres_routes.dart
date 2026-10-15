// 장르·세계관 태그 API — 목록, 직접 추가, 직접 추가한 것 지우기.
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/http.dart';
import 'genres_repository.dart';

class GenresRoutes {
  final GenresRepository genres;
  GenresRoutes(AppContext app) : genres = GenresRepository(app.db);

  void register(Router r) {
    r.get('/api/genres', (Request req) => json(genres.list(req.ctx.user)));
    r.post('/api/genres', (Request req) async {
      final b = await body(req);
      final name = requireStr(b['name'], '태그 이름', max: 20).replaceFirst(RegExp(r'^#+'), '').trim();
      if (name.isEmpty) throw ApiError('태그 이름을 입력해 주세요');
      return json(genres.add(req.ctx.user, name), status: 201);
    });
    r.delete('/api/genres/<id>', (Request req, String id) {
      genres.deleteCustom(req.ctx.user, pathInt(id));
      return ok();
    });
  }
}
