// 자주 쓰는 글자 모양 — CSS의 h1 / h2 / .card h3 / .sub / .chip 크기와 맞춤.
// 색이 필요한 것(muted 등)은 context.colors에서 꺼내 copyWith(color: ...)로 입힌다.
import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  /// 화면 제목 (h1 24px)
  static const pageTitle = TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -.4);

  /// 섹션 제목 (h2 16px)
  static const sectionTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  /// 카드 제목 (.card h3 14px)
  static const cardTitle = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);

  /// 카드 속 이름 (.ch b 15px)
  static const name = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);

  static const body = TextStyle(fontSize: 14, height: 1.5);
  static const bodySmall = TextStyle(fontSize: 13);

  /// 보조 설명 (.sub 13px / 12px)
  static const caption = TextStyle(fontSize: 12);

  /// 칩 글자 (.chip 11px)
  static const chip = TextStyle(fontSize: 11);

  /// 숫자 요약 (.stat .n 24px)
  static const statNumber = TextStyle(fontSize: 24, fontWeight: FontWeight.w800);
}
