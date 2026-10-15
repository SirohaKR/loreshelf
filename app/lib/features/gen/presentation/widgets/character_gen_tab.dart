// 캐릭터 상세의 "이미지·프롬프트" 탭 — 고정 프롬프트 만들기·고치기, 생성 기록 만들기·고치기(PNG 가져오기 포함)
// 웹 작업실의 같은 탭과 같은 일을 한다.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loreshelf_shared/loreshelf_shared.dart' show isPng, readGenerationInfo;

import '../../../../core/network/api_client_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/pick_image.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_error_toast.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_note.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/gen.dart';
import '../../domain/gen_draft.dart';
import '../character_gen_edit_provider.dart';
import '../character_gen_provider.dart';
import '../gen_preset_edit_page.dart';
import '../gen_record_edit_page.dart';

/// 카테고리 표시 색 (웹 CSS와 같음)
const _categoryColor = {
  'character': Color(0xFF3F5BD8),
  'outfit': Color(0xFFD9822B),
  'expression': Color(0xFFE0A800),
  'pose': Color(0xFF7C5CD6),
  'background': Color(0xFF2F9E6B),
  'style': Color(0xFFD6487A),
  'quality': Color(0xFF6B7280),
  'etc': Color(0xFF9AA1AD),
};

Future<void> _copy(BuildContext context, String text, String done) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
}

class CharacterGenTab extends ConsumerWidget {
  const CharacterGenTab(this.characterId, {super.key});
  final int characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gen = ref.watch(characterGenProvider(characterId));
    return AsyncValueView(
      value: gen,
      onRetry: () => ref.invalidate(characterGenProvider(characterId)),
      builder: (g) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PresetCard(characterId: characterId, presets: g.presets),
          const SizedBox(height: 16),
          _RecordsSection(characterId: characterId, presets: g.presets, records: g.records),
        ],
      ),
    );
  }
}

/// 생성 기록 ~N개 + "직접 기록"·"PNG로 가져오기" 버튼 + 목록
class _RecordsSection extends ConsumerWidget {
  const _RecordsSection({required this.characterId, required this.presets, required this.records});
  final int characterId;
  final List<GenPreset> presets;
  final List<GenRecord> records;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '생성 기록 ${records.length}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final made = await GenRecordEditPage.open(context, characterId: characterId, presets: presets);
                  if (made != null && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('기록했어요')));
                },
                icon: const Icon(Icons.edit_note, size: 18),
                label: const Text('+ 직접 기록'),
              ),
              FilledButton.icon(
                onPressed: () => _importPng(context, ref),
                icon: const Icon(Icons.image_outlined, size: 18),
                label: const Text('+ PNG로 가져오기'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (records.isEmpty)
            const EmptyNote('아직 기록이 없어요. PNG를 가져오면 생성 정보를 자동으로 읽어서 기록해요')
          else
            Column(children: [for (final r in records) _RecordRow(characterId: characterId, presets: presets, record: r)]),
        ],
      ),
    );
  }

  Future<void> _importPng(BuildContext context, WidgetRef ref) async {
    final picked = await pickImage();
    if (picked == null) return;
    try {
      final learned = await ref.read(genLearnedDictionaryProvider.future);
      final assetId = await ref.read(genActionsProvider).upload(picked.bytes, picked.name);
      final info = isPng(picked.bytes) ? readGenerationInfo(picked.bytes, learned: learned) : null;
      final title = picked.name.replaceAll(RegExp(r'\.\w+$'), '');
      final draft = info == null
          ? GenRecordDraft.empty().copyWith(assetId: assetId, title: title)
          : GenRecordDraft.fromGenerationInfo(info, assetId: assetId, title: title);
      if (!context.mounted) return;
      if (info == null) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('생성 정보를 못 찾았어요 — 이미지만 기록돼요')));
      final made = await GenRecordEditPage.open(context, characterId: characterId, presets: presets, initialDraft: draft);
      if (made != null && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('기록했어요')));
    } catch (e) {
      if (context.mounted) showAppErrorToast(context, e);
    }
  }
}

class _PresetCard extends HookWidget {
  const _PresetCard({required this.characterId, required this.presets});
  final int characterId;
  final List<GenPreset> presets;

  @override
  Widget build(BuildContext context) {
    final selected = useState(0);
    final novelai = useState(false);
    final newButton = OutlinedButton.icon(
      onPressed: () => GenPresetEditPage.open(context, characterId: characterId),
      icon: const Icon(Icons.add, size: 16),
      label: const Text('새 고정 프롬프트'),
    );
    if (presets.isEmpty) {
      return SectionCard(
        title: '고정 프롬프트',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const EmptyNote('고정 프롬프트가 없어요. 의상별로 만들어 보세요'), const SizedBox(height: 8), newButton],
        ),
      );
    }
    final p = presets[selected.value.clamp(0, presets.length - 1)];
    return SectionCard(
      title: '고정 프롬프트',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final (i, x) in presets.indexed) AppChip(x.name, selected: x.id == p.id, onTap: () => selected.value = i),
          ]),
          const SizedBox(height: 8),
          PromptRows(p),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              newButton,
              OutlinedButton.icon(
                onPressed: () => GenPresetEditPage.open(context, characterId: characterId, preset: p),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('고치기'),
              ),
              SegmentedButton<bool>(
                segments: const [ButtonSegment(value: false, label: Text('SD 형식')), ButtonSegment(value: true, label: Text('NovelAI 형식'))],
                selected: {novelai.value},
                showSelectedIcon: false,
                onSelectionChanged: (s) => novelai.value = s.first,
              ),
              FilledButton.icon(
                onPressed: () => _copy(context, p.promptText(novelai: novelai.value), '${novelai.value ? 'NovelAI' : 'SD'} 형식으로 복사했어요'),
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('전체 복사'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 카테고리별 줄 + 네거티브 + LoRA (줄마다 복사 버튼)
class PromptRows extends StatelessWidget {
  const PromptRows(this.data, {super.key});
  final PromptParts data;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget row(String label, Color color, List<Widget> chips, {String? copyText}) => Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: c.line))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 96,
                child: Row(children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 6),
                  Flexible(child: Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700))),
                ]),
              ),
              Expanded(child: Wrap(spacing: 4, runSpacing: 4, children: chips)),
              if (copyText != null)
                IconButton(
                  tooltip: '$label 줄 복사',
                  visualDensity: VisualDensity.compact,
                  iconSize: 16,
                  onPressed: () => _copy(context, copyText, '$label 줄을 복사했어요'),
                  icon: const Icon(Icons.copy),
                ),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final k in data.usedCategories)
          row(promptCategoryLabels[k]!, _categoryColor[k]!, [for (final t in data.tags[k]!) _TagChip(t)], copyText: data.lineOf(k)),
        if (data.negative.isNotEmpty)
          row('네거티브', c.danger, [for (final t in data.negative) _TagChip(GenTag(tag: t), negative: true)], copyText: data.negative.join(', ')),
        if (data.loras.isNotEmpty) row('LoRA', c.ok, [for (final l in data.loras) _LoraChip(l)]),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip(this.t, {this.negative = false});
  final GenTag t;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: c.surface2, border: Border.all(color: c.line), borderRadius: BorderRadius.circular(7)),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: t.tag),
          if (t.weight != 1) TextSpan(text: ' ${t.weight}', style: TextStyle(fontSize: 10, color: c.accent, fontWeight: FontWeight.w700)),
        ]),
        style: TextStyle(
          fontSize: 12,
          decoration: negative ? TextDecoration.lineThrough : null,
          decorationColor: c.rose,
        ),
      ),
    );
  }
}

class _LoraChip extends StatelessWidget {
  const _LoraChip(this.l);
  final GenLoraUse l;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(color: c.roseSoft, borderRadius: BorderRadius.circular(5)),
      child: Text('${l.name} · ${l.weight}', style: TextStyle(fontSize: 11, color: c.rose)),
    );
  }
}

class _RecordRow extends ConsumerWidget {
  const _RecordRow({required this.characterId, required this.presets, required this.record});
  final int characterId;
  final List<GenPreset> presets;
  final GenRecord record;
  GenRecord get r => record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final api = ref.watch(apiClientProvider);
    Widget kv(String k, String v) => Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Row(children: [
            SizedBox(width: 44, child: Text(k, style: AppTextStyles.caption.copyWith(color: c.muted))),
            Expanded(child: Text(v.isEmpty ? '—' : v, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
        );
    return InkWell(
      onTap: () => _openDetail(context, ref, r),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: c.line))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.thumb),
              child: Container(
                width: 72,
                height: 96,
                color: c.surface2,
                child: Stack(fit: StackFit.expand, children: [
                  if (r.assetId != null) Image.network(api.assetUrl(r.assetId!), headers: api.imageHeaders, fit: BoxFit.cover),
                  if (r.isCover)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(6)),
                        child: Text('★ 대표', style: TextStyle(color: c.warn, fontSize: 10)),
                      ),
                    ),
                ]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.title ?? r.presetName ?? '제목 없음', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                  kv('플랫폼', r.platformName ?? ''),
                  kv('모델', r.modelName ?? ''),
                  if (r.loras.isNotEmpty) kv('LoRA', r.loras.map((l) => '${l.name} ${l.weight}').join(', ')),
                  kv('시드', r.seedLine),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, WidgetRef ref, GenRecord r) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .7,
        builder: (context, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Text(r.title ?? '제목 없음', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 6, children: [
              if (r.platformName != null) AppChip(r.platformName!),
              if (r.modelName != null) AppChip(r.modelName!),
              if (r.width != null && r.height != null) AppChip('${r.width}×${r.height}'),
              if (r.cfgScale != null) AppChip('CFG ${r.cfgScale}'),
              if (r.seedLine.isNotEmpty) AppChip(r.seedLine),
            ]),
            if (r.note != null) ...[const SizedBox(height: 10), Text(r.note!, style: AppTextStyles.bodySmall)],
            const SizedBox(height: 10),
            PromptRows(r),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                if (!r.isCover)
                  OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await ref.read(genActionsProvider).setCover(characterId, r.id);
                        if (context.mounted) Navigator.pop(context);
                      } catch (e) {
                        if (context.mounted) showAppErrorToast(context, e);
                      }
                    },
                    icon: const Icon(Icons.star_outline, size: 16),
                    label: const Text('★ 대표로'),
                  ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final ok = await showConfirmationDialog(context, title: '이 생성 기록을 지울까요?', message: '되돌릴 수 없어요.', confirmLabel: '지우기');
                    if (!ok || !context.mounted) return;
                    try {
                      await ref.read(genActionsProvider).deleteRecord(characterId, r.id);
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) showAppErrorToast(context, e);
                    }
                  },
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('지우기'),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context); // 시트를 닫고 편집 화면으로
                    await GenRecordEditPage.open(context, characterId: characterId, presets: presets, record: r);
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('고치기'),
                ),
                FilledButton.icon(
                  onPressed: () => _copy(context, r.promptText(), '프롬프트를 복사했어요'),
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('프롬프트 복사'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
