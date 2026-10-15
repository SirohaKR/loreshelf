// HTTP 도구 — JSON 응답, 요청 본문 읽기, 오류 응답, 값 변환.
import 'dart:convert';

import 'package:shelf/shelf.dart';

/// 화면에 {"error": "..."}로 보여줄 오류.
class ApiError implements Exception {
  final int status;
  final String message;
  ApiError(this.message, [this.status = 400]);
  @override
  String toString() => message;
}

Response json(Object? body, {int status = 200}) => Response(
      status,
      body: jsonEncode(body),
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

Response ok() => json({'ok': true});

/// 요청 본문(JSON 객체). 비어 있으면 빈 맵, 깨졌으면 오류.
Future<Map<String, Object?>> body(Request req) async {
  final text = await req.readAsString();
  if (text.trim().isEmpty) return {};
  try {
    final v = jsonDecode(text);
    if (v is Map) return Map<String, Object?>.from(v);
  } on FormatException {
    // 아래에서 같은 오류로
  }
  throw ApiError('요청 내용을 읽을 수 없어요');
}

/// 오류를 JSON 응답으로 바꾸는 미들웨어.
Middleware errorMiddleware() => (inner) => (req) async {
      try {
        return await inner(req);
      } on ApiError catch (e) {
        return json({'error': e.message}, status: e.status);
      } catch (e, st) {
        print('[error] ${req.method} ${req.requestedUri.path}: $e\n$st');
        return json({'error': '서버 오류: $e'}, status: 500);
      }
    };

// ───── 값 변환 (화면에서 오는 값은 문자열·숫자·빈칸이 섞여 있다) ─────

int? toIntOrNull(Object? v) {
  if (v == null || v == '') return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is bool) return v ? 1 : 0;
  return int.tryParse(v.toString().trim());
}

/// 참/거짓 → DB의 is_ 칸 값 (0 또는 1).
int toFlag(Object? v) => (v == true || v == 1 || v == '1' || v == 'true') ? 1 : 0;

/// 공백을 자르고, 비었으면 null.
String? strOrNull(Object? v) {
  final s = (v ?? '').toString().trim();
  return s.isEmpty ? null : s;
}

/// 꼭 있어야 하는 글자 (비었으면 오류).
String requireStr(Object? v, String label, {int max = 200}) {
  final s = strOrNull(v) ?? (throw ApiError('$label을(를) 입력해 주세요'));
  if (s.length > max) throw ApiError('$label은(는) $max자까지 쓸 수 있어요');
  return s;
}

/// 정해진 값 중 하나인지 확인 (visibility, kind 등).
String oneOf(Object? v, List<String> allowed, String fallback) {
  final s = strOrNull(v) ?? fallback;
  if (!allowed.contains(s)) throw ApiError('허용되지 않는 값이에요: $s');
  return s;
}

/// '#RRGGBB' 색 (비었으면 null).
String? colorOrNull(Object? v) {
  final s = strOrNull(v);
  if (s == null) return null;
  if (!RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(s)) throw ApiError('색은 #RRGGBB 형식으로 써 주세요');
  return s.toUpperCase();
}

/// 주소의 숫자 부분 (/api/characters/12 → 12).
int pathInt(String v) => int.tryParse(v) ?? (throw ApiError('잘못된 번호예요', 404));

/// 목록 값 (JSON 배열이 아니면 빈 목록).
List<Map<String, Object?>> listOfMaps(Object? v) =>
    v is List ? v.whereType<Map>().map((m) => Map<String, Object?>.from(m)).toList() : [];

const visibilities = ['private', 'unlisted', 'public'];
