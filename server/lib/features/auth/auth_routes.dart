// 로그인 API — 내 정보, 처음 계정 만들기(1인용: 계정이 없을 때만), 로그인, 로그아웃, 비밀번호·이름 바꾸기.
import 'dart:isolate';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/http.dart';
import '../../core/passwords.dart';
import 'auth_middleware.dart';
import 'auth_repository.dart';

class AuthRoutes {
  final AuthRepository users;
  final _fails = <String, List<DateTime>>{}; // ip → 로그인 실패 시각들 (무차별 대입 방지)

  AuthRoutes(AppContext app) : users = AuthRepository(app.db);

  void register(Router r) {
    r.get('/api/auth/me', _me);
    r.post('/api/auth/setup', _setup);
    r.post('/api/auth/login', _login);
    r.post('/api/auth/logout', _logout);
    r.put('/api/account/password', _password);
    r.put('/api/account/profile', _profile);
  }

  // 비밀번호 계산은 0.5초쯤 걸려서 다른 요청이 멈추지 않게 따로 돌린다
  Future<String> _hash(String pw) => Isolate.run(() => hashPassword(pw));
  Future<bool> _check(String stored, String pw) => Isolate.run(() => checkPassword(stored, pw));

  Response _withSession(Map<String, Object?> data, int userId) {
    final token = users.createSession(userId);
    return json(data).change(headers: {
      'set-cookie': '$sessionCookie=$token; Path=/; HttpOnly; SameSite=Lax; Max-Age=${sessionDays * 86400}',
    });
  }

  Response _me(Request req) {
    final uid = req.ctx.uid;
    if (uid == null) return json({'user': null, 'needs_setup': users.countUsers() == 0});
    return json({'user': users.me(uid), 'needs_setup': false});
  }

  void _checkNewPassword(String pw) {
    if (pw.length < 8) throw ApiError('비밀번호는 8자 이상으로 해 주세요');
  }

  Future<Response> _setup(Request req) async {
    if (users.countUsers() > 0) throw ApiError('이미 계정이 있어요. 로그인해 주세요', 403);
    final b = await body(req);
    final login = requireStr(b['login_name'], '아이디', max: 30);
    if (!RegExp(r'^[a-zA-Z0-9_.-]{2,30}$').hasMatch(login)) throw ApiError('아이디는 영어·숫자·_.- 로 2~30자예요');
    final pw = (b['password'] ?? '').toString();
    _checkNewPassword(pw);
    final display = strOrNull(b['display_name']) ?? login;
    final id = users.createUser(login, await _hash(pw), display);
    return _withSession({'user': users.me(id)}, id);
  }

  Future<Response> _login(Request req) async {
    final ip = (req.context['shelf.io.connection_info'] as dynamic)?.remoteAddress?.address?.toString() ?? '?';
    final now = DateTime.now();
    final fails = (_fails[ip] ?? []).where((t) => now.difference(t).inMinutes < 10).toList();
    _fails[ip] = fails;
    if (fails.length >= 10) throw ApiError('로그인 실패가 너무 많아요. 10분 뒤에 다시 해 주세요', 429);
    final b = await body(req);
    final u = users.findByLogin((b['login_name'] ?? '').toString().trim());
    if (u == null || !await _check(u['password_hash'] as String, (b['password'] ?? '').toString())) {
      fails.add(now);
      throw ApiError('아이디나 비밀번호가 맞지 않아요', 401);
    }
    return _withSession({'user': users.me(u['id'] as int)}, u['id'] as int);
  }

  Response _logout(Request req) {
    final token = cookieValue(req, sessionCookie);
    if (token != null) users.deleteSession(token);
    return ok().change(headers: {'set-cookie': '$sessionCookie=; Path=/; HttpOnly; SameSite=Lax; Max-Age=0'});
  }

  Future<Response> _password(Request req) async {
    final uid = req.ctx.user, b = await body(req);
    final u = users.findUser(uid)!;
    if (!await _check(u['password_hash'] as String, (b['old'] ?? '').toString())) throw ApiError('지금 비밀번호가 맞지 않아요');
    final nw = (b['new'] ?? '').toString();
    _checkNewPassword(nw);
    users.setPassword(uid, await _hash(nw));
    users.deleteOtherSessions(uid, cookieValue(req, sessionCookie) ?? ''); // 다른 기기는 로그아웃
    return ok();
  }

  Future<Response> _profile(Request req) async {
    final uid = req.ctx.user, b = await body(req);
    users.setDisplayName(uid, requireStr(b['display_name'], '이름', max: 30));
    return json({'user': users.me(uid)});
  }
}
