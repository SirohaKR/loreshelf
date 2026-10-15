// 휴지통 API — 목록, 되살리기, 영구 삭제.
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/http.dart';
import 'trash_repository.dart';

class TrashRoutes {
  final TrashRepository trash;
  TrashRoutes(AppContext app) : trash = TrashRepository(app.db);

  void register(Router r) {
    r.get('/api/trash', (Request req) => json(trash.list(req.ctx.user)));
    r.post('/api/trash/<kind>/<id>/restore', (Request req, String kind, String id) {
      trash.restore(req.ctx.user, kind, pathInt(id));
      return ok();
    });
    r.delete('/api/trash/<kind>/<id>', (Request req, String kind, String id) {
      trash.purge(req.ctx.user, kind, pathInt(id));
      return ok();
    });
  }
}
