// 프로젝트 상세 머리말 — 큰 종류 아이콘, 이름·요약, 칩(종류·진행도·공개·세계관), 진행 막대
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/labels.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../domain/project.dart';
import 'kind_icon.dart';

class ProjectHeader extends StatelessWidget {
  const ProjectHeader(this.p, {super.key});
  final ProjectDetail p;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            KindIcon(p.kind, size: 56),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: AppTextStyles.pageTitle),
                  if (p.summary != null)
                    Text(p.summary!, style: AppTextStyles.bodySmall.copyWith(color: context.colors.muted)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      AppChip(kindLabel[p.kind] ?? p.kind, tone: kindTone[p.kind] ?? Tone.plain),
                      AppChip('기획 ${p.progressPercent}%'),
                      VisibilityChip(p.visibility),
                      if (p.worldName != null) AppChip('🌍 ${p.worldName}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppProgressBar(p.progressPercent),
      ],
    );
  }
}
