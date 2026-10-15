// 앱 전체가 함께 쓰는 API 클라이언트 하나. 서버 주소·쿠키는 기기에 저장된 값으로 시작한다.
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/preferences_provider.dart';
import 'api_client.dart';

part 'api_client_provider.g.dart';

/// 기기에 저장하는 키
abstract final class SessionKeys {
  static const serverUrl = 'server_url';
  static const cookie = 'session_cookie';
}

/// 빌드할 때 `--dart-define=LORESHELF_URL=http://192.168.0.10:5090` 처럼 바꿀 수 있다
const defaultServerUrl = String.fromEnvironment('LORESHELF_URL', defaultValue: 'http://localhost:5091');

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ApiClient(
    baseUrl: kIsWeb ? '' : prefs.getString(SessionKeys.serverUrl) ?? defaultServerUrl,
    cookie: prefs.getString(SessionKeys.cookie),
  );
}
