// API 클라이언트 테스트 — 가짜 서버(MockClient)로 쿠키 저장·오류 문구·세션 만료 알림을 확인
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:loreshelf_app/core/network/api_client.dart';

http.Response jsonRes(Object body, {int status = 200, Map<String, String> headers = const {}}) => http.Response.bytes(
      utf8.encode(jsonEncode(body)),
      status,
      headers: {'content-type': 'application/json', ...headers},
    );

void main() {
  test('로그인 응답의 Set-Cookie를 기억했다가 다음 요청에 붙인다', () async {
    final seenCookies = <String?>[];
    final api = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((req) async {
        seenCookies.add(req.headers['cookie']);
        if (req.url.path == '/api/auth/login') {
          expect(jsonDecode(req.body), {'login_name': 'dev', 'password': 'pw'});
          return jsonRes(
            {'user': {'id': 1, 'login_name': 'dev', 'display_name': '서연'}},
            headers: {'set-cookie': 'ls_session=abc123; Path=/; HttpOnly; SameSite=Lax; Max-Age=2592000'},
          );
        }
        return jsonRes({'user': null});
      }),
    );

    await api.post('/api/auth/login', {'login_name': 'dev', 'password': 'pw'});
    expect(api.cookie, 'ls_session=abc123');
    await api.getMap('/api/auth/me');
    expect(seenCookies, [null, 'ls_session=abc123']);
    expect(api.imageHeaders, {'cookie': 'ls_session=abc123'});
  });

  test('로그아웃 응답(빈 쿠키)이면 쿠키를 지운다', () async {
    final api = ApiClient(
      baseUrl: 'http://test',
      cookie: 'ls_session=old',
      client: MockClient((_) async => jsonRes({'ok': true}, headers: {'set-cookie': 'ls_session=; Path=/; Max-Age=0'})),
    );
    await api.post('/api/auth/logout');
    expect(api.cookie, isNull);
  });

  test('서버 오류는 {"error"} 문구와 상태 코드를 담은 ApiException, 세션이 있었으면 만료 알림', () async {
    var expired = 0;
    final api = ApiClient(
      baseUrl: 'http://test',
      cookie: 'ls_session=old',
      client: MockClient((_) async => jsonRes({'error': '로그인이 필요해요'}, status: 401)),
    )..onUnauthorized = () => expired++;

    await expectLater(
      api.getMap('/api/home'),
      throwsA(isA<ApiException>()
          .having((e) => e.status, 'status', 401)
          .having((e) => e.isUnauthorized, 'isUnauthorized', isTrue)
          .having((e) => e.message, 'message', '로그인이 필요해요')),
    );
    expect(expired, 1);

    // 로그인 요청 자체의 401(비밀번호 틀림)은 만료가 아니다
    await expectLater(api.post('/api/auth/login', {}), throwsA(isA<ApiException>()));
    expect(expired, 1);
  });

  test('주소 만들기: 검색 조건 붙이기, 이미지 주소', () {
    final api = ApiClient(baseUrl: 'http://nas:5090');
    expect(api.uri('/api/characters', {'scope': 'library'}).toString(), 'http://nas:5090/api/characters?scope=library');
    expect(api.assetUrl(4), 'http://nas:5090/api/assets/4/thumb');
    expect(api.assetUrl(4, thumb: false), 'http://nas:5090/api/assets/4/file');
  });
}
