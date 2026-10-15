// 생성 기록 만들기 · 고치기 — 제목·플랫폼·모델·고정 프롬프트 연결, 프롬프트 붙여넣어 분류, 설정 칸, 이미지, ★ 대표
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/pick_image.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/section_card.dart';
import '../domain/gen.dart';
import '../domain/gen_draft.dart';
import 'character_gen_edit_provider.dart';
import 'widgets/character_gen_tab.dart' show PromptRows;
import 'widgets/lora_editor.dart';
import 'widgets/prompt_paste_classifier.dart';

class GenRecordEditPage extends HookConsumerWidget {
  const GenRecordEditPage({super.key, required this.characterId, required this.presets, this.record, this.initialDraft});
  final int characterId;
  final List<GenPreset> presets;

  /// 고치기일 때
  final GenRecord? record;

  /// PNG 가져오기로 미리 채워서 새로 만들 때
  final GenRecordDraft? initialDraft;

  static Future<GenRecord?> open(
    BuildContext context, {
    required int characterId,
    required List<GenPreset> presets,
    GenRecord? record,
    GenRecordDraft? initialDraft,
  }) =>
      Navigator.of(context).push(MaterialPageRoute<GenRecord>(
        builder: (_) => GenRecordEditPage(characterId: characterId, presets: presets, record: record, initialDraft: initialDraft),
      ));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = useState(record != null ? GenRecordDraft.fromRecord(record!) : (initialDraft ?? GenRecordDraft.empty()));
    final d = draft.value;
    final error = useState<String?>(null);
    final uploading = useState(false);
    final saver = ref.watch(genRecordSaverProvider);
    final api = ref.watch(apiClientProvider);
    final c = context.colors;

    void set(GenRecordDraft Function(GenRecordDraft) change) => draft.value = change(draft.value);

    Future<void> pickRecordImage() async {
      final picked = await pickImage();
      if (picked == null) return;
      uploading.value = true;
      try {
        final assetId = await ref.read(genActionsProvider).upload(picked.bytes, picked.name);
        set((x) => x.copyWith(assetId: assetId));
      } catch (e) {
        if (context.mounted) showAppErrorToast(context, e);
      } finally {
        if (context.mounted) uploading.value = false;
      }
    }

    Future<void> save() async {
      final saved = await ref.read(genRecordSaverProvider.notifier).save(characterId, record?.id, draft.value);
      if (saved != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(record == null ? '생성 기록을 만들었어요' : '저장했어요')));
        Navigator.pop(context, saved);
      }
    }

    Future<void> delete() async {
      final ok = await showConfirmationDialog(context, title: '이 생성 기록을 지울까요?', message: '되돌릴 수 없어요.', confirmLabel: '지우기');
      if (!ok || !context.mounted) return;
      try {
        await ref.read(genActionsProvider).deleteRecord(characterId, record!.id);
        if (context.mounted) Navigator.pop(context);
      } catch (e) {
        if (context.mounted) showAppErrorToast(context, e);
      }
    }

    final err = error.value ?? (saver.hasError ? '${saver.error}' : null);

    return Scaffold(
      appBar: AppBar(
        title: Text(record == null ? '새 생성 기록' : '생성 기록 편집'),
        actions: [if (record != null) IconButton(tooltip: '지우기', icon: const Icon(Icons.delete_outline), onPressed: delete)],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 84,
                        height: 112,
                        color: c.surface2,
                        child: d.assetId == null
                            ? const Icon(Icons.image_outlined)
                            : Image.network(api.assetUrl(d.assetId!), headers: api.imageHeaders, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: uploading.value ? null : pickRecordImage,
                            icon: uploading.value
                                ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.upload, size: 18),
                            label: Text(d.assetId == null ? '이미지 고르기' : '이미지 바꾸기'),
                          ),
                          if (d.assetId != null)
                            TextButton(onPressed: () => set((x) => x.copyWith(assetId: null)), child: const Text('빼기')),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: d.title,
                  maxLength: 120,
                  decoration: const InputDecoration(labelText: '제목'),
                  onChanged: (v) => set((x) => x.copyWith(title: v)),
                ),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: d.platform,
                      maxLength: 60,
                      decoration: const InputDecoration(labelText: '플랫폼', hintText: 'Stable Diffusion WebUI'),
                      onChanged: (v) => set((x) => x.copyWith(platform: v)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: d.model,
                      maxLength: 120,
                      decoration: const InputDecoration(labelText: '모델'),
                      onChanged: (v) => set((x) => x.copyWith(model: v)),
                    ),
                  ),
                ]),
                if (presets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: DropdownButtonFormField<int?>(
                      initialValue: presets.any((p) => p.id == d.genPresetId) ? d.genPresetId : null,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: '고정 프롬프트 연결 (선택)'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('없음')),
                        for (final p in presets) DropdownMenuItem(value: p.id, child: Text(p.name)),
                      ],
                      onChanged: (v) => set((x) => x.copyWith(genPresetId: v)),
                    ),
                  ),
                const SizedBox(height: 8),
                SectionCard(
                  title: '프롬프트 붙여넣기',
                  child: PromptPasteClassifier(
                    initialText: d.promptRaw,
                    onClassified: (r) => set((x) => x.copyWith(promptRaw: r.text, tags: r.tags, negative: r.negative, loras: r.loras)),
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
                  child: LoraEditor(loras: d.loras, allowUnknown: true, onChanged: (v) => set((x) => x.copyWith(loras: v))),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: '설정',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: d.seed?.toString() ?? '',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: '시드'),
                            onChanged: (v) => set((x) => x.copyWith(seed: int.tryParse(v.trim()))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: d.sampler,
                            decoration: const InputDecoration(labelText: '샘플러'),
                            onChanged: (v) => set((x) => x.copyWith(sampler: v)),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: d.steps?.toString() ?? '',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: '스텝'),
                            onChanged: (v) => set((x) => x.copyWith(steps: int.tryParse(v.trim()))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: d.cfgScale?.toString() ?? '',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'CFG'),
                            onChanged: (v) => set((x) => x.copyWith(cfgScale: double.tryParse(v.trim()))),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: d.width?.toString() ?? '',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: '가로'),
                            onChanged: (v) => set((x) => x.copyWith(width: int.tryParse(v.trim()))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: d.height?.toString() ?? '',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: '세로'),
                            onChanged: (v) => set((x) => x.copyWith(height: int.tryParse(v.trim()))),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: d.note,
                  minLines: 2,
                  maxLines: 6,
                  maxLength: 5000,
                  decoration: const InputDecoration(labelText: '메모'),
                  onChanged: (v) => set((x) => x.copyWith(note: v)),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('★ 대표로'),
                  value: d.isCover,
                  onChanged: (v) => set((x) => x.copyWith(isCover: v ?? false)),
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
                      onPressed: saver.isLoading || uploading.value ? null : save,
                      child: Text(saver.isLoading ? '저장 중…' : (record == null ? '만들기' : '저장')),
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
