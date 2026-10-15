// 장르·세계관 태그 고르기 창 — 웹 parts.js의 pickGenres와 같은 흐름:
// 카테고리별 칩을 눌러 고르고(다시 누르면 빠짐), 위에서 찾고, 아래에서 직접 추가. 직접 추가한 태그는 ✕로 지운다.
// "넣기"를 누르면 고른 태그 목록을, 취소하면 null을 돌려준다.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/labels.dart';
import '../../../../core/widgets/app_error_toast.dart';
import '../../data/projects_repository_impl.dart';
import '../../domain/genre.dart';
import '../project_edit_provider.dart';

Future<List<Genre>?> showGenrePicker(BuildContext context, List<Genre> selected) =>
    showDialog<List<Genre>>(context: context, builder: (_) => GenrePickerDialog(selected: selected));

class GenrePickerDialog extends HookConsumerWidget {
  const GenrePickerDialog({super.key, required this.selected});
  final List<Genre> selected;

  static const maxCount = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genres = ref.watch(genreListProvider);
    final chosen = useState(<int>{for (final g in selected) g.id});
    final filter = useTextEditingController();
    final q = useValueListenable(filter).text.trim().toLowerCase();
    final newName = useTextEditingController();
    final c = context.colors;
    final repo = ref.read(projectsRepositoryProvider);

    void toggle(Genre g) {
      final next = {...chosen.value};
      if (!next.remove(g.id)) {
        if (next.length >= maxCount) return showAppErrorToast(context, '태그는 $maxCount개까지예요');
        next.add(g.id);
      }
      chosen.value = next;
    }

    Future<void> add() async {
      if (newName.text.trim().isEmpty) return;
      try {
        final g = await repo.addGenre(newName.text.trim());
        ref.invalidate(genreListProvider);
        chosen.value = {...chosen.value, g.id};
        newName.clear();
        filter.clear();
      } catch (e) {
        if (context.mounted) showAppErrorToast(context, e);
      }
    }

    Future<void> remove(Genre g) async {
      try {
        await repo.deleteGenre(g.id);
        ref.invalidate(genreListProvider);
        chosen.value = {...chosen.value}..remove(g.id);
      } catch (e) {
        if (context.mounted) showAppErrorToast(context, e);
      }
    }

    final all = genres.value ?? const <Genre>[];
    final groups = [
      for (final cat in genreCategoryLabel.keys)
        (cat, all.where((g) => g.category == cat && (q.isEmpty || g.name.toLowerCase().contains(q))).toList()),
    ].where((x) => x.$2.isNotEmpty).toList();

    return AlertDialog(
      title: const Text('장르 · 세계관 태그', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: SizedBox(
        width: 640,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('눌러서 고르고, 다시 누르면 빠져요. 없는 건 아래에서 직접 추가해요.', style: TextStyle(fontSize: 13, color: c.muted)),
            const SizedBox(height: 10),
            TextField(
              controller: filter,
              decoration: const InputDecoration(hintText: '태그 찾기 (예: 로판, 학원, 복수)', prefixIcon: Icon(Icons.search), isDense: true),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: switch (genres) {
                AsyncError(:final error) when !genres.hasValue => Text('$error', style: TextStyle(color: c.danger)),
                _ when !genres.hasValue => const Center(child: CircularProgressIndicator()),
                _ when groups.isEmpty => Text('찾는 태그가 없어요. 아래에서 직접 추가해 보세요.', style: TextStyle(color: c.muted)),
                _ => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (cat, list) in groups) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 6),
                            child: Text(genreCategoryLabel[cat]!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          ),
                          Wrap(spacing: 6, runSpacing: 6, children: [
                            for (final g in list)
                              FilterChip(
                                label: Text(g.name),
                                selected: chosen.value.contains(g.id),
                                onSelected: (_) => toggle(g),
                                onDeleted: g.isCustom ? () => remove(g) : null,
                                deleteButtonTooltipMessage: '이 태그 지우기',
                              ),
                          ]),
                        ],
                      ],
                    ),
                  ),
              },
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: newName,
                  maxLength: 20,
                  decoration: const InputDecoration(hintText: '직접 추가할 태그', isDense: true, counterText: ''),
                  onSubmitted: (_) => add(),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: add, child: const Text('+ 추가')),
            ]),
          ],
        ),
      ),
      actions: [
        Text('${chosen.value.length}개 고름', style: TextStyle(fontSize: 13, color: c.muted)),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
        FilledButton(
          // 목록을 아직 못 받았으면 처음 고른 것 그대로
          onPressed: () => Navigator.pop(context, genres.hasValue ? all.where((g) => chosen.value.contains(g.id)).toList() : selected),
          child: const Text('넣기'),
        ),
      ],
    );
  }
}
