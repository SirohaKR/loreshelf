// 홈 맨 위 인사
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('안녕하세요, $name님', style: AppTextStyles.pageTitle),
          const SizedBox(height: 4),
          Text('오늘도 캐릭터를 모아 볼까요?', style: AppTextStyles.bodySmall.copyWith(color: context.colors.muted)),
        ],
      );
}
