// 홈 — 인사, 숫자 요약 4칸, 최근 수정한 캐릭터, 프로젝트
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_note.dart';
import '../../../core/widgets/section_card.dart';
import '../../characters/presentation/widgets/character_card.dart';
import '../../projects/presentation/widgets/project_row.dart';
import '../domain/home_summary.dart';
import 'home_provider.dart';
import 'widgets/home_greeting.dart';
import 'widgets/home_stats.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.onOpenTab});

  /// '모두 보기'를 누르면 캐릭터(1)·프로젝트(2) 탭으로
  final void Function(int tab) onOpenTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeSummaryProvider);
    return AsyncValueView(
      value: home,
      onRetry: () => ref.invalidate(homeSummaryProvider),
      builder: (data) => RefreshIndicator(
        onRefresh: () => refreshOrToast(context, () => ref.refresh(homeSummaryProvider.future)),
        child: LayoutBuilder(builder: (context, box) => _body(data, wide: box.maxWidth >= 1000)),
      ),
    );
  }

  Widget _body(HomeSummary data, {required bool wide}) {
    final recentHead = SectionHeader('최근 수정한 캐릭터', action: '모두 보기', onAction: () => onOpenTab(1));
    final recent = data.recentCharacters.isEmpty
        ? const EmptyNote('아직 캐릭터가 없어요')
        : CharacterGrid(data.recentCharacters);
    final projects = SectionCard(
      title: '프로젝트',
      trailing: TextLink('모두 보기', onTap: () => onOpenTab(2)),
      child: data.projects.isEmpty
          ? const EmptyNote('아직 프로젝트가 없어요')
          : Column(children: [for (final p in data.projects) ProjectRow(p)]),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.page),
      children: [
        HomeGreeting(name: data.user?.displayName ?? ''),
        const SizedBox(height: 18),
        HomeStats(data.counts),
        if (wide)
          // 넓으면 왼쪽 캐릭터 격자 + 오른쪽 340px 프로젝트 (CSS .home-layout)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [recentHead, recent])),
              const SizedBox(width: AppSpacing.page),
              SizedBox(width: 340, child: Padding(padding: const EdgeInsets.only(top: AppSpacing.section), child: projects)),
            ],
          )
        else ...[
          recentHead,
          recent,
          const SizedBox(height: AppSpacing.page),
          projects,
        ],
      ],
    );
  }
}
