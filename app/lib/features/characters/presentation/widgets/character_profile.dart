// 프로필 탭 — 넓으면 왼쪽 300px(기본 정보·장르) + 오른쪽(성격·대사·소개). CSS .cols
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/empty_note.dart';
import '../../../../core/widgets/markdown_text.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../projects/presentation/widgets/genre_groups.dart';
import '../../domain/character.dart';

class CharacterProfile extends StatelessWidget {
  const CharacterProfile(this.ch, {super.key});
  final CharacterDetail ch;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.muted;
    final left = [
      SectionCard(
        title: '기본 정보',
        child: ch.fields.isEmpty
            ? const EmptyNote('적어 둔 항목이 없어요')
            : Column(
                children: [
                  for (final f in ch.fields)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 84, child: Text(f.label, style: AppTextStyles.bodySmall.copyWith(color: muted))),
                          Expanded(child: Text(f.value, style: AppTextStyles.bodySmall)),
                          if (f.isSecret) const AppChip('🔒 비밀', tone: Tone.rose),
                        ],
                      ),
                    ),
                ],
              ),
      ),
      if (ch.projectGenres.isNotEmpty) SectionCard(title: '프로젝트 장르', child: GenreGroups(ch.projectGenres)),
    ];
    final right = [
      if (ch.traits.isNotEmpty)
        SectionCard(title: '성격', child: Column(children: [for (final t in ch.traits) TraitBar(t)])),
      if (ch.quotes.isNotEmpty)
        SectionCard(
          title: '대사',
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final q in ch.quotes) QuoteBox(q)]),
        ),
      SectionCard(
        title: '소개',
        child: (ch.bodyMd ?? '').trim().isEmpty ? const EmptyNote('아직 소개 글이 없어요') : MarkdownText(ch.bodyMd!),
      ),
    ];

    Widget column(List<Widget> cards) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (final (i, w) in cards.indexed) Padding(padding: EdgeInsets.only(top: i == 0 ? 0 : 18), child: w)],
        );

    return LayoutBuilder(
      builder: (context, box) => box.maxWidth >= 760
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(width: 300, child: column(left)), const SizedBox(width: 18), Expanded(child: column(right))],
            )
          : column([...left, ...right]),
    );
  }
}

/// 성격 막대 — 내향 ●──── 외향 (CSS .trait). 오른쪽이 없으면 강도 막대 — 신중함 ████░ 80% (CSS .trait.one)
class TraitBar extends StatelessWidget {
  const TraitBar(this.t, {super.key});
  final Trait t;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final percent = t.valuePercent.clamp(0, 100);
    final right = t.rightLabel;
    final track = DecoratedBox(decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(3)));
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Text(t.leftLabel, style: AppTextStyles.bodySmall),
              const Spacer(),
              if (right != null)
                Text(right, style: AppTextStyles.bodySmall)
              else
                Text('$percent%', style: AppTextStyles.bodySmall.copyWith(color: c.text, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 5),
          if (right == null)
            SizedBox(
              height: 6,
              child: Stack(
                children: [
                  Positioned.fill(child: track),
                  FractionallySizedBox(
                    widthFactor: percent / 100,
                    heightFactor: 1,
                    child: DecoratedBox(decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(3))),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, box) => SizedBox(
                height: 12,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(top: 3, bottom: 3, child: track),
                    Positioned(
                      left: box.maxWidth * percent / 100 - 6,
                      child: Container(width: 12, height: 12, decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 대사 상자 — 왼쪽 파란 줄 (CSS .quote)
class QuoteBox extends StatelessWidget {
  const QuoteBox(this.q, {super.key});
  final Quote q;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.surface2,
        border: Border(left: BorderSide(color: c.accent, width: 3)),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q.body, style: AppTextStyles.bodySmall),
          if (q.situation != null || q.isSecret) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                if (q.situation != null) Text(q.situation!, style: AppTextStyles.chip.copyWith(color: c.muted)),
                if (q.isSecret) const Padding(padding: EdgeInsets.only(left: 6), child: AppChip('🔒 비밀', tone: Tone.rose)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
