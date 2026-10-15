// 쓴 LoRA 칩 + 추가 — 사전에서 고르고 무게를 정한다 (고정 프롬프트는 사전에 없는 이름은 저장 때 빠짐)
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/gen.dart';
import '../character_gen_edit_provider.dart';

class LoraEditor extends ConsumerWidget {
  const LoraEditor({super.key, required this.loras, required this.onChanged, this.allowUnknown = false});
  final List<GenLoraUse> loras;
  final ValueChanged<List<GenLoraUse>> onChanged;

  /// 생성 기록은 사전에 없는 이름도 그대로 저장되지만(allowUnknown), 고정 프롬프트는 서버가 사전에 없으면 빼 버린다
  final bool allowUnknown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(genLoraListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (loras.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final (i, l) in loras.indexed)
                  InputChip(
                    label: Text('${l.name} · ${l.weight}'),
                    onDeleted: () => onChanged([...loras]..removeAt(i)),
                    deleteButtonTooltipMessage: '빼기',
                  ),
              ],
            ),
          ),
        OutlinedButton.icon(
          onPressed: () async {
            final added = await _pickLora(context, catalog.value ?? const [], allowUnknown: allowUnknown);
            if (added != null) onChanged([...loras, added]);
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('LoRA 추가'),
        ),
        if (!allowUnknown)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('고정 프롬프트는 "생성 도구"에 등록된 LoRA만 저장돼요', style: TextStyle(fontSize: 12, color: context.colors.muted)),
          ),
      ],
    );
  }

  Future<GenLoraUse?> _pickLora(BuildContext context, List<GenLora> catalog, {required bool allowUnknown}) {
    return showDialog<GenLoraUse>(
      context: context,
      builder: (context) => _LoraPickDialog(catalog: catalog, allowUnknown: allowUnknown),
    );
  }
}

class _LoraPickDialog extends HookWidget {
  const _LoraPickDialog({required this.catalog, required this.allowUnknown});
  final List<GenLora> catalog;
  final bool allowUnknown;

  @override
  Widget build(BuildContext context) {
    final picked = useState<GenLora?>(null);
    final customName = useTextEditingController();
    final weight = useTextEditingController(text: '1');

    return AlertDialog(
      title: const Text('LoRA 추가', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (catalog.isNotEmpty)
              DropdownButtonFormField<GenLora?>(
                initialValue: picked.value,
                isExpanded: true,
                decoration: const InputDecoration(labelText: '사전에서 고르기', isDense: true),
                items: [
                  if (allowUnknown) const DropdownMenuItem(value: null, child: Text('(직접 입력)')),
                  for (final l in catalog) DropdownMenuItem(value: l, child: Text(l.name)),
                ],
                onChanged: (v) {
                  picked.value = v;
                  if (v != null) weight.text = '${v.defaultWeight}';
                },
              ),
            if (allowUnknown && (picked.value == null || catalog.isEmpty)) ...[
              const SizedBox(height: 10),
              TextField(
                controller: customName,
                maxLength: 120,
                decoration: const InputDecoration(labelText: '이름 (프롬프트의 <lora:이름>)', isDense: true, counterText: ''),
              ),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: weight,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: const InputDecoration(labelText: '무게', isDense: true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
        FilledButton(
          onPressed: () {
            final name = picked.value?.name ?? customName.text.trim();
            if (name.isEmpty) return;
            final w = double.tryParse(weight.text.trim()) ?? 1.0;
            Navigator.pop(context, GenLoraUse(genLoraId: picked.value?.id, name: name, weight: w));
          },
          child: const Text('추가'),
        ),
      ],
    );
  }
}
