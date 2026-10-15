// 고정 프롬프트 만들기 · 고치기 — 이름 + 붙여넣어 자동 분류 + 네거티브 + LoRA, 분류 결과 미리 보기
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/section_card.dart';
import '../domain/gen.dart';
import '../domain/gen_draft.dart';
import 'character_gen_edit_provider.dart';
import 'widgets/character_gen_tab.dart' show PromptRows;
import 'widgets/lora_editor.dart';
import 'widgets/prompt_paste_classifier.dart';

class GenPresetEditPage extends HookConsumerWidget {
  const GenPresetEditPage({super.key, required this.characterId, this.preset});
  final int characterId;

  /// null이면 새로 만들기
  final GenPreset? preset;

  static Future<GenPreset?> open(BuildContext context, {required int characterId, GenPreset? preset}) =>
      Navigator.of(context).push(MaterialPageRoute<GenPreset>(builder: (_) => GenPresetEditPage(characterId: characterId, preset: preset)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = useState(preset == null ? GenPresetDraft.empty() : GenPresetDraft.fromPreset(preset!));
    final d = draft.value;
    final error = useState<String?>(null);
    final saver = ref.watch(genPresetSaverProvider);
    final c = context.colors;

    void set(GenPresetDraft Function(GenPresetDraft) change) => draft.value = change(draft.value);

    Future<void> save() async {
      error.value = d.problem;
      if (error.value != null) return;
      final saved = await ref.read(genPresetSaverProvider.notifier).save(characterId, preset?.id, draft.value);
      if (saved != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(preset == null ? '고정 프롬프트를 만들었어요' : '저장했어요')));
        Navigator.pop(context, saved);
      }
    }

    Future<void> delete() async {
      final ok = await showConfirmationDialog(context, title: "'${preset!.name}'을(를) 지울까요?", message: '되돌릴 수 없어요.', confirmLabel: '지우기');
      if (!ok || !context.mounted) return;
      try {
        await ref.read(genActionsProvider).deletePreset(characterId, preset!.id);
        if (context.mounted) Navigator.pop(context);
      } catch (e) {
        if (context.mounted) showAppErrorToast(context, e);
      }
    }

    final err = error.value ?? (saver.hasError ? '${saver.error}' : null);

    return Scaffold(
      appBar: AppBar(
        title: Text(preset == null ? '새 고정 프롬프트' : '고정 프롬프트 편집'),
        actions: [if (preset != null) IconButton(tooltip: '지우기', icon: const Icon(Icons.delete_outline), onPressed: delete)],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  initialValue: d.name,
                  maxLength: 60,
                  decoration: const InputDecoration(labelText: '이름 * (예: 전투복, 평상복)'),
                  onChanged: (v) => set((x) => x.copyWith(name: v)),
                ),
                const SizedBox(height: 8),
                SectionCard(
                  title: '프롬프트 붙여넣기',
                  child: PromptPasteClassifier(
                    onClassified: (r) => set((x) => x.copyWith(tags: r.tags, negative: r.negative, loras: r.loras)),
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: '분류 결과',
                  child: d.usedCategories.isEmpty && d.negative.isEmpty
                      ? Text('아직 없어요. 위에서 붙여넣고 자동 분류해 보세요', style: TextStyle(color: c.muted))
                      : PromptRows(d),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: '네거티브 · 쉼표로 구분',
                  child: TextFormField(
                    initialValue: d.negative.join(', '),
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'lowres, bad anatomy'),
                    onChanged: (v) => set((x) => x.copyWith(negative: _splitCsv(v))),
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'LoRA',
                  child: LoraEditor(loras: d.loras, onChanged: (v) => set((x) => x.copyWith(loras: v))),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(color: c.surface, border: Border(top: BorderSide(color: c.line))),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: Text(err ?? '', style: TextStyle(color: c.danger, fontWeight: FontWeight.w600, fontSize: 13))),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: saver.isLoading ? null : save,
                      child: Text(saver.isLoading ? '저장 중…' : (preset == null ? '만들기' : '저장')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<String> _splitCsv(String v) => v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
