// CSS .hero — 초상화 150px + 위치 칩(프로젝트/서재) + 이름·영문명·한 줄 소개·대사·태그
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/labels.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../projects/presentation/project_detail_page.dart';
import '../../domain/character.dart';
import 'portrait.dart';

class CharacterHero extends StatelessWidget {
  const CharacterHero(this.ch, {super.key});
  final CharacterDetail ch;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (ch.inLibrary)
              const AppChip('📚 서재', tone: Tone.ok)
            else
              AppChip(
                '${kindIcon[ch.projectKind] ?? '✦'} ${ch.projectName}',
                tone: kindTone[ch.projectKind] ?? Tone.plain,
                onTap: () => ProjectDetailPage.open(context, ch.projectId!),
              ),
            for (final lp in ch.linkedProjects)
              AppChip(
                '↗ ${lp.name}${lp.role == null ? '' : ' · ${lp.role}'}',
                tone: Tone.accent,
                onTap: () => ProjectDetailPage.open(context, lp.id),
              ),
            if (ch.worldName != null) AppChip('🌍 ${ch.worldName}'),
            VisibilityChip(ch.visibility),
            if (ch.sourceCharacterName != null) AppChip('분기: ${ch.sourceCharacterName}'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Flexible(child: Text(ch.name, style: AppTextStyles.pageTitle)),
            if (ch.isFavorite)
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Text('★', style: TextStyle(color: AppColors.star, fontSize: 20)),
              ),
          ],
        ),
        if (ch.nameEn != null) Text(ch.nameEn!, style: AppTextStyles.bodySmall.copyWith(color: c.muted)),
        if (ch.tagline != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: Text(ch.tagline!, style: const TextStyle(fontSize: 15))),
        if (ch.quote != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('“${ch.quote}”', style: TextStyle(color: c.muted, fontStyle: FontStyle.italic)),
          ),
        if (ch.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(spacing: 5, runSpacing: 5, children: [for (final t in ch.tags) AppChip('#$t')]),
        ],
      ],
    );
    final portrait = SizedBox(
      width: 150,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Portrait(name: ch.name, themeColor: ch.themeColor, assetId: ch.portraitAssetId, fontSize: 30),
      ),
    );

    return LayoutBuilder(
      builder: (context, box) => box.maxWidth >= 560
          ? Row(crossAxisAlignment: CrossAxisAlignment.end, children: [portrait, const SizedBox(width: 24), Expanded(child: info)])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [portrait, const SizedBox(height: 16), info]),
    );
  }
}
