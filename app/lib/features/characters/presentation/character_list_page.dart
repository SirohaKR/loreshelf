// 캐릭터 목록 — 필터(전체 / 서재 / 프로젝트별) + 검색.
// 필터·검색어는 characterListFilterProvider에, 입력칸과 "타이핑이 멈췄나" 판단(디바운스)은 훅에.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_note.dart';
import '../../projects/presentation/project_list_provider.dart';
import '../domain/character_scope.dart';
import 'character_list_provider.dart';
import 'character_list_state.dart';
import 'widgets/character_card.dart';

class CharacterListPage extends HookConsumerWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(characterListFilterProvider);
    final filterCtl = ref.read(characterListFilterProvider.notifier);
    final characters = ref.watch(characterListProvider);
    final projects = ref.watch(projectListProvider).value ?? const [];

    // 검색어 디바운스: 입력이 300ms 멈췄을 때만 검색 (글자마다 서버에 묻지 않게).
    // useEffect(효과, [의존값]) — 의존값이 바뀔 때마다 실행, 돌려준 함수는 다음 실행 전/화면이 사라질 때 정리용.
    final search = useTextEditingController(text: filter.text);
    final typed = useValueListenable(search);
    useEffect(() {
      final timer = Timer(const Duration(milliseconds: 300), () => filterCtl.search(typed.text));
      return timer.cancel;
    }, [typed.text]);

    return RefreshIndicator(
      onRefresh: () => refreshOrToast(context, () => ref.refresh(characterListProvider.future)),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.page, AppSpacing.page, 14),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      const Text('캐릭터', style: AppTextStyles.pageTitle),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: TextField(
                          controller: search,
                          decoration: InputDecoration(
                            hintText: '이름·소개·태그 검색',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: typed.text.isEmpty
                                ? null
                                : IconButton(icon: const Icon(Icons.close, size: 18), onPressed: search.clear),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // 필터 칩: 전체 · 서재 · 프로젝트들
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      AppChip('전체',
                          selected: filter.scope is AllCharacters,
                          onTap: () => filterCtl.selectScope(const CharacterScope.all())),
                      AppChip('서재',
                          selected: filter.scope is LibraryCharacters,
                          onTap: () => filterCtl.selectScope(const CharacterScope.library())),
                      for (final p in projects)
                        AppChip(
                          p.name,
                          // freezed가 ==를 만들어 줘서 "같은 프로젝트 필터인가"를 바로 비교할 수 있다
                          selected: filter.scope == CharacterScope.project(id: p.id, name: p.name),
                          onTap: () => filterCtl.selectScope(CharacterScope.project(id: p.id, name: p.name)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, AppSpacing.page),
            sliver: AsyncSliverView(
              value: characters,
              onRetry: () => ref.invalidate(characterListProvider),
              sliver: (list) => list.isEmpty
                  ? SliverToBoxAdapter(child: EmptyNote(_emptyText(filter)))
                  : CharacterSliverGrid(list),
            ),
          ),
        ],
      ),
    );
  }

  static String _emptyText(CharacterListState filter) {
    if (filter.text.isNotEmpty) return "'${filter.text}'에 맞는 캐릭터가 없어요";
    return switch (filter.scope) {
      AllCharacters() => '아직 캐릭터가 없어요',
      LibraryCharacters() => '서재가 비어 있어요',
      ProjectCharacters(:final name) => '$name 에 캐릭터가 없어요',
    };
  }
}
