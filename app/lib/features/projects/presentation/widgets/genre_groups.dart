// 장르 태그를 분류별로 묶어 보여 준다 (장르 / 배경·무대 / 분위기·관계 ...)
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/labels.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/empty_note.dart';
import '../../domain/genre.dart';

class GenreGroups extends StatelessWidget {
  const GenreGroups(this.genres, {super.key});
  final List<Genre> genres;

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) return const EmptyNote('붙인 장르 태그가 없어요');
    final muted = context.colors.muted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final MapEntry(key: cat, value: label) in genreCategoryLabel.entries)
          if (genres.any((g) => g.category == cat))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.caption.copyWith(color: muted)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (final g in genres.where((g) => g.category == cat)) AppChip('#${g.name}', tone: Tone.accent),
                    ],
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
