// 휴지통 — 지운 캐릭터·세계관·프로젝트를 되살리거나 영구 삭제 (웹 trash.js와 같은 일)
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/time_ago.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/empty_note.dart';
import '../../../core/widgets/section_card.dart';
import '../domain/trash_entry.dart';
import 'trash_provider.dart';

class TrashPage extends ConsumerWidget {
  const TrashPage({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TrashPage()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trash = ref.watch(trashProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('휴지통')),
      body: AsyncValueView(
        value: trash,
        onRetry: () => ref.invalidate(trashProvider),
        builder: (t) => RefreshIndicator(
          onRefresh: () => refreshOrToast(context, () => ref.refresh(trashProvider.future)),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.page),
            children: [
              const Text('지운 것을 되살리거나 영구 삭제해요. 영구 삭제는 되돌릴 수 없어요.', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 16),
              if (t.total == 0) const EmptyNote('휴지통이 비어 있어요'),
              for (final kind in TrashKind.values)
                if (t.of(kind).isNotEmpty) ...[
                  SectionCard(title: '${kind.label} ${t.of(kind).length}', child: _TrashSection(kind: kind, entries: t.of(kind))),
                  const SizedBox(height: 16),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrashSection extends ConsumerWidget {
  const _TrashSection({required this.kind, required this.entries});
  final TrashKind kind;
  final List<TrashEntry> entries;

  String _note(TrashEntry e) {
    if (kind == TrashKind.characters && (e.projectName ?? '').isNotEmpty) return ' · ${e.projectName} 전용';
    if (kind == TrashKind.projects && e.ownCharacterCount > 0) return ' · 전용 캐릭터 ${e.ownCharacterCount}명';
    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(trashActionsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final e in entries) ...[
          if (e != entries.first) const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('${timeAgo(e.deletedAt)} 지움${_note(e)}', style: TextStyle(color: context.colors.muted, fontSize: 13)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _act(context, () => actions.restore(kind, e.id), done: '되살렸어요'),
                  child: const Text('되살리기'),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: context.colors.danger),
                  onPressed: () => _purge(context, actions, e),
                  child: const Text('영구 삭제'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _purge(BuildContext context, TrashActions actions, TrashEntry e) async {
    final ownNote = kind == TrashKind.projects && e.ownCharacterCount > 0
        ? '\n이 프로젝트 전용 캐릭터 ${e.ownCharacterCount}명도 같이 영구 삭제돼요. 남기고 싶으면 먼저 되살려서 서재로 꺼내 주세요.'
        : '';
    final ok = await showConfirmationDialog(
      context,
      title: '영구 삭제',
      message: "'${e.name}'을(를) 영구 삭제할까요? 되돌릴 수 없어요.$ownNote",
      confirmLabel: '영구 삭제',
    );
    if (!ok || !context.mounted) return;
    await _act(context, () => actions.purge(kind, e.id), done: '영구 삭제했어요');
  }

  Future<void> _act(BuildContext context, Future<void> Function() work, {required String done}) async {
    try {
      await work();
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      if (context.mounted) showAppErrorToast(context, e);
    }
  }
}
