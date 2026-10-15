// 앱 시작점 — 저장소(SharedPreferences)를 연 뒤 ProviderScope로 앱 전체를 감싼다.
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/storage/preferences_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      // Riverpod 3은 실패한 provider를 자동으로 다시 시도한다. 서버가 준 오류(401·404 등)는
      // 다시 해도 같으니 바로 보여 주고, 그 밖의 오류만 짧게 두 번 더 시도.
      retry: (count, error) => error is ApiException || count >= 2 ? null : const Duration(milliseconds: 400),
      child: const LoreShelfApp(),
    ),
  );
}
