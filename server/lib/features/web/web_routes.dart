// 작업실 화면 — web/index.html 과 web/static/. 화면은 주소의 # 뒤로 페이지를 바꾸는 한 장짜리 앱.
// 정적 파일이 바뀌면 주소(?v=)도 바뀌게 해서 업데이트 후 예전 화면이 브라우저에 남지 않게 한다.
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import '../../core/context.dart';

class WebRoutes {
  final String dir;
  late final String version = _version();
  late final Handler _static = createStaticHandler(dir);

  WebRoutes(AppContext app) : dir = app.config.webDir;

  /// 정적 파일 중 가장 최근에 바뀐 시각 (초).
  String _version() {
    final staticDir = Directory(p.join(dir, 'static'));
    if (!staticDir.existsSync()) return '0';
    final latest = staticDir
        .listSync(recursive: true)
        .whereType<File>()
        .fold<int>(0, (a, f) => f.lastModifiedSync().millisecondsSinceEpoch > a ? f.lastModifiedSync().millisecondsSinceEpoch : a);
    return '${latest ~/ 1000}';
  }

  void register(Router r) {
    r.get('/', _index);
    r.get('/static/<path|.*>', (Request req, String path) async {
      final res = await _static(req); // 주소 static/... 그대로 web/static/... 파일
      return res.change(headers: {'cache-control': 'no-cache'});
    });
  }

  Response _index(Request req) {
    final f = File(p.join(dir, 'index.html'));
    if (!f.existsSync()) return Response.notFound('web/index.html 이 없어요');
    return Response.ok(f.readAsStringSync().replaceAll('{{v}}', version),
        headers: {'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-cache'});
  }
}
