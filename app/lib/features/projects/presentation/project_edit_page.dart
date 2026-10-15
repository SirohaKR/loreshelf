// 프로젝트 만들기 / 고치기 — 웹 projects.js renderEdit과 같은 항목:
// 이름·종류·공개 범위·장르·세계관 태그(고르기 창)·한 줄 소개·기획 진행도·대표 이미지·설명
// 짜임은 캐릭터 편집(character_edit_page.dart)과 같다: ProjectDraft를 useState로, 저장은 projectSaverProvider.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/labels.dart';
import '../../../core/utils/pick_image.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/section_card.dart';
import '../../characters/presentation/widgets/edit_rows.dart' show EditText;
import '../data/projects_repository_impl.dart';
import '../domain/project.dart';
import '../domain/project_draft.dart';
import 'project_edit_provider.dart';
import 'widgets/genre_picker_dialog.dart';

class ProjectEditPage extends HookConsumerWidget {
  const ProjectEditPage({super.key, this.id});
  final int? id;

  static Future<ProjectDetail?> open(BuildContext context, {int? id}) =>
      Navigator.of(context).push(MaterialPageRoute<ProjectDetail>(builder: (_) => ProjectEditPage(id: id)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initial = ref.watch(projectEditInitialProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(id == null ? '새 프로젝트' : '프로젝트 편집')),
      body: AsyncValueView(
        value: initial,
        onRetry: () => ref.invalidate(projectEditInitialProvider(id)),
        builder: (d) => _ProjectForm(id: id, initial: d),
      ),
    );
  }
}

class _ProjectForm extends HookConsumerWidget {
  const _ProjectForm({required this.id, required this.initial});
  final int? id;
  final ProjectDraft initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = useState(initial);
    final d = draft.value;
    final problem = useState<String?>(null);
    final uploading = useState(false);
    final saver = ref.watch(projectSaverProvider);
    final api = ref.watch(apiClientProvider);
    final c = context.colors;

    void set(ProjectDraft Function(ProjectDraft) change) => draft.value = change(draft.value);

    Future<void> pickCover() async {
      final picked = await pickImage();
      if (picked == null) return;
      uploading.value = true;
      try {
        final assetId = await ref.read(projectsRepositoryProvider).uploadImage(picked.bytes, picked.name);
        set((x) => x.copyWith(coverAssetId: assetId));
      } catch (e) {
        if (context.mounted) showAppErrorToast(context, e);
      } finally {
        if (context.mounted) uploading.value = false;
      }
    }

    Future<void> save() async {
      problem.value = draft.value.problem;
      if (problem.value != null) return;
      final saved = await ref.read(projectSaverProvider.notifier).save(id, draft.value);
      if (saved != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(id == null ? '프로젝트를 만들었어요' : '저장했어요')));
        Navigator.pop(context, saved);
      }
    }

    final error = problem.value ?? (saver.hasError ? '${saver.error}' : null);
    const label = TextStyle(fontSize: 13, fontWeight: FontWeight.w700);

    return Column(children: [
      Expanded(
        child: _centered(ListView(
          padding: const EdgeInsets.all(AppSpacing.page),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EditText(label: '이름 *', initial: d.name, maxLength: 60, onChanged: (v) => set((x) => x.copyWith(name: v))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: d.kind,
                          decoration: const InputDecoration(labelText: '종류'),
                          items: [for (final e in kindLabel.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
                          onChanged: (v) => set((x) => x.copyWith(kind: v ?? 'etc')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: d.visibility,
                          decoration: const InputDecoration(labelText: '공개 범위'),
                          items: [
                            for (final v in const ['private', 'unlisted', 'public'])
                              DropdownMenuItem(value: v, child: Text(visibilityBadge(v).$1)),
                          ],
                          onChanged: (v) => set((x) => x.copyWith(visibility: v ?? 'private')),
                        ),
                      ),
                    ]),
                  ),
                  const Text('장르 · 세계관 태그', style: label),
                  Text('로판, 현판, 학원, 청춘, 복수 … 세계관의 자세한 설정은 아래 설명에 써요', style: TextStyle(fontSize: 12, color: c.muted)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
                    if (d.genres.isEmpty) Text('아직 없음', style: TextStyle(fontSize: 13, color: c.muted)),
                    for (final g in d.genres) AppChip(g.name, tone: Tone.accent),
                    OutlinedButton(
                      onPressed: () async {
                        final picked = await showGenrePicker(context, d.genres);
                        if (picked != null) set((x) => x.copyWith(genres: picked));
                      },
                      child: const Text('# 태그 고르기'),
                    ),
                  ]),
                  const SizedBox(height: 18),
                  EditText(
                    label: '한 줄 소개',
                    hint: '2D 턴제 RPG',
                    initial: d.summary,
                    maxLength: 200,
                    onChanged: (v) => set((x) => x.copyWith(summary: v)),
                  ),
                  Text('기획 진행도 ${d.progressPercent}%', style: label),
                  Slider(
                    value: d.progressPercent.toDouble(),
                    max: 100,
                    divisions: 20,
                    label: '${d.progressPercent}%',
                    onChanged: (v) => set((x) => x.copyWith(progressPercent: v.round())),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Text('대표 이미지', style: label),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadii.thumb),
                      child: SizedBox.square(
                        dimension: 56,
                        child: d.coverAssetId == null
                            ? ColoredBox(color: c.surface2, child: Center(child: Text('없음', style: TextStyle(fontSize: 12, color: c.muted))))
                            : Image.network(api.assetUrl(d.coverAssetId!), headers: api.imageHeaders, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(onPressed: uploading.value ? null : pickCover, child: Text(uploading.value ? '올리는 중…' : '고르기')),
                    if (d.coverAssetId != null)
                      TextButton(onPressed: () => set((x) => x.copyWith(coverAssetId: null)), child: const Text('빼기')),
                  ]),
                  const SizedBox(height: 18),
                  TextFormField(
                    initialValue: d.bodyMd,
                    minLines: 6,
                    maxLines: 16,
                    maxLength: 50000,
                    decoration: const InputDecoration(labelText: '설명 (마크다운)', alignLabelWithHint: true),
                    onChanged: (v) => set((x) => x.copyWith(bodyMd: v)),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
      DecoratedBox(
        decoration: BoxDecoration(color: c.surface, border: Border(top: BorderSide(color: c.line))),
        child: SafeArea(
          top: false,
          child: _centered(Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: 10),
            child: Row(children: [
              Expanded(child: Text(error ?? '', style: TextStyle(color: c.danger, fontWeight: FontWeight.w600, fontSize: 13))),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: saver.isLoading || uploading.value ? null : save,
                child: Text(saver.isLoading ? '저장 중…' : (id == null ? '만들기' : '저장')),
              ),
            ]),
          )),
        ),
      ),
    ]);
  }

  static Widget _centered(Widget child) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 820), child: child),
      );
}
