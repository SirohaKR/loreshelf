// 로그인 화면의 동작 — LoginState를 들고, submit()으로 로그인을 시도한다.
// @riverpod(소문자) = autoDispose: 로그인 화면이 사라지면 이 상태도 버려진다.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import 'auth_session_provider.dart';
import 'login_state.dart';

part 'login_provider.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  LoginState build() => const LoginState();

  Future<void> submit({required String serverUrl, required String loginName, required String password}) async {
    if (state.submitting) return;
    state = state.copyWith(submitting: true, error: null);
    try {
      await ref.read(authSessionProvider.notifier).login(
            serverUrl: serverUrl,
            loginName: loginName,
            password: password,
          );
      // 성공하면 로그인 상태가 바뀌어 화면이 메인으로 넘어가고, 이 provider는 버려진다.
    } on ApiException catch (e) {
      // 기다리는 사이에 화면이 사라졌으면(ref.mounted == false) 상태를 건드리지 않는다
      if (ref.mounted) state = LoginState(error: e.message);
      return;
    }
    if (ref.mounted) state = state.copyWith(submitting: false);
  }
}
