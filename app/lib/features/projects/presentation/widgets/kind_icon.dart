// 프로젝트 종류 아이콘 네모 (⚔ 게임, ✉ 챗봇, ✦ 기타) — CSS .proj .ico
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/labels.dart';

class KindIcon extends StatelessWidget {
  const KindIcon(this.kind, {super.key, this.size = 40});
  final String kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = context.colors.tone(kindTone[kind] ?? Tone.ok);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(size / 4)),
      child: Text(kindIcon[kind] ?? '✦', style: TextStyle(color: fg, fontSize: size * .45)),
    );
  }
}
