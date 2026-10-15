// 앱 뼈대 — 테마 + "로그인했으면 메인 화면, 아니면 로그인 화면"
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'features/auth/presentation/auth_session_provider.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/shell/presentation/shell_page.dart';

class LoreShelfApp extends ConsumerWidget {
  const LoreShelfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'LoreShelf',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(appThemeModeProvider),
      home: const _Gate(),
    );
  }
}

/// authSessionProvider(`AsyncValue<User?>`)를 지켜보다가 상태에 맞는 화면을 고른다.
/// 로그인/로그아웃 코드 어디에도 "화면 이동"이 없다 — 상태만 바꾸면 여기서 화면이 따라 바뀐다.
class _Gate extends ConsumerWidget {
  const _Gate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(authSessionProvider)) {
      AsyncData(value: final user?) => ShellPage(user: user),
      AsyncData() || AsyncError() => const LoginPage(),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}
