// 프롬프트 글 붙여넣기 → 자동 분류 — 웹 character_prompt.js의 "붙여넣기" 카드와 같은 일.
// 여기서는 결과(tags·negative·loras)만 돌려주고, 어디에 넣을지는 쓰는 쪽(고정 프롬프트·생성 기록 폼)이 정한다.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/gen.dart';
import '../../domain/gen_draft.dart';
import '../character_gen_edit_provider.dart';

class PromptPasteClassifier extends HookConsumerWidget {
  const PromptPasteClassifier({super.key, required this.onClassified, this.initialText = ''});
  final ValueChanged<({Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras, String text})> onClassified;
  final String initialText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = useTextEditingController(text: initialText);
    final typed = useValueListenable(text);
    final learned = ref.watch(genLearnedDictionaryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: text,
          minLines: 3,
          maxLines: 8,
          maxLength: 20000,
          decoration: const InputDecoration(
            labelText: '프롬프트 붙여넣기',
            hintText: 'WebUI/Forge 생성 정보, NovelAI 태그, Midjourney 명령어를 통째로 붙여넣어 보세요',
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: typed.text.trim().isEmpty
                ? null
                : () {
                    final r = classify(typed.text, learned: learned.value ?? const {});
                    onClassified((tags: r.tags, negative: r.negative, loras: r.loras, text: typed.text));
                  },
            icon: const Icon(Icons.auto_fix_high, size: 16),
            label: const Text('자동 분류'),
          ),
        ),
      ],
    );
  }
}
