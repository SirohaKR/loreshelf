// 프로젝트 고치기 쪽 provider — 첫 값, 저장(AsyncNotifier), 장르 태그 목록
// (캐릭터의 character_edit_provider.dart와 같은 짜임)
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../characters/data/characters_repository_impl.dart';
import '../../characters/domain/character.dart';
import '../../characters/domain/character_scope.dart';
import '../../characters/presentation/character_list_provider.dart';
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

/// 서재에서 연결 창이 보여줄 공용 서재 캐릭터 목록
@riverpod
Future<List<CharacterSummary>> libraryCharactersForLinking(Ref ref) =>
    ref.watch(charactersRepositoryProvider).fetchList(scope: const CharacterScope.library());

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

/// 서재 캐릭터 연결/끊기 — 누르면 바로 하는 일 (CharacterActions와 같은 짜임)
@Riverpod(keepAlive: true)
ProjectActions projectActions(Ref ref) => ProjectActions(ref);

class ProjectActions {
  ProjectActions(this._ref);
  final Ref _ref;

  Future<ProjectDetail> _run(int projectId, Future<ProjectDetail> Function() work) async {
    final result = await work();
    _ref
      ..invalidate(projectDetailProvider(projectId))
      ..invalidate(projectListProvider)
      ..invalidate(homeSummaryProvider);
    return result;
  }

  /// [role]은 비우면 null (역할 없음)으로 저장됨
  Future<ProjectDetail> linkCharacter(int projectId, int characterId, {String? role}) =>
      _run(projectId, () => _ref.read(projectsRepositoryProvider).linkCharacter(projectId, characterId, role: role));

  Future<ProjectDetail> unlinkCharacter(int projectId, int characterId) =>
      _run(projectId, () => _ref.read(projectsRepositoryProvider).unlinkCharacter(projectId, characterId));

  /// 휴지통으로 — 이 프로젝트 전용 캐릭터도 같이 숨겨지니 캐릭터 목록도 다시 받는다
  Future<void> delete(int id) async {
    await _ref.read(projectsRepositoryProvider).delete(id);
    _ref
      ..invalidate(projectDetailProvider(id))
      ..invalidate(projectListProvider)
      ..invalidate(characterListProvider)
      ..invalidate(homeSummaryProvider);
  }
}
