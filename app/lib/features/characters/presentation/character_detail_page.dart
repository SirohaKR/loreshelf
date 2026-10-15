// 캐릭터 상세 — 위쪽 소개(CharacterHero) + 탭(프로필 / 갤러리)
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import 'character_detail_provider.dart';
import 'widgets/character_gallery.dart';
import 'widgets/character_hero.dart';
import 'widgets/character_profile.dart';

class CharacterDetailPage extends HookConsumerWidget {
  const CharacterDetailPage({super.key, required this.id});
  final int id;

  static Future<void> open(BuildContext context, int id) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => CharacterDetailPage(id: id)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(characterDetailProvider(id));
    // TabController도 훅으로: vsync(애니메이션 시계)·dispose를 훅이 챙긴다.
    // useListenable로 탭이 바뀔 때 다시 그려서, 아래 내용을 탭에 맞게 바꾼다.
    final tabs = useTabController(initialLength: 2);
    useListenable(tabs);

    return Scaffold(
      appBar: AppBar(title: Text(detail.value?.name ?? '캐릭터')),
      body: AsyncValueView(
        value: detail,
        onRetry: () => ref.invalidate(characterDetailProvider(id)),
        builder: (ch) => RefreshIndicator(
          onRefresh: () => refreshOrToast(context, () => ref.refresh(characterDetailProvider(id).future)),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.page, AppSpacing.page, 0),
                sliver: SliverToBoxAdapter(child: CharacterHero(ch)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, 20, AppSpacing.page, 20),
                sliver: SliverToBoxAdapter(
                  child: TabBar(
                    controller: tabs,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: [const Tab(text: '프로필'), Tab(text: '갤러리 ${ch.gallery.length}')],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, AppSpacing.page),
                sliver: tabs.index == 0 ? SliverToBoxAdapter(child: CharacterProfile(ch)) : CharacterGallery(ch),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
