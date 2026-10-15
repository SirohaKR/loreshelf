// 홈 API — 숫자 요약, 최근 수정한 캐릭터, 진행 중인 프로젝트를 한 번에.
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/http.dart';
import '../auth/auth_repository.dart';
import '../characters/characters_repository.dart';
import '../projects/projects_repository.dart';
import 'home_repository.dart';

class HomeRoutes {
  final HomeRepository home;
  final CharactersRepository characters;
  final ProjectsRepository projects;
  final AuthRepository users;

  HomeRoutes(AppContext app)
      : home = HomeRepository(app.db),
        characters = CharactersRepository(app.db),
        projects = ProjectsRepository(app.db),
        users = AuthRepository(app.db);

  void register(Router r) {
    r.get('/api/home', (Request req) {
      final uid = req.ctx.user;
      return json({
        'user': users.me(uid),
        'counts': home.counts(uid),
        'recent_characters': characters.list(uid, recent: true, limit: 12),
        'projects': projects.list(uid).take(6).toList(),
      });
    });
  }
}
