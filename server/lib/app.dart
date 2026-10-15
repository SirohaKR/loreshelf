// 서버 조립 — DB 마이그레이션 실행 + 기능 폴더들의 API 주소를 모아 하나의 서버로.
// 새 기능을 추가하면: features/<기능>/ 에 repository·routes를 만들고 아래 목록에 한 줄.
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'core/context.dart';
import 'core/http.dart';
import 'core/migrations.dart';
import 'features/assets/assets_routes.dart';
import 'features/auth/auth_middleware.dart';
import 'features/auth/auth_routes.dart';
import 'features/characters/characters_routes.dart';
import 'features/gen/gen_routes.dart';
import 'features/genres/genres_routes.dart';
import 'features/home/home_routes.dart';
import 'features/projects/projects_routes.dart';
import 'features/search/search_routes.dart';
import 'features/settings/settings_routes.dart';
import 'features/tags/tags_routes.dart';
import 'features/trash/trash_routes.dart';
import 'features/web/web_routes.dart';
import 'features/worlds/worlds_routes.dart';

/// DB 준비 + API 주소 등록 → 요청을 처리하는 핸들러.
Handler buildApp(AppContext app) {
  final done = runMigrations(app.db, loadMigrations(app.config.migrationsDir));
  for (final name in done) {
    print('[migration] $name');
  }

  final router = Router();
  for (final routes in [
    AuthRoutes(app).register,
    SettingsRoutes(app).register,
    HomeRoutes(app).register,
    WorldsRoutes(app).register,
    ProjectsRoutes(app).register,
    GenresRoutes(app).register,
    CharactersRoutes(app).register,
    GenRoutes(app).register,
    TagsRoutes(app).register,
    AssetsRoutes(app).register,
    SearchRoutes(app).register,
    TrashRoutes(app).register,
    WebRoutes(app).register,
  ]) {
    routes(router);
  }
  router.all('/api/<rest|.*>', (Request req) => json({'error': '없는 주소예요'}, status: 404));

  return const Pipeline()
      .addMiddleware(errorMiddleware())
      .addMiddleware(authMiddleware(app))
      .addHandler(router.call);
}
