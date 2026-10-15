// 캐릭터 목록 — provider 두 개가 사슬처럼 이어진다:
//   characterListFilterProvider (지금 필터·검색어, 바꿀 수 있는 상태)
//        ↓ ref.watch
//   characterListProvider (그 조건으로 서버에서 받은 목록)
// 필터가 바뀌면 목록 provider가 알아서 다시 받는다. 화면은 둘을 watch만 하면 된다.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/characters_repository_impl.dart';
import '../domain/character.dart';
import '../domain/character_scope.dart';
import 'character_list_state.dart';

part 'character_list_provider.g.dart';

@riverpod
class CharacterListFilter extends _$CharacterListFilter {
  @override
  CharacterListState build() => const CharacterListState();

  void selectScope(CharacterScope scope) => state = state.copyWith(scope: scope);

  void search(String text) {
    final t = text.trim();
    if (t != state.text) state = state.copyWith(text: t); // 같은 검색어면 다시 받지 않게
  }
}

@riverpod
Future<List<CharacterSummary>> characterList(Ref ref) {
  final filter = ref.watch(characterListFilterProvider);
  return ref.watch(charactersRepositoryProvider).fetchList(scope: filter.scope, text: filter.text);
}
