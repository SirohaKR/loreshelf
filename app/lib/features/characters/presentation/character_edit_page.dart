// 캐릭터 만들기 / 고치기 — 웹 character_edit.js와 같은 항목:
// 기본(이름·영문·소개·대사·저장 위치·공개 범위·테마색), 대표 이미지, 기본 정보 칸(🔒비밀), 성격 축, 대표 대사, 태그, 배경 이야기.
//
// 폼 상태는 hooks로: CharacterDraft(freezed) 하나를 useState로 들고, 입력할 때마다 copyWith로 바꿔 넣는다.
// 저장은 characterSaverProvider(AsyncNotifier) — 저장 중이면 버튼을 막고, 실패하면 문구를 보여 준다.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/labels.dart';
import '../../../core/utils/pick_image.dart';
import '../../../core/widgets/app_error_toast.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/section_card.dart';
import '../../projects/presentation/project_list_provider.dart';
import '../domain/character.dart';
import '../domain/character_draft.dart';
import 'character_edit_provider.dart';
import 'widgets/edit_rows.dart';
import 'widgets/portrait.dart';

class CharacterEditPage extends HookConsumerWidget {
  const CharacterEditPage({super.key, this.id, this.projectId});

  /// null이면 새 캐릭터
  final int? id;

  /// 새 캐릭터를 이 프로젝트 전용으로 시작
  final int? projectId;

  /// 저장하면 저장된 캐릭터를, 취소하면 null을 돌려준다
  static Future<CharacterDetail?> open(BuildContext context, {int? id, int? projectId}) => Navigator.of(context).push(
    MaterialPageRoute<CharacterDetail>(
      builder: (_) => CharacterEditPage(id: id, projectId: projectId),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initial = ref.watch(characterEditInitialProvider(id, projectId));
    return Scaffold(
      appBar: AppBar(title: Text(id == null ? '새 캐릭터' : '캐릭터 편집')),
      body: AsyncValueView(
        value: initial,
        onRetry: () => ref.invalidate(characterEditInitialProvider(id, projectId)),
        builder: (draft) => _CharacterForm(id: id, initial: draft),
      ),
    );
  }
}

class _CharacterForm extends HookConsumerWidget {
  const _CharacterForm({required this.id, required this.initial});
  final int? id;
  final CharacterDraft initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 폼 전체 값 — 바꾸면(draft.value = ...) 이 위젯이 다시 그려진다
    final draft = useState(initial);
    final d = draft.value;
    final problem = useState<String?>(null);
    final uploading = useState(false);
    final saver = ref.watch(characterSaverProvider);
    final projects = ref.watch(projectListProvider).value ?? const [];
    final c = context.colors;

    void set(CharacterDraft Function(CharacterDraft) change) => draft.value = change(draft.value);

    Future<void> pickPortrait() async {
      final picked = await pickImage();
      if (picked == null) return;
      uploading.value = true;
      try {
        final assetId = await ref.read(characterActionsProvider).upload(picked.bytes, picked.name);
        set((x) => x.copyWith(portraitAssetId: assetId));
      } catch (e) {
        if (context.mounted) showAppErrorToast(context, e);
      } finally {
        if (context.mounted) uploading.value = false;
      }
    }

    Future<void> save() async {
      problem.value = draft.value.problem; // d는 그린 때의 값이라 최신 값으로
      if (problem.value != null) return;
      final saved = await ref.read(characterSaverProvider.notifier).save(id, draft.value);
      if (saved != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(id == null ? '캐릭터를 만들었어요' : '저장했어요')));
        Navigator.pop(context, saved);
      }
    }

    final error = problem.value ?? (saver.hasError ? '${saver.error}' : null);

    // 위: 스크롤되는 입력칸들 / 아래: 항상 보이는 오류 문구 + 취소·저장 막대
    return Column(
      children: [
        Expanded(
          child: _centered(
            ListView(
              padding: const EdgeInsets.all(AppSpacing.page),
              children: [
                SectionCard(
                  title: '기본',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      EditText(
                        label: '이름 *',
                        initial: d.name,
                        maxLength: 60,
                        onChanged: (v) => set((x) => x.copyWith(name: v)),
                      ),
                      EditText(
                        label: '영문 이름',
                        hint: '챗봇 카드·프롬프트 트리거에도 써요',
                        initial: d.nameEn,
                        maxLength: 60,
                        onChanged: (v) => set((x) => x.copyWith(nameEn: v)),
                      ),
                      EditText(
                        label: '한 줄 소개',
                        hint: '몰락한 왕가의 마지막 기사',
                        initial: d.tagline,
                        maxLength: 120,
                        onChanged: (v) => set((x) => x.copyWith(tagline: v)),
                      ),
                      EditText(
                        label: '대표 한 줄 대사',
                        hint: '왕관은 잃었어도, 검은 아직 내 손에 있어.',
                        initial: d.quote,
                        maxLength: 200,
                        onChanged: (v) => set((x) => x.copyWith(quote: v)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: DropdownButtonFormField<int?>(
                          initialValue: projects.any((p) => p.id == d.projectId) ? d.projectId : null,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: '저장 위치 (프로젝트 전용 또는 공용 서재)'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('공용 서재')),
                            for (final p in projects)
                              DropdownMenuItem(value: p.id, child: Text('${p.name} 전용 (${kindLabel[p.kind] ?? p.kind})')),
                          ],
                          onChanged: (v) => set((x) => x.copyWith(projectId: v)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: DropdownButtonFormField<String>(
                          initialValue: d.visibility,
                          decoration: const InputDecoration(labelText: '공개 범위 (블로그는 4단계에서 열려요)'),
                          items: [
                            for (final v in const ['private', 'unlisted', 'public'])
                              DropdownMenuItem(value: v, child: Text(visibilityBadge(v).$1)),
                          ],
                          onChanged: (v) => set((x) => x.copyWith(visibility: v ?? 'private')),
                        ),
                      ),
                      const Text('테마색', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      ThemeColorPicker(
                        value: d.themeColor,
                        onChanged: (v) => set((x) => x.copyWith(themeColor: v)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.grid),
                SectionCard(
                  title: '대표 이미지 · 갤러리에도 같이 들어가요',
                  child: Row(
                    children: [
                      SizedBox(
                        width: 96,
                        height: 120,
                        child: Portrait(
                          name: d.name.isEmpty ? '?' : d.name,
                          themeColor: d.themeColor,
                          assetId: d.portraitAssetId,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: uploading.value ? null : pickPortrait,
                              icon: uploading.value
                                  ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Icon(Icons.upload, size: 18),
                              label: const Text('이미지 고르기'),
                            ),
                            if (d.portraitAssetId != null)
                              TextButton(onPressed: () => set((x) => x.copyWith(portraitAssetId: null)), child: const Text('빼기')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.grid),
                SectionCard(
                  title: '기본 정보 · 🔒 비밀 칸은 블로그에 공개해도 안 보여요',
                  child: RowList(
                    addLabel: '+ 항목 추가',
                    onAdd: () => set(
                      (x) => x.copyWith(
                        fields: [
                          ...x.fields,
                          FieldDraft(key: nextRowKey()),
                        ],
                      ),
                    ),
                    children: [
                      for (final (i, f) in d.fields.indexed)
                        FieldRow(
                          key: ValueKey(f.key),
                          row: f,
                          onChanged: (v) => set((x) => x.copyWith(fields: [...x.fields]..[i] = v)),
                          onDelete: () => set((x) => x.copyWith(fields: [...x.fields]..removeAt(i))),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.grid),
                SectionCard(
                  title: '성격 축',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '양 끝에 반대되는 성격을 쓰고 슬라이더로 위치를 정해요. 오른쪽을 비우면 한쪽 성격의 강도로 저장돼요',
                        style: AppTextStyles.caption.copyWith(color: c.muted),
                      ),
                      const SizedBox(height: 10),
                      RowList(
                        addLabel: '+ 축 추가',
                        onAdd: () => set(
                          (x) => x.copyWith(
                            traits: [
                              ...x.traits,
                              TraitDraft(key: nextRowKey()),
                            ],
                          ),
                        ),
                        children: [
                          for (final (i, t) in d.traits.indexed)
                            TraitRow(
                              key: ValueKey(t.key),
                              row: t,
                              onChanged: (v) => set((x) => x.copyWith(traits: [...x.traits]..[i] = v)),
                              onDelete: () => set((x) => x.copyWith(traits: [...x.traits]..removeAt(i))),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.grid),
                SectionCard(
                  title: '대표 대사',
                  child: RowList(
                    addLabel: '+ 대사 추가',
                    onAdd: () => set(
                      (x) => x.copyWith(
                        quotes: [
                          ...x.quotes,
                          QuoteDraft(key: nextRowKey()),
                        ],
                      ),
                    ),
                    children: [
                      for (final (i, q) in d.quotes.indexed)
                        QuoteRow(
                          key: ValueKey(q.key),
                          row: q,
                          onChanged: (v) => set((x) => x.copyWith(quotes: [...x.quotes]..[i] = v)),
                          onDelete: () => set((x) => x.copyWith(quotes: [...x.quotes]..removeAt(i))),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.grid),
                SectionCard(
                  title: '태그 · Enter나 쉼표로 추가',
                  child: TagEditor(
                    tags: d.tags,
                    onAdd: (text) => set((x) => x.withTagsFrom(text)),
                    onRemove: (t) => set((x) => x.copyWith(tags: [...x.tags]..remove(t))),
                  ),
                ),
                const SizedBox(height: AppSpacing.grid),
                SectionCard(
                  title: '배경 이야기 · 마크다운: **굵게**, *기울임*, - 목록, # 제목',
                  child: TextFormField(
                    initialValue: d.bodyMd,
                    minLines: 6,
                    maxLines: 16,
                    maxLength: 50000,
                    onChanged: (v) => set((x) => x.copyWith(bodyMd: v)),
                  ),
                ),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: BorderSide(color: c.line)),
          ),
          child: SafeArea(
            top: false,
            child: _centered(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        error ?? '',
                        style: TextStyle(color: c.danger, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: saver.isLoading || uploading.value ? null : save,
                      child: Text(saver.isLoading ? '저장 중…' : (id == null ? '만들기' : '저장')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _centered(Widget child) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 820), child: child),
  );
}
