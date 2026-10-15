// 이름표 + 입력칸 한 묶음 (로그인 화면 전용)
import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
            child,
          ],
        ),
      );
}
