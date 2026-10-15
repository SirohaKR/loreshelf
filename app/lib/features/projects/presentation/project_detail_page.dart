// 프로젝트 상세 — 머리말 + 장르 태그 + 소개 + 캐릭터(전용 / 서재에서 연결)
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/empty_note.dart';
import '../../../core/widgets/markdown_text.dart';
import '../../../core/widgets/section_card.dart';
import '../../characters/presentation/character_detail_page.dart';
import '../../characters/presentation/character_edit_page.dart';
import '../../characters/presentation/widgets/character_card.dart';
import '../domain/project.dart';
import 'project_detail_provider.dart';
import 'project_edit_page.dart';
import 'project_edit_provider.dart';
import 'widgets/genre_groups.dart';
import 'widgets/library_link_dialog.dart';
import 'widgets/project_header.dart';

class ProjectDetailPage extends ConsumerWidget {
  const ProjectDetailPage({super.key, required this.id});
  final int id;

  static Future<void> open(BuildContext context, int id) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ProjectDetailPage(id: id)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(projectDetailProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: Text(detail.value?.name ?? '프로젝트'),
        actions: [
          if (detail.value != null) ...[
            IconButton(tooltip: '편집', icon: const Icon(Icons.edit_outlined), onPressed: () => ProjectEditPage.open(context, id: id)),
            IconButton(
              tooltip: '휴지통으로',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _trash(context, ref, detail.value!),
            ),
          ],
        ],
      ),
      body: AsyncValueView(
        value: detail,
        onRetry: () => ref.invalidate(projectDetailProvider(id)),
        builder: (p) => RefreshIndicator(
          onRefresh: () => refreshOrToast(context, () => ref.refresh(projectDetailProvider(id).future)),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.page),
                sliver: SliverToBoxAdapter(child: ProjectHeader(p)),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                sliver: SliverToBoxAdapter(
                  child: LayoutBuilder(
                    builder: (context, box) {
                      final genres = SectionCard(title: '장르·세계관 태그', child: GenreGroups(p.genres));
                      final about = SectionCard(
                        title: '소개',
                        child: (p.bodyMd ?? '').trim().isEmpty ? const EmptyNote('아직 소개 글이 없어요') : MarkdownText(p.bodyMd!),
                      );
                      return box.maxWidth >= 760
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Expanded(child: genres), const SizedBox(width: 18), Expanded(child: about)],
                            )
                          : Column(children: [genres, const SizedBox(height: 18), about]);
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '캐릭터 ${p.characters.length}  ·  전용 ${p.ownCount} · 연결 ${p.characters.length - p.ownCount}',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _link(context, ref, p),
                            icon: const Icon(Icons.swap_horiz, size: 18),
                            label: const Text('서재에서 연결'),
                          ),
                          FilledButton.icon(
                            onPressed: () async {
                              final made = await CharacterEditPage.open(context, projectId: p.id);
                              if (made != null && context.mounted) await CharacterDetailPage.open(context, made.id);
                            },
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('이 프로젝트에 새 캐릭터'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, 14, AppSpacing.page, AppSpacing.page),
                sliver: p.characters.isEmpty
                    ? const SliverToBoxAdapter(child: EmptyNote('아직 캐릭터가 없어요. 전용으로 새로 만들거나, 서재 캐릭터를 연결하세요.'))
                    // 전용 캐릭터는 '전용', 서재에서 연결한 캐릭터는 역할(없으면 '연결') 꼬리표
                    : CharacterSliverGrid(p.characters, badgeOf: (c) => c.membership == 'own' ? '전용' : (c.role ?? '연결')),
              ),
              if (p.characters.any((c) => c.membership != 'own'))
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, AppSpacing.page),
                  sliver: SliverToBoxAdapter(
                    child: SectionCard(
                      title: '연결된 서재 캐릭터',
                      child: _LinkedList(project: p),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _trash(BuildContext context, WidgetRef ref, ProjectDetail p) async {
    final own = p.ownCount;
    final ok = await showConfirmationDialog(
      context,
      title: "'${p.name}'을(를) 휴지통으로 옮길까요?",
      message: own > 0 ? '이 프로젝트 전용 캐릭터 $own명도 같이 숨겨져요 (되살리면 돌아와요).' : null,
      confirmLabel: '휴지통으로',
    );
    if (!ok || !context.mounted) return;
    try {
      await ref.read(projectActionsProvider).delete(p.id);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) showAppErrorToast(context, e);
    }
  }

  Future<void> _link(BuildContext context, WidgetRef ref, ProjectDetail p) async {
    final picked = await showLibraryLinkDialog(context, alreadyIn: {for (final c in p.characters) c.id});
    if (picked == null || !context.mounted) return;
    try {
      await ref.read(projectActionsProvider).linkCharacter(p.id, picked.characterId, role: picked.role);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('연결했어요')));
    } catch (e) {
      if (context.mounted) showAppErrorToast(context, e);
    }
  }
}

/// 연결된(서재) 캐릭터 줄 — 이름 · 역할, 역할 고치기 · 연결 끊기
class _LinkedList extends ConsumerWidget {
  const _LinkedList({required this.project});
  final ProjectDetail project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linked = project.characters.where((c) => c.membership != 'own').toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final c in linked) ...[
          if (c != linked.first) const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => CharacterDetailPage.open(context, c.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text(c.role?.isNotEmpty == true ? c.role! : '역할 없음', style: TextStyle(color: context.colors.muted, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(onPressed: () => _editRole(context, ref, c.id, c.role), child: const Text('역할')),
                TextButton(
                  onPressed: () => _unlink(context, ref, c.id),
                  style: TextButton.styleFrom(foregroundColor: context.colors.danger),
                  child: const Text('연결 끊기'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _editRole(BuildContext context, WidgetRef ref, int characterId, String? current) async {
    final ctl = TextEditingController(text: current ?? '');
    final role = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('역할', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctl,
          autofocus: true,
          maxLength: 30,
          decoration: const InputDecoration(hintText: '주인공, NPC, 보스 …'),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          FilledButton(onPressed: () => Navigator.pop(context, ctl.text), child: const Text('저장')),
        ],
      ),
    );
    if (role == null || !context.mounted) return;
    try {
      await ref.read(projectActionsProvider).linkCharacter(project.id, characterId, role: role.trim().isEmpty ? null : role.trim());
    } catch (e) {
      if (context.mounted) showAppErrorToast(context, e);
    }
  }

  Future<void> _unlink(BuildContext context, WidgetRef ref, int characterId) async {
    try {
      await ref.read(projectActionsProvider).unlinkCharacter(project.id, characterId);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('연결을 끊었어요')));
    } catch (e) {
      if (context.mounted) showAppErrorToast(context, e);
    }
  }
}
