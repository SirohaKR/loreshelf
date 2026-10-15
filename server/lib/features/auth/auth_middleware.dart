// 요청마다 로그인한 사용자를 찾아 둔다. /api/ 는 로그인이 필요 (/api/auth/ 는 제외).
import 'package:shelf/shelf.dart';

import '../../core/context.dart';
import '../../core/http.dart';
import 'auth_repository.dart';

const sessionCookie = 'ls_session';

String? cookieValue(Request req, String name) {
  final header = req.headers['cookie'];
  if (header == null) return null;
  for (final part in header.split(';')) {
    final i = part.indexOf('=');
    if (i > 0 && part.substring(0, i).trim() == name) return part.substring(i + 1).trim();
  }
  return null;
}

Middleware authMiddleware(AppContext app) {
  final repo = AuthRepository(app.db);
  return (inner) => (req) async {
        final token = cookieValue(req, sessionCookie);
        final ctx = Ctx(token == null ? null : repo.userForToken(token));
        final path = '/${req.url.path}';
        if (path.startsWith('/api/') && !path.startsWith('/api/auth/') && ctx.uid == null) {
          return json({'error': '로그인이 필요해요'}, status: 401);
        }
        return inner(req.change(context: {...req.context, 'ctx': ctx}));
      };
}
