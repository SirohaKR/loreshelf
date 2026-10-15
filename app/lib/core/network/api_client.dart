// 서버 /api/... 호출 담당. 쿠키 세션(ls_session)을 직접 들고 다니며 요청마다 붙인다.
// (웹으로 띄울 땐 브라우저가 쿠키를 알아서 처리하므로 손대지 않는다.)
// 각 기능의 data/ 폴더(리포지토리 구현)가 이걸 써서 서버와 이야기한다.
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// 서버가 {"error": "문구"}로 돌려준 실패, 또는 연결 실패
class ApiException implements Exception {
  ApiException(this.status, this.message);

  /// HTTP 상태 코드. 서버에 닿지도 못했으면 0
  final int status;
  final String message;

  bool get isUnauthorized => status == 401;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({required this.baseUrl, this.cookie, http.Client? client}) : _http = client ?? http.Client();

  static const cookieName = 'ls_session';

  final http.Client _http;

  /// 예: http://localhost:5091 (끝에 / 없이). 웹에선 '' = 지금 페이지와 같은 서버
  String baseUrl;

  /// 'ls_session=값' 형태. 로그인하면 채워지고 로그아웃하면 null
  String? cookie;

  /// 쿠키가 있었는데 서버가 401(로그인 필요)을 돌려주면 불린다 — 세션이 만료됐다는 뜻.
  /// 로그인 상태(AuthSession)가 여기에 "로그인 화면으로 돌아가기"를 걸어 둔다.
  void Function()? onUnauthorized;

  Uri uri(String path, [Map<String, String>? query]) {
    final u = Uri.parse('$baseUrl$path');
    return query == null || query.isEmpty ? u : u.replace(queryParameters: query);
  }

  /// 이미지 주소 — thumb(가로 480px) 또는 원본 file
  String assetUrl(int assetId, {bool thumb = true}) => uri('/api/assets/$assetId/${thumb ? 'thumb' : 'file'}').toString();

  /// Image.network에 같이 넘길 헤더 (이미지도 로그인 쿠키가 필요)
  Map<String, String> get imageHeaders => kIsWeb || cookie == null ? const {} : {'cookie': cookie!};

  Future<Map<String, Object?>> getMap(String path, [Map<String, String>? query]) async =>
      (await _send('GET', path, query: query)) as Map<String, Object?>;

  Future<List<Map<String, Object?>>> getList(String path, [Map<String, String>? query]) async =>
      ((await _send('GET', path, query: query)) as List).cast<Map<String, Object?>>();

  Future<Map<String, Object?>> post(String path, [Object? body]) async =>
      ((await _send('POST', path, body: body)) as Map?)?.cast<String, Object?>() ?? const {};

  Future<Object?> _send(String method, String path, {Map<String, String>? query, Object? body}) async {
    final req = http.Request(method, uri(path, query));
    req.headers['accept'] = 'application/json';
    if (!kIsWeb && cookie != null) req.headers['cookie'] = cookie!;
    if (body != null) {
      req.headers['content-type'] = 'application/json';
      req.body = jsonEncode(body);
    }

    final http.Response res;
    try {
      res = await http.Response.fromStream(await _http.send(req));
    } catch (e) {
      throw ApiException(0, '서버에 연결할 수 없어요 ($baseUrl)');
    }

    final hadSession = cookie != null || kIsWeb;
    _keepCookie(res.headers['set-cookie']);
    if (res.statusCode == 401 && hadSession && !path.startsWith('/api/auth/')) onUnauthorized?.call();
    final text = utf8.decode(res.bodyBytes); // 한글이 깨지지 않게 바이트에서 직접 UTF-8로
    final data = text.isEmpty ? null : jsonDecode(text);
    if (res.statusCode >= 400) {
      final msg = data is Map && data['error'] is String ? data['error'] as String : '요청이 실패했어요 (${res.statusCode})';
      throw ApiException(res.statusCode, msg);
    }
    return data;
  }

  /// Set-Cookie: ls_session=abc; Path=/; HttpOnly ... 에서 'ls_session=abc'만 꺼내 둔다
  void _keepCookie(String? header) {
    if (header == null) return;
    final m = RegExp('$cookieName=([^;,]*)').firstMatch(header);
    if (m == null) return;
    cookie = m.group(1)!.isEmpty ? null : '$cookieName=${m.group(1)}';
  }
}
