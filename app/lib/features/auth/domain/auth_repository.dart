// 리포지토리 인터페이스: 로그인에 관해 "무엇을 할 수 있나"만 적는다. "어떻게"(HTTP·쿠키·저장)는 data/에.
// Java의 interface와 같다. 화면·provider는 이 인터페이스만 알고, 테스트에선 가짜 구현으로 바꿔 끼운다.
import 'user.dart';

abstract interface class AuthRepository {
  /// 지금 쓰는 서버 주소 (웹에선 '')
  String get serverUrl;

  /// 저장된 세션이 아직 살아 있으면 그 사람, 아니면 null
  Future<User?> currentUser();

  /// 실패하면 ApiException (문구는 서버가 준 것)
  Future<User> login({required String serverUrl, required String loginName, required String password});

  /// 서버에 로그아웃을 알리고 이 기기의 세션을 지운다 (서버에 못 닿아도 지움)
  Future<void> logout();

  /// 서버에 묻지 않고 이 기기의 세션만 지운다 (만료됐을 때)
  Future<void> forgetSession();

  /// 다른 요청이 "로그인 필요(401)"를 받았을 때 불릴 함수
  set onSessionExpired(void Function()? callback);
}
