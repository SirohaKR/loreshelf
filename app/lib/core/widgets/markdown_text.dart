// 아주 작은 마크다운 보기 — # 제목, - 목록, **굵게** 만. (편집 단계에서 패키지로 바꿔도 됨)
import 'package:flutter/material.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText(this.source, {super.key});
  final String source;

  static final _heading = RegExp(r'^#+\s*');
  static final _bullet = RegExp(r'^\s*[-*]\s+');
  static final _bold = RegExp(r'\*\*([^*]+)\*\*');

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.copyWith(fontSize: 14, height: 1.6);
    final blocks = <Widget>[];
    for (final line in source.split('\n')) {
      final t = line.trimRight();
      if (t.isEmpty) {
        blocks.add(const SizedBox(height: 8));
      } else if (t.startsWith('#')) {
        blocks.add(Text(t.replaceFirst(_heading, ''), style: base.copyWith(fontWeight: FontWeight.w700, fontSize: 15)));
      } else if (_bullet.hasMatch(t)) {
        blocks.add(Text.rich(TextSpan(children: [const TextSpan(text: '•  '), ..._inline(t.replaceFirst(_bullet, ''))]), style: base));
      } else {
        blocks.add(Text.rich(TextSpan(children: _inline(t)), style: base));
      }
    }
    return SelectionArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: blocks));
  }

  /// **굵게** 를 굵은 글자 조각으로
  static List<TextSpan> _inline(String s) {
    final spans = <TextSpan>[];
    var at = 0;
    for (final m in _bold.allMatches(s)) {
      if (m.start > at) spans.add(TextSpan(text: s.substring(at, m.start)));
      spans.add(TextSpan(text: m.group(1), style: const TextStyle(fontWeight: FontWeight.w700)));
      at = m.end;
    }
    if (at < s.length) spans.add(TextSpan(text: s.substring(at)));
    return spans;
  }
}
