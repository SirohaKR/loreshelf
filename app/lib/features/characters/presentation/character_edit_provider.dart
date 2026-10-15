// 캐릭터 고치기 쪽 provider 세 가지
//   characterEditInitialProvider(id, projectId) — 편집 화면을 처음 채울 값 (고치기면 서버에서 받아서)
//   characterSaverProvider — AsyncNotifier: 저장 중/실패/성공을 AsyncValue 하나로 들고 있다
//   characterActionsProvider — 즐겨찾기·옮기기·갤러리처럼 "누르면 바로" 하는 일들
// 무엇이든 바꾸고 나면 refreshCharacterViews로 목록·상세·홈을 다시 받게 한다.
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../home/presentation/home_provider.dart';
import '../../projects/presentation/project_detail_provider.dart';
import '../../projects/presentation/project_list_provider.dart';
import '../data/characters_repository_impl.dart';
import '../domain/character.dart';
import '../domain/character_draft.dart';
import '../domain/characters_repository.dart';
import 'character_detail_provider.dart';
import 'character_list_provider.dart';

part 'character_edit_provider.g.dart';

@riverpod
Future<CharacterDraft> characterEditInitial(Ref ref, int? id, int? projectId) async => id == null
    ? CharacterDraft.empty(projectId: projectId)
    : CharacterDraft.fromDetail(await ref.watch(charactersRepositoryProvider).fetchDetail(id));

/// 캐릭터가 바뀌면 그걸 보여 주던 화면들의 데이터를 버린다 → 보고 있던 화면은 다시 받는다
void refreshCharacterViews(Ref ref, int id) {
  ref
    ..invalidate(characterDetailProvider(id))
    ..invalidate(characterListProvider)
    ..invalidate(homeSummaryProvider)
    ..invalidate(projectListProvider)
    ..invalidate(projectDetailProvider);
}

/// AsyncNotifier로 저장하기: build()는 "아직 아무것도 안 함"(null),
/// save()가 state를 AsyncLoading → AsyncData(저장된 캐릭터) 또는 AsyncError로 바꾼다.
/// 화면은 state.isLoading으로 버튼을 막고, state.error로 오류 문구를 보여 준다.
@riverpod
class CharacterSaver extends _$CharacterSaver {
  @override
  FutureOr<CharacterDetail?> build() => null;

  /// 성공하면 저장된 캐릭터, 실패하면 null (오류는 state에)
  Future<CharacterDetail?> save(int? id, CharacterDraft draft) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();
    // AsyncValue.guard = try/catch를 대신해서 결과를 AsyncData/AsyncError로 감싸 준다
    final result = await AsyncValue.guard(() => ref.read(charactersRepositoryProvider).save(id, draft));
    if (!ref.mounted) return null; // 기다리는 사이에 화면이 닫혔으면 손대지 않는다
    state = result;
    final saved = result.value;
    if (saved != null) refreshCharacterViews(ref, saved.id);
    return saved;
  }
}

@Riverpod(keepAlive: true)
CharacterActions characterActions(Ref ref) => CharacterActions(ref);

class CharacterActions {
  CharacterActions(this._ref);
  final Ref _ref;

  Future<T> _run<T>(int id, Future<T> Function() work) async {
    final result = await work();
    refreshCharacterViews(_ref, id);
    return result;
  }

  CharactersRepository get _repo => _ref.read(charactersRepositoryProvider);

  /// 파일을 올리기만 하고 번호를 돌려준다 (편집 화면의 대표 이미지 고르기)
  Future<int> upload(Uint8List bytes, String fileName) => _repo.uploadImage(bytes, fileName);

  /// 올리고 갤러리에 넣기
  Future<void> addImage(int id, Uint8List bytes, String fileName) => _run(id, () async {
        await _repo.addToGallery(id, await _repo.uploadImage(bytes, fileName));
      });

  Future<void> setPortrait(int id, int assetId) => _run(id, () => _repo.addToGallery(id, assetId, setPortrait: true));

  Future<void> removeImage(int id, int assetId) => _run(id, () => _repo.removeFromGallery(id, assetId));

  Future<void> setFavorite(int id, bool favorite) => _run(id, () => _repo.setFavorite(id, favorite));

  Future<void> move(int id, int? projectId) => _run(id, () => _repo.move(id, projectId));

  /// 분기 — 새로 생긴 캐릭터를 돌려준다
  Future<CharacterDetail> fork(int id, int? projectId) => _run(id, () => _repo.fork(id, projectId));

  Future<void> delete(int id) => _run(id, () => _repo.delete(id));
}
