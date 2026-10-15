// 서버 전체가 같이 쓰는 것(설정, DB)과 요청마다의 사용자 정보.
import 'dart:io';

import 'package:shelf/shelf.dart';

import 'db.dart';
import 'http.dart';

class Config {
  final String dbPath;
  final String assetsDir; // 업로드한 파일 폴더
  final String migrationsDir;
  final String webDir; // 작업실 화면 파일 폴더
  final int port;

  Config({required this.dbPath, required this.assetsDir, required this.migrationsDir, required this.webDir, required this.port});

  factory Config.fromEnv() {
    final env = Platform.environment;
    return Config(
      dbPath: env['DB_PATH'] ?? 'data/loreshelf.db',
      assetsDir: env['ASSETS_DIR'] ?? 'data/assets',
      migrationsDir: env['MIGRATIONS_DIR'] ?? 'migrations',
      webDir: env['WEB_DIR'] ?? 'web',
      port: int.tryParse(env['PORT'] ?? '') ?? 5000,
    );
  }
}

/// 서버 전체 공용.
class AppContext {
  final Db db;
  final Config config;
  AppContext({required this.db, required this.config});
}

/// 요청 한 번의 사용자 (로그인 안 했으면 uid가 null).
class Ctx {
  final int? uid;
  const Ctx(this.uid);

  int get user => uid ?? (throw ApiError('로그인이 필요해요', 401));
}

extension RequestCtx on Request {
  Ctx get ctx => context['ctx'] as Ctx? ?? const Ctx(null);
}
