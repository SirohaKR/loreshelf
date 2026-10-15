// 프로젝트 목록 — 카드 격자 (화면이 넓을수록 열이 늘어남)
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_note.dart';
import 'project_detail_page.dart';
import 'project_edit_page.dart';
import 'project_list_provider.dart';
import 'widgets/project_card.dart';

class ProjectListPage extends ConsumerWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectListProvider);
    return RefreshIndicator(
      onRefresh: () => refreshOrToast(context, () => ref.refresh(projectListProvider.future)),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.page, AppSpacing.page, 18),
            sliver: SliverToBoxAdapter(
              child: Wrap(spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.end, children: [
                const Text('프로젝트', style: AppTextStyles.pageTitle),
                FilledButton.icon(
                  onPressed: () async {
                    final made = await ProjectEditPage.open(context);
                    if (made != null && context.mounted) await ProjectDetailPage.open(context, made.id);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('새 프로젝트'),
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, AppSpacing.page),
            sliver: AsyncSliverView(
              value: projects,
              onRetry: () => ref.invalidate(projectListProvider),
              sliver: (list) => list.isEmpty
                  ? const SliverToBoxAdapter(child: EmptyNote('아직 프로젝트가 없어요'))
                  : SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 420,
                        mainAxisSpacing: AppSpacing.grid,
                        crossAxisSpacing: AppSpacing.grid,
                        mainAxisExtent: 196,
                      ),
                      itemCount: list.length,
                      itemBuilder: (_, i) => ProjectCard(list[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
