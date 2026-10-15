// 태그 API — 자동완성용 목록.
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/http.dart';
import 'tags_repository.dart';

class TagsRoutes {
  final TagsRepository tags;
  TagsRoutes(AppContext app) : tags = TagsRepository(app.db);

  void register(Router r) {
    r.get('/api/tags', (Request req) => json(tags.list(req.ctx.user)));
  }
}
