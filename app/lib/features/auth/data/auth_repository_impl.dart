// 리포지토리 구현: /api/auth/... 를 부르고, 쿠키와 서버 주소를 기기에 저장한다.
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/storage/preferences_provider.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';

part 'auth_repository_impl.g.dart';

/// 화면 쪽에서는 이 provider로 인터페이스(AuthRepository)를 받는다. 구현이 무엇인지는 여기서만 정한다.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(apiClientProvider), ref.watch(sharedPreferencesProvider));

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._prefs);

  final ApiClient _api;
  final SharedPreferences _prefs;

  @override
  String get serverUrl => _api.baseUrl;

  @override
  set onSessionExpired(void Function()? callback) => _api.onUnauthorized = callback;

  @override
  Future<User?> currentUser() async {
    final me = await _api.getMap('/api/auth/me');
    final user = me['user'];
    return user is Map<String, Object?> ? User.fromJson(user) : null;
  }

  @override
  Future<User> login({required String serverUrl, required String loginName, required String password}) async {
    if (serverUrl.isNotEmpty) _api.baseUrl = serverUrl.replaceFirst(RegExp(r'/+$'), '');
    final res = await _api.post('/api/auth/login', {'login_name': loginName, 'password': password});
    await _prefs.setString(SessionKeys.serverUrl, _api.baseUrl);
    if (_api.cookie != null) await _prefs.setString(SessionKeys.cookie, _api.cookie!);
    return User.fromJson(res['user']! as Map<String, Object?>);
  }

  @override
  Future<void> logout() async {
    try {
      await _api.post('/api/auth/logout');
    } on ApiException {
      // 서버에 못 닿아도 이 기기에서는 로그아웃
    }
    await forgetSession();
  }

  @override
  Future<void> forgetSession() async {
    _api.cookie = null;
    await _prefs.remove(SessionKeys.cookie);
  }
}
