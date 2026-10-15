// 로그인 상태 — "지금 누가 로그인해 있나"를 앱 전체에 알려 준다.
// @riverpod 클래스 + Future를 돌려주는 build() = AsyncNotifier.
//   build(): 앱을 켤 때 한 번, 저장된 쿠키가 아직 유효한지 물어본다 (null = 로그인 화면으로)
//   login()/logout()/expire(): state를 바꾸면 이걸 지켜보던 화면(app.dart의 _Gate)이 다시 그려진다.
// build_runner가 auth_session_provider.g.dart 에 `authSessionProvider`를 만든다.
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../data/auth_repository_impl.dart';
import '../domain/user.dart';

part 'auth_session_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthSession extends _$AuthSession {
  @override
  Future<User?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    // 다른 화면의 요청이 401을 받으면 → 로그인 화면으로
    repo.onSessionExpired = () => unawaited(expire());
    try {
      return await repo.currentUser();
    } on ApiException {
      return null; // 서버가 꺼져 있거나 쿠키가 만료됨 → 로그인 화면에서 다시
    }
  }

  /// 실패하면 ApiException을 그대로 던진다 (로그인 화면이 문구를 보여 줌).
  /// 일부러 state를 AsyncLoading으로 바꾸지 않는다 — 바꾸면 로그인 화면이 사라졌다 다시 생겨 입력값이 날아간다.
  Future<void> login({required String serverUrl, required String loginName, required String password}) async {
    final user = await ref
        .read(authRepositoryProvider)
        .login(serverUrl: serverUrl, loginName: loginName, password: password);
    state = AsyncData(user);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }

  /// 세션 만료 — 서버에 묻지 않고 이 기기의 세션만 지우고 로그인 화면으로
  Future<void> expire() async {
    if (state.value == null) return;
    await ref.read(authRepositoryProvider).forgetSession();
    state = const AsyncData(null);
  }
}
