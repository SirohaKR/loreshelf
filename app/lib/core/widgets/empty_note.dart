// 비어 있을 때 안내 문구
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class EmptyNote extends StatelessWidget {
  const EmptyNote(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(child: Text(text, style: TextStyle(color: context.colors.muted))),
      );
}
