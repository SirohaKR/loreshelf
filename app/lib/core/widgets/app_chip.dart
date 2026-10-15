// CSS .chip — 작은 둥근 꼬리표. selected를 주면 필터 칩(눌러서 고르기)으로 쓴다
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../utils/labels.dart';

class AppChip extends StatelessWidget {
  const AppChip(this.label, {super.key, this.tone = Tone.plain, this.selected, this.onTap});

  final String label;
  final Tone tone;

  /// 필터 칩으로 쓸 때만 (선택됨 = accent 색, 조금 더 크게)
  final bool? selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isFilter = selected != null;
    final (bg, fg) = c.tone(selected == true ? Tone.accent : tone);
    final outlined = (!isFilter && tone == Tone.plain) || selected == false;
    final chip = Container(
      padding: EdgeInsets.symmetric(horizontal: isFilter ? 12 : 8, vertical: isFilter ? 5 : 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: outlined ? c.line : Colors.transparent),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isFilter ? 12 : 11,
          color: fg,
          fontWeight: selected == true ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
    if (onTap == null) return chip;
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(AppRadii.pill), child: chip);
  }
}

/// 공개 범위 칩 (공개 / 링크 공개 / 🔒 비공개)
class VisibilityChip extends StatelessWidget {
  const VisibilityChip(this.visibility, {super.key});
  final String visibility;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = visibilityBadge(visibility);
    return AppChip(label, tone: tone);
  }
}
