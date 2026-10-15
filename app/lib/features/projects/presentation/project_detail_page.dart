// 프로젝트 상세 — 머리말 + 장르 태그 + 소개 + 캐릭터(전용 / 서재에서 연결)
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_note.dart';
import '../../../core/widgets/markdown_text.dart';
import '../../../core/widgets/section_card.dart';
import '../../characters/presentation/widgets/character_card.dart';
import 'project_detail_provider.dart';
import 'project_edit_page.dart';
import 'widgets/genre_groups.dart';
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
          if (detail.value != null)
            IconButton(tooltip: '편집', icon: const Icon(Icons.edit_outlined), onPressed: () => ProjectEditPage.open(context, id: id)),
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
                  child: SectionHeader(
                    '캐릭터 ${p.characters.length}  ·  전용 ${p.ownCount} · 연결 ${p.characters.length - p.ownCount}',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, AppSpacing.page),
                sliver: p.characters.isEmpty
                    ? const SliverToBoxAdapter(child: EmptyNote('이 프로젝트에 캐릭터가 없어요'))
                    // 전용 캐릭터는 '전용', 서재에서 연결한 캐릭터는 역할(없으면 '연결') 꼬리표
                    : CharacterSliverGrid(p.characters, badgeOf: (c) => c.membership == 'own' ? '전용' : (c.role ?? '연결')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
