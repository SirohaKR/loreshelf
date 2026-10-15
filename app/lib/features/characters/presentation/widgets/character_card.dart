// CSS .ch — 세로 초상화 + 이름 + 한 줄 소개, 그리고 그 카드들의 격자.
// 홈·캐릭터 목록·프로젝트 상세가 같이 쓴다.
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../domain/character.dart';
import '../character_detail_page.dart';
import 'portrait.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard(this.character, {super.key, this.badge});

  final CharacterSummary character;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final ch = character;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => CharacterDetailPage.open(context, ch.id),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Portrait(
                  name: ch.name,
                  themeColor: ch.themeColor,
                  assetId: ch.portraitAssetId,
                  badge: badge == null ? null : AppChip(badge!, tone: Tone.accent),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Text(ch.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.name)),
                  if (ch.isFavorite) const Text('★', style: TextStyle(color: AppColors.star)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                ch.tagline ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: context.colors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 화면 폭에 맞춰 열 수가 늘어나는 격자 칸 크기 (카드 최대 190px, 세로가 긴 카드)
const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 190,
  mainAxisSpacing: AppSpacing.grid,
  crossAxisSpacing: AppSpacing.grid,
  childAspectRatio: .62,
);

/// CustomScrollView 안에 넣는 격자 (Sliver)
class CharacterSliverGrid extends StatelessWidget {
  const CharacterSliverGrid(this.characters, {super.key, this.badgeOf});

  final List<CharacterSummary> characters;
  final String? Function(CharacterSummary)? badgeOf;

  @override
  Widget build(BuildContext context) => SliverGrid.builder(
        gridDelegate: _gridDelegate,
        itemCount: characters.length,
        itemBuilder: (_, i) => CharacterCard(characters[i], badge: badgeOf?.call(characters[i])),
      );
}

/// Row·Column 안에 넣는 격자 (스스로 스크롤하지 않음)
class CharacterGrid extends StatelessWidget {
  const CharacterGrid(this.characters, {super.key});
  final List<CharacterSummary> characters;

  @override
  Widget build(BuildContext context) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _gridDelegate,
        itemCount: characters.length,
        itemBuilder: (_, i) => CharacterCard(characters[i]),
      );
}
