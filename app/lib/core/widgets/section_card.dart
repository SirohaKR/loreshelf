// CSS .card + h3 — 제목 있는 흰 상자, 그리고 .sec-head — 섹션 제목 줄
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, this.title, this.trailing, required this.child});

  final String? title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Row(children: [Expanded(child: Text(title!, style: AppTextStyles.cardTitle)), ?trailing]),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// 섹션 제목 줄 — 오른쪽에 '모두 보기' 같은 글자 링크
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section, bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
          if (action != null) TextLink(action!, onTap: onAction),
        ],
      ),
    );
  }
}

/// accent 색 글자 링크 (CSS .sec-head a)
class TextLink extends StatelessWidget {
  const TextLink(this.text, {super.key, this.onTap});
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Text(text, style: AppTextStyles.bodySmall.copyWith(color: context.colors.accent)),
      );
}
