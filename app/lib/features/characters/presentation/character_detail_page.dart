// 캐릭터 상세 — 위쪽 소개(CharacterHero) + 탭(프로필 / 갤러리 / 이미지·프롬프트)
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../gen/presentation/widgets/character_gen_tab.dart';
import 'character_detail_provider.dart';
import 'character_edit_page.dart';
import 'character_edit_provider.dart';
import '../../projects/presentation/project_list_provider.dart';
import '../domain/character.dart';
import '../../../core/widgets/confirmation_dialog.dart';
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
    final tabs = useTabController(initialLength: 3);
    useListenable(tabs);

    return Scaffold(
      appBar: AppBar(
        title: Text(detail.value?.name ?? '캐릭터'),
        actions: [
          if (detail.value != null) ...[
            IconButton(
              tooltip: detail.value!.isFavorite ? '즐겨찾기 빼기' : '즐겨찾기',
              icon: Icon(detail.value!.isFavorite ? Icons.star : Icons.star_border),
              onPressed: () => _act(context, () => ref.read(characterActionsProvider).setFavorite(id, !detail.value!.isFavorite)),
            ),
            IconButton(
              tooltip: '편집',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => CharacterEditPage.open(context, id: id),
            ),
            _MoreMenu(detail.value!),
          ],
        ],
      ),
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
                    tabs: [const Tab(text: '프로필'), Tab(text: '갤러리 ${ch.gallery.length}'), const Tab(text: '이미지·프롬프트')],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, AppSpacing.page),
                sliver: switch (tabs.index) {
                  0 => SliverToBoxAdapter(child: CharacterProfile(ch)),
                  1 => CharacterGallery(ch),
                  _ => SliverToBoxAdapter(child: CharacterGenTab(ch.id)),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 버튼 동작을 하고, 실패하면 아래에 알림
Future<void> _act(BuildContext context, Future<void> Function() work, {String? done}) async {
  try {
    await work();
    if (done != null && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
  } catch (e) {
    if (context.mounted) showAppErrorToast(context, e);
  }
}

/// ⋮ 메뉴 — 서재로 꺼내기 / 프로젝트로 옮기기 / 분기 / 휴지통으로 (웹 캐릭터 화면과 같은 일)
class _MoreMenu extends ConsumerWidget {
  const _MoreMenu(this.ch);
  final CharacterDetail ch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(characterActionsProvider);

    /// 프로젝트 고르기 창. [library]면 맨 위에 "공용 서재"도. 고르면 (프로젝트 번호 또는 null)을 담은 record
    Future<({int? id})?> pickPlace(String title, {required bool library}) async {
      final projects = await ref.read(projectListProvider.future);
      if (!context.mounted) return null;
      return showDialog<({int? id})>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          children: [
            if (library) SimpleDialogOption(onPressed: () => Navigator.pop(context, (id: null)), child: const Text('공용 서재')),
            for (final p in projects)
              if (p.id != ch.projectId)
                SimpleDialogOption(onPressed: () => Navigator.pop(context, (id: p.id)), child: Text('${p.name} 전용')),
          ],
        ),
      );
    }

    return PopupMenuButton<String>(
      tooltip: '더 보기',
      onSelected: (v) async {
        switch (v) {
          case 'library':
            await _act(context, () => actions.move(ch.id, null), done: '공용 서재로 꺼냈어요');
          case 'move':
            final to = await pickPlace('어느 프로젝트 전용으로 옮길까요?', library: false);
            if (to != null && context.mounted) await _act(context, () => actions.move(ch.id, to.id), done: '옮겼어요');
          case 'fork':
            final to = await pickPlace('복사본을 어디에 둘까요?', library: true);
            if (to == null || !context.mounted) return;
            try {
              final copy = await actions.fork(ch.id, to.id);
              if (context.mounted) await CharacterDetailPage.open(context, copy.id);
            } catch (e) {
              if (context.mounted) showAppErrorToast(context, e);
            }
          case 'trash':
            final ok = await showConfirmationDialog(context,
                title: '${ch.name}을(를) 휴지통으로 옮길까요?', message: '휴지통에서 되살릴 수 있어요.', confirmLabel: '휴지통으로');
            if (!ok || !context.mounted) return;
            await _act(context, () async {
              await actions.delete(ch.id);
              if (context.mounted) Navigator.pop(context); // 지운 캐릭터 화면은 닫는다 (실패하면 그대로)
            });
        }
      },
      itemBuilder: (_) => [
        if (!ch.inLibrary) const PopupMenuItem(value: 'library', child: Text('공용 서재로 꺼내기')),
        const PopupMenuItem(value: 'move', child: Text('프로젝트 전용으로 옮기기')),
        const PopupMenuItem(value: 'fork', child: Text('분기 (복사본 만들기)')),
        const PopupMenuItem(value: 'trash', child: Text('휴지통으로')),
      ],
    );
  }
}
