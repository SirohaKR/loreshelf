// 캐릭터 상세의 "이미지·프롬프트" 탭 (보기 전용) — 고정 프롬프트 줄별 복사 + 생성 기록 목록
// 웹 작업실의 같은 탭에서 만들고 고친 것을 보여 준다.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_note.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/gen.dart';
import '../character_gen_provider.dart';

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
          _PresetCard(g.presets),
          const SizedBox(height: 16),
          SectionCard(
            title: '생성 기록 ${g.records.length}',
            child: g.records.isEmpty
                ? const EmptyNote('아직 기록이 없어요. 웹 작업실에서 PNG를 끌어다 놓으면 생성 정보를 읽어서 기록해요')
                : Column(children: [for (final r in g.records) _RecordRow(r)]),
          ),
        ],
      ),
    );
  }
}

class _PresetCard extends HookWidget {
  const _PresetCard(this.presets);
  final List<GenPreset> presets;

  @override
  Widget build(BuildContext context) {
    final selected = useState(0);
    final novelai = useState(false);
    if (presets.isEmpty) {
      return const SectionCard(title: '고정 프롬프트', child: EmptyNote('고정 프롬프트가 없어요. 웹 작업실에서 의상별로 만들 수 있어요'));
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
  const _RecordRow(this.r);
  final GenRecord r;

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
      onTap: () => _openDetail(context, r),
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

  void _openDetail(BuildContext context, GenRecord r) {
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
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _copy(context, r.promptText(), '프롬프트를 복사했어요'),
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('프롬프트 복사'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
