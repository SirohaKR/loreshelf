// CSS .bar — 6px 진행 막대
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar(this.percent, {super.key});
  final int percent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: LinearProgressIndicator(
        value: percent.clamp(0, 100) / 100,
        minHeight: 6,
        color: c.accent,
        backgroundColor: c.surface2,
      ),
    );
  }
}
