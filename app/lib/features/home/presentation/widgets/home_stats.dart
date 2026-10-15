// CSS .stats — 숫자 4칸. 좁으면 2×2
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/home_summary.dart';

class HomeStats extends StatelessWidget {
  const HomeStats(this.counts, {super.key});
  final HomeCounts counts;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final items = [
      ('전체 캐릭터', counts.characters, '☺', Tone.accent),
      ('서재', counts.libraryCharacters, '📚', Tone.ok),
      ('프로젝트', counts.projects, '⚔', Tone.warn),
      ('공개 중', counts.publicItems, '◎', Tone.rose),
    ];
    return LayoutBuilder(
      builder: (context, box) {
        final perRow = box.maxWidth >= 640 ? 4 : 2;
        final w = (box.maxWidth - AppSpacing.grid * (perRow - 1)) / perRow;
        return Wrap(
          spacing: AppSpacing.grid,
          runSpacing: AppSpacing.grid,
          children: [
            for (final (label, n, icon, tone) in items)
              SizedBox(
                width: w,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: c.tone(tone).$1, borderRadius: BorderRadius.circular(11)),
                          child: Text(icon, style: TextStyle(fontSize: 18, color: c.tone(tone).$2)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$n', style: AppTextStyles.statNumber),
                              Text(label, style: AppTextStyles.caption.copyWith(color: c.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
