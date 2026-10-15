// 프로젝트 고치기 쪽 provider — 첫 값, 저장(AsyncNotifier), 장르 태그 목록
// (캐릭터의 character_edit_provider.dart와 같은 짜임)
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../home/presentation/home_provider.dart';
import '../data/projects_repository_impl.dart';
import '../domain/genre.dart';
import '../domain/project.dart';
import '../domain/project_draft.dart';
import 'project_detail_provider.dart';
import 'project_list_provider.dart';

part 'project_edit_provider.g.dart';

@riverpod
Future<ProjectDraft> projectEditInitial(Ref ref, int? id) async =>
    id == null ? const ProjectDraft() : ProjectDraft.fromDetail(await ref.watch(projectsRepositoryProvider).fetchDetail(id));

/// 장르·세계관 태그 전체 — 태그 고르기 창이 쓴다
@riverpod
Future<List<Genre>> genreList(Ref ref) => ref.watch(projectsRepositoryProvider).fetchGenres();

@riverpod
class ProjectSaver extends _$ProjectSaver {
  @override
  FutureOr<ProjectDetail?> build() => null;

  Future<ProjectDetail?> save(int? id, ProjectDraft draft) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => ref.read(projectsRepositoryProvider).save(id, draft));
    if (!ref.mounted) return null;
    state = result;
    final saved = result.value;
    if (saved != null) {
      ref
        ..invalidate(projectDetailProvider(saved.id))
        ..invalidate(projectListProvider)
        ..invalidate(homeSummaryProvider);
    }
    return saved;
  }
}
