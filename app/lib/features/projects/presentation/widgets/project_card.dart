// 프로젝트 목록의 카드 — 종류 아이콘, 이름·요약, 칩, 장르 태그 한 줄, 진행도
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/labels.dart';
import '../../../../core/utils/time_ago.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../domain/project.dart';
import '../project_detail_page.dart';
import 'kind_icon.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard(this.p, {super.key});
  final ProjectSummary p;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.muted;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ProjectDetailPage.open(context, p.id),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  KindIcon(p.kind),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.sectionTitle),
                        Text(p.summary ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(color: muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  AppChip(kindLabel[p.kind] ?? p.kind, tone: kindTone[p.kind] ?? Tone.plain),
                  AppChip('캐릭터 ${p.characterCount}'),
                  VisibilityChip(p.visibility),
                ],
              ),
              const SizedBox(height: 8),
              // 장르 태그는 한 줄만, 넘치면 잘림
              SizedBox(
                height: 22,
                child: ClipRect(
                  child: Wrap(spacing: 5, children: [for (final g in p.genres) AppChip('#${g.name}', tone: Tone.accent)]),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text('기획 ${p.progressPercent}%', style: AppTextStyles.caption.copyWith(color: muted)),
                  const Spacer(),
                  Text(timeAgo(p.updatedAt), style: AppTextStyles.caption.copyWith(color: muted)),
                ],
              ),
              const SizedBox(height: 6),
              AppProgressBar(p.progressPercent),
            ],
          ),
        ),
      ),
    );
  }
}
