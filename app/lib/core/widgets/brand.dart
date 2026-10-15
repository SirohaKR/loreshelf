// 로고 (웹 작업실 .brand 와 같은 모양: 파란 네모 안의 L + 이름)
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class Brand extends StatelessWidget {
  const Brand({super.key, this.compact = false});

  /// true면 네모 마크만
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final mark = Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(10)),
      child: Text('L', style: TextStyle(color: c.onAccent, fontWeight: FontWeight.w800, fontSize: 17)),
    );
    if (compact) return mark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('LoreShelf', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            Text('캐릭터 아카이브', style: TextStyle(color: c.muted, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}
