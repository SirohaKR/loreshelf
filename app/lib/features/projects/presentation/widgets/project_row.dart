// CSS .proj — 아이콘 + 이름 + 칩들 + 진행 막대 (홈의 프로젝트 상자에서 쓰는 한 줄)
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/labels.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../domain/project.dart';
import '../project_detail_page.dart';
import 'kind_icon.dart';

class ProjectRow extends StatelessWidget {
  const ProjectRow(this.project, {super.key, this.maxGenres = 3});

  final ProjectSummary project;
  final int maxGenres;

  @override
  Widget build(BuildContext context) {
    final p = project;
    return InkWell(
      onTap: () => ProjectDetailPage.open(context, p.id),
      borderRadius: BorderRadius.circular(AppRadii.input),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KindIcon(p.kind),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      AppChip(kindLabel[p.kind] ?? p.kind, tone: kindTone[p.kind] ?? Tone.plain),
                      AppChip('캐릭터 ${p.characterCount}'),
                      for (final g in p.genres.take(maxGenres)) AppChip('#${g.name}', tone: Tone.accent),
                    ],
                  ),
                  const SizedBox(height: 6),
                  AppProgressBar(p.progressPercent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
