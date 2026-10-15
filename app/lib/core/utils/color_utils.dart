// 초상화 바탕색 계산 — 웹 ui.js 의 pastel(), `${theme_color}55` 와 같은 결과
import 'package:flutter/material.dart';

const _pastels = [
  Color(0xFFF6D6C8), Color(0xFFCFE0F5), Color(0xFFE3D6F3), Color(0xFFD3ECDF),
  Color(0xFFF5E6B8), Color(0xFFF3CFDC), Color(0xFFCFE9EE), Color(0xFFE6E0D4),
];

/// 이미지가 없을 때 쓰는 파스텔 색 — 이름으로 항상 같은 색
Color pastel(String name) {
  var h = 0;
  for (final cp in name.runes) {
    h = (h * 31 + cp) & 0xFFFFFFFF; // JS의 >>> 0 (32비트 부호 없는 정수)
  }
  return _pastels[h % _pastels.length];
}

/// '#C9573F' → 반투명(0x55) 색. 형식이 틀리면 null
Color? themeColorOf(String? hex, {int alpha = 0x55}) {
  if (hex == null || !RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(hex)) return null;
  return Color((alpha << 24) | int.parse(hex.substring(1), radix: 16));
}
