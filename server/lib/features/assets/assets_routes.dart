// 파일 API — 이미지 올리기(본문 = 파일 그대로, 파일 이름은 x-file-name 헤더), 원본·썸네일 보기.
// 파일 주소도 로그인이 필요하다 (/api/ 아래). 블로그 공개용 주소는 4단계에서 따로 만든다.
import 'dart:io';
import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/http.dart';
import 'assets_repository.dart';
import 'assets_service.dart';

class AssetsRoutes {
  final AssetsService service;
  final AssetsRepository assets;

  AssetsRoutes(AppContext app)
      : service = AssetsService(app),
        assets = AssetsRepository(app.db);

  void register(Router r) {
    r.post('/api/assets', _upload);
    r.get('/api/assets/<id>', (Request req, String id) => json(_public(assets.get(req.ctx.user, pathInt(id)))));
    r.get('/api/assets/<id>/file', (Request req, String id) => _file(req, id, thumb: false));
    r.get('/api/assets/<id>/thumb', (Request req, String id) => _file(req, id, thumb: true));
  }

  /// 화면에 보낼 칸 (디스크 경로는 숨김).
  Map<String, Object?> _public(Map<String, Object?> a) => {
        for (final k in ['id', 'original_name', 'mime_type', 'byte_size', 'width', 'height', 'caption', 'created_at']) k: a[k],
      };

  Future<Response> _upload(Request req) async {
    final uid = req.ctx.user;
    final declared = int.tryParse(req.headers['content-length'] ?? '');
    if (declared != null && declared > maxUploadBytes) throw ApiError('파일은 20MB까지 올릴 수 있어요', 413);
    final builder = BytesBuilder(copy: false);
    await for (final chunk in req.read()) {
      builder.add(chunk);
      if (builder.length > maxUploadBytes) throw ApiError('파일은 20MB까지 올릴 수 있어요', 413);
    }
    final name = Uri.decodeComponent(req.headers['x-file-name'] ?? '');
    final row = await service.saveImage(uid, builder.takeBytes(), name);
    return json(_public(row), status: 201);
  }

  Future<Response> _file(Request req, String id, {required bool thumb}) async {
    final a = assets.get(req.ctx.user, pathInt(id));
    final path = a['file_path'] as String;
    var file = File(thumb ? service.thumbPath(path) : service.absolute(path));
    var type = thumb ? 'image/jpeg' : a['mime_type'] as String;
    if (thumb && !file.existsSync()) {
      file = File(service.absolute(path)); // 썸네일을 못 만든 이미지는 원본으로
      type = a['mime_type'] as String;
    }
    if (!file.existsSync()) return json({'error': '파일이 디스크에 없어요'}, status: 404);
    return Response.ok(file.openRead(), headers: {
      'content-type': type,
      'content-length': '${file.lengthSync()}',
      // 한 번 올린 파일 번호의 내용은 바뀌지 않으므로 오래 캐시해도 된다
      'cache-control': 'private, max-age=31536000, immutable',
      'x-content-type-options': 'nosniff',
    });
  }
}
