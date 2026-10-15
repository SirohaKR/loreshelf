// 라이트/다크 전환 — 고른 값은 기기에 저장. 처음엔 시스템 설정을 따른다.
// @riverpod 클래스 = Notifier. build()가 처음 값, toggle()이 값을 바꾸는 메서드.
// build_runner가 theme_mode_provider.g.dart 에 `appThemeModeProvider`를 만들어 준다.
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/preferences_provider.dart';

part 'theme_mode_provider.g.dart';

@Riverpod(keepAlive: true) // 앱이 켜져 있는 동안 계속 유지 (화면이 없어도 버리지 않음)
class AppThemeMode extends _$AppThemeMode {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() => switch (ref.read(sharedPreferencesProvider).getString(_key)) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  /// 지금 보이는 밝기의 반대로 (시스템 따르기 상태였으면 그 밝기 기준)
  void toggle(Brightness current) {
    state = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    ref.read(sharedPreferencesProvider).setString(_key, state.name);
  }
}
