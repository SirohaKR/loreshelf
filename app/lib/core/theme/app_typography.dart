// 글꼴 — 웹과 같은 순서로 한글 글꼴을 찾는다 (Pretendard → 맑은 고딕 → 애플 산돌고딕 → Noto)
import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const fontFallback = ['Pretendard', 'Malgun Gothic', 'Apple SD Gothic Neo', 'Noto Sans KR'];

  /// Material 기본 글자 크기표에 색과 한글 글꼴만 입힌 것
  static TextTheme textTheme(TextTheme base, Color text) =>
      base.apply(bodyColor: text, displayColor: text, fontFamilyFallback: fontFallback);
}
