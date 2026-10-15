// 색 — 웹 작업실 server/web/static/css/style.css 의 :root / .dark 변수와 똑같은 값.
// ThemeExtension으로 ThemeData에 끼워 두고 어디서든 context.colors.accent 처럼 꺼내 쓴다.
import 'package:flutter/material.dart';

/// 칩·아이콘의 색 짝 이름 (CSS의 .chip.a / .ok / .warn / .rose)
enum Tone { plain, accent, ok, warn, rose }

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.line,
    required this.text,
    required this.muted,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.ok,
    required this.okSoft,
    required this.warn,
    required this.warnSoft,
    required this.rose,
    required this.roseSoft,
    required this.danger,
    required this.dangerSoft,
  });

  final Color bg, surface, surface2, line, text, muted;
  final Color accent, accentSoft, onAccent;
  final Color ok, okSoft, warn, warnSoft, rose, roseSoft, danger, dangerSoft;

  /// 즐겨찾기 별
  static const star = Color(0xFFE0A800);

  static const light = AppColors(
    bg: Color(0xFFF4F5F7),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF0F2F5),
    line: Color(0xFFE2E5EA),
    text: Color(0xFF1C2028),
    muted: Color(0xFF6B7280),
    accent: Color(0xFF3F5BD8),
    accentSoft: Color(0xFFE9EDFF),
    onAccent: Color(0xFFFFFFFF),
    ok: Color(0xFF2F9E6B),
    okSoft: Color(0xFFE3F5EC),
    warn: Color(0xFFD9822B),
    warnSoft: Color(0xFFFDF0E1),
    rose: Color(0xFFD6487A),
    roseSoft: Color(0xFFFBE6EE),
    danger: Color(0xFFC93C3C),
    dangerSoft: Color(0xFFFBE5E5),
  );

  static const dark = AppColors(
    bg: Color(0xFF14161B),
    surface: Color(0xFF1C1F26),
    surface2: Color(0xFF242832),
    line: Color(0xFF2E333E),
    text: Color(0xFFE8EAF0),
    muted: Color(0xFF9198A8),
    accent: Color(0xFF7B91FF),
    accentSoft: Color(0xFF262D4D),
    onAccent: Color(0xFF10132A),
    ok: Color(0xFF2F9E6B),
    okSoft: Color(0xFF1D3A2E),
    warn: Color(0xFFD9822B),
    warnSoft: Color(0xFF3D2D1B),
    rose: Color(0xFFD6487A),
    roseSoft: Color(0xFF3D1F2B),
    danger: Color(0xFFFF7B7B),
    dangerSoft: Color(0xFF3D1F1F),
  );

  /// (배경, 글자) 색 짝
  (Color, Color) tone(Tone t) => switch (t) {
        Tone.plain => (surface2, muted),
        Tone.accent => (accentSoft, accent),
        Tone.ok => (okSoft, ok),
        Tone.warn => (warnSoft, warn),
        Tone.rose => (roseSoft, rose),
      };

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) => t < .5 ? this : (other ?? this);
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
