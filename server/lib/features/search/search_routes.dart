// 검색 API — /api/search?q=검색어
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/http.dart';
import 'search_repository.dart';

class SearchRoutes {
  final SearchRepository search;
  SearchRoutes(AppContext app) : search = SearchRepository(app.db);

  void register(Router r) {
    r.get('/api/search', (Request req) {
      final q = strOrNull(req.url.queryParameters['q']);
      if (q == null) return json({'characters': [], 'worlds': [], 'projects': []});
      if (q.length > 100) throw ApiError('검색어는 100자까지예요');
      return json(search.search(req.ctx.user, q));
    });
  }
}
