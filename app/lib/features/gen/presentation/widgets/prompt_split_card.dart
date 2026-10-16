// 프롬프트 붙여넣기 → 자동 분류 → 고정 / 이번만 나눠서 저장 — 웹 character_prompt.js의 "붙여넣기" 카드와 같은 일.
// 정체성 칸(인물·외형, 성격·분위기, 의상, 화풍, 품질)은 캐릭터의 고정 프롬프트에 (이미 있는 태그는 빼고) 더하고,
// 장면 칸(표정, 포즈·구도, 배경·조명, 소품 …)은 이번 생성 기록으로 보낸다. 칸마다 "고정 / 이번만"을 바꿀 수 있다.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loreshelf_shared/loreshelf_shared.dart'
    show ParsedPrompt, PromptTag, addNegativeTags, mergePromptTags, newPromptTags, parsePrompt, promptCategoryKeys, promptTargetOf, splitPromptTags;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error_toast.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/gen.dart';
import '../../domain/gen_draft.dart';
import '../character_gen_edit_provider.dart';
import '../character_gen_provider.dart';
import '../gen_record_edit_page.dart';
import 'character_gen_tab.dart' show PromptRows;

/// 화면에 보여 줄 태그 묶음 (PromptRows용)
class _Parts with PromptParts {
  _Parts(this.tags, [this.negative = const [], this.loras = const []]);
  @override
  final Map<String, List<GenTag>> tags;
  @override
  final List<String> negative;
  @override
  final List<GenLoraUse> loras;
}

Map<String, List<PromptTag>> _shared(Map<String, List<GenTag>> m) => {
      for (final e in m.entries) e.key: [for (final t in e.value) PromptTag(t.tag, t.weight)],
    };
Map<String, List<GenTag>> _gen(Map<String, List<PromptTag>> m) => {
      for (final e in m.entries) e.key: [for (final t in e.value) GenTag(tag: t.tag, weight: t.weight)],
    };

/// 칸마다 기본 행선지 + 네거티브·LoRA는 고정
Map<String, String> defaultTargets() => {for (final k in promptCategoryKeys) k: promptTargetOf(k), 'negative': 'fixed', 'loras': 'fixed'};

class PromptSplitCard extends HookConsumerWidget {
  const PromptSplitCard({super.key, required this.characterId, required this.presets});
  final int characterId;
  final List<GenPreset> presets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = useTextEditingController();
    final typed = useValueListenable(text);
    final parsed = useState<ParsedPrompt?>(null);
    final view = useState(_Parts(const {}));
    final targets = useState(defaultTargets());
    final learned = ref.watch(genLearnedDictionaryProvider);
    final defaults = ref.watch(genDefaultsProvider).value ?? const GenDefaults();
    final removed = useState(const <String>[]);
    final c = context.colors;

    void classify() {
      final p = parsePrompt(typed.text, learned: learned.value ?? const {});
      parsed.value = p;
      final s = defaults.strip(_gen(p.categories), p.negative); // 공통 기본값과 겹치는 건 뺀다
      removed.value = s.removed;
      view.value = _Parts(
        s.tags,
        s.negative,
        [for (final l in p.loras) GenLoraUse(name: l.name, weight: l.weight)],
      );
    }

    final v = view.value;
    final hasResult = parsed.value != null && (v.usedCategories.isNotEmpty || v.negative.isNotEmpty);

    return SectionCard(
      title: '붙여넣기 → 고정 / 이번만 나눠서 저장',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: text,
            minLines: 3,
            maxLines: 8,
            maxLength: 20000,
            decoration: const InputDecoration(
              labelText: '프롬프트 붙여넣기',
              hintText: '1boy, black hair, red eyes, shy, white dress shirt, holding bouquet …',
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: typed.text.trim().isEmpty ? null : classify,
              icon: const Icon(Icons.auto_fix_high, size: 16),
              label: const Text('자동 분류'),
            ),
          ),
          if (hasResult) ...[
            const SizedBox(height: 8),
            PromptRows(
              v,
              targets: targets.value,
              onTarget: (k, to) => targets.value = {...targets.value, k: to},
              onDelete: (k, i) => view.value = k == 'negative'
                  ? _Parts(v.tags, negativeWithout(v.negative, i), v.loras)
                  : _Parts(tagsWithout(v.tags, k, i), v.negative, v.loras),
            ),
            if (removed.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('공통 기본값과 겹쳐서 뺐어요: ${removed.value.join(', ')}', style: AppTextStyles.caption.copyWith(color: c.muted)),
              ),
            const SizedBox(height: 8),
            Text('칸 이름 아래에서 고정(캐릭터의 고정 프롬프트)과 이번만(이번 생성 기록)을 골라요. 태그를 누르면 ✕로 지울 수 있어요.',
                style: AppTextStyles.caption.copyWith(color: c.muted)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () => _split(context, ref, typed.text, parsed.value!, v, targets.value),
                child: const Text('고정 / 이번만 나눠서 저장'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _split(BuildContext context, WidgetRef ref, String text, ParsedPrompt parsed, _Parts v, Map<String, String> targets) async {
    try {
      final known = {for (final l in await ref.read(genLoraListProvider.future)) l.name.toLowerCase()};
      final split = splitPromptTags(_shared(v.tags), targets: targets);
      final negFixed = targets['negative'] == 'fixed';
      final fixedLoras = targets['loras'] == 'fixed' ? [for (final l in v.loras) if (known.contains(l.name.toLowerCase())) l] : <GenLoraUse>[];
      final scene = _Parts(_gen(split.scene), negFixed ? const [] : v.negative, [for (final l in v.loras) if (!fixedLoras.contains(l)) l]);
      if (!context.mounted) return;

      final choice = await showDialog<({int? presetId, String name, bool record})>(
        context: context,
        builder: (_) => _SplitDialog(presets: presets, fixed: split.fixed, fixedNegative: negFixed ? v.negative : const [], fixedLoras: fixedLoras, scene: scene),
      );
      if (choice == null) return;

      final p = presets.where((x) => x.id == choice.presetId).firstOrNull;
      final draft = p == null
          ? GenPresetDraft(
              name: choice.name.trim().isEmpty ? '새 고정 프롬프트' : choice.name.trim(),
              tags: _gen(split.fixed),
              negative: negFixed ? v.negative : const [],
              loras: fixedLoras,
            )
          : GenPresetDraft.fromPreset(p).copyWith(
              tags: _gen(mergePromptTags(_shared(p.tags), split.fixed)),
              negative: negFixed ? addNegativeTags(p.negative, v.negative) : p.negative,
              loras: [...p.loras, for (final l in fixedLoras) if (!p.loras.any((x) => x.name.toLowerCase() == l.name.toLowerCase())) l],
            );
      final saved = await ref.read(genActionsProvider).savePreset(characterId, p?.id, draft);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(p == null ? "고정 프롬프트 '${saved.name}'를 만들었어요" : "고정 프롬프트 '${p.name}'에 넣었어요")));
      if (!choice.record) return;

      final fresh = await ref.read(characterGenProvider(characterId).future);
      final size = parsed.size;
      if (!context.mounted) return;
      await GenRecordEditPage.open(
        context,
        characterId: characterId,
        presets: fresh.presets,
        initialDraft: GenRecordDraft(
          promptRaw: text,
          platform: parsed.platform,
          model: parsed.model,
          genPresetId: saved.id,
          tags: scene.tags,
          negative: scene.negative,
          loras: scene.loras,
          seed: parsed.seed,
          sampler: parsed.sampler,
          steps: parsed.steps,
          cfgScale: parsed.cfgScale,
          width: size?.$1,
          height: size?.$2,
        ),
      );
    } catch (e) {
      if (context.mounted) showAppErrorToast(context, e);
    }
  }
}

/// 넣기 전에 확인: 어느 고정 프롬프트에 무엇이 추가되는지(이미 있는 건 건너뜀), 생성 기록엔 무엇이 가는지
class _SplitDialog extends HookWidget {
  const _SplitDialog({required this.presets, required this.fixed, required this.fixedNegative, required this.fixedLoras, required this.scene});
  final List<GenPreset> presets;
  final Map<String, List<PromptTag>> fixed;
  final List<String> fixedNegative;
  final List<GenLoraUse> fixedLoras;
  final _Parts scene;

  @override
  Widget build(BuildContext context) {
    final presetId = useState<int?>(presets.firstOrNull?.id);
    final name = useTextEditingController(text: presets.isEmpty ? '기본 외형' : '');
    final record = useState(true);
    final c = context.colors;
    final p = presets.where((x) => x.id == presetId.value).firstOrNull;

    final addTags = _gen(newPromptTags(p == null ? const {} : _shared(p.tags), fixed));
    final addNeg = p == null ? fixedNegative : addNegativeTags(p.negative, fixedNegative).sublist(p.negative.length);
    final addLoras = [for (final l in fixedLoras) if (p == null || !p.loras.any((x) => x.name.toLowerCase() == l.name.toLowerCase())) l];
    final adds = _Parts(addTags, addNeg, addLoras);
    final count = adds.tags.values.fold(0, (a, b) => a + b.length) + addNeg.length + addLoras.length;
    final skipped = fixed.values.fold(0, (a, b) => a + b.length) - adds.tags.values.fold(0, (a, b) => a + b.length) + fixedNegative.length - addNeg.length;
    final sceneCount = scene.tags.values.fold(0, (a, b) => a + b.length) + scene.negative.length + scene.loras.length;

    Widget box(String title, Widget child) => Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          decoration: BoxDecoration(border: Border.all(color: c.line), borderRadius: BorderRadius.circular(10)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            child,
          ]),
        );

    return AlertDialog(
      title: const Text('고정 / 이번만 나눠서 저장'),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<int?>(
                initialValue: presetId.value,
                decoration: const InputDecoration(labelText: '고정 프롬프트'),
                items: [
                  for (final x in presets) DropdownMenuItem(value: x.id, child: Text(x.name)),
                  const DropdownMenuItem(value: null, child: Text('+ 새 고정 프롬프트')),
                ],
                onChanged: (v) => presetId.value = v,
              ),
              if (p == null) TextField(controller: name, maxLength: 60, decoration: const InputDecoration(labelText: '새 고정 프롬프트 이름')),
              box(
                p == null ? '새 고정 프롬프트에 들어가요 · $count개' : "고정 프롬프트 '${p.name}'에 추가돼요 · $count개",
                Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  if (count == 0) Text('새로 추가할 태그가 없어요', style: TextStyle(color: c.muted, fontSize: 12)) else PromptRows(adds),
                  if (skipped > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 6),
                      child: Text('이미 들어 있는 $skipped개는 건너뛰어요', style: TextStyle(color: c.muted, fontSize: 12)),
                    ),
                ]),
              ),
              box(
                '이번 생성 기록에 들어가요 · $sceneCount개',
                sceneCount == 0 ? Text('장면 태그가 없어요', style: TextStyle(color: c.muted, fontSize: 12)) : PromptRows(scene),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: record.value,
                onChanged: (v) => record.value = v ?? false,
                title: const Text('이번 생성 기록도 저장 (다음 화면에서 제목·이미지 확인)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
        FilledButton(
          onPressed: () => Navigator.pop(context, (presetId: presetId.value, name: name.text, record: record.value)),
          child: const Text('확인하고 저장'),
        ),
      ],
    );
  }
}
