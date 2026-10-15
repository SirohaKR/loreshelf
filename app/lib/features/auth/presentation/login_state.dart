// 로그인 화면의 상태 — 보내는 중인지, 오류 문구가 있는지.
// freezed라서 불변이고, 바꿀 땐 state.copyWith(submitting: true) 처럼 새 값을 만든다.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool submitting,
    String? error,
  }) = _LoginState;
}
