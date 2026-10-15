// 리포지토리 구현: GET /api/characters?scope=library | project_id=3 & q=검색어, /api/characters/:id
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../domain/character.dart';
import '../domain/character_scope.dart';
import '../domain/characters_repository.dart';

part 'characters_repository_impl.g.dart';

@Riverpod(keepAlive: true)
CharactersRepository charactersRepository(Ref ref) => CharactersRepositoryImpl(ref.watch(apiClientProvider));

class CharactersRepositoryImpl implements CharactersRepository {
  CharactersRepositoryImpl(this._api);
  final ApiClient _api;

  /// 도메인의 "어디에서"(CharacterScope) → 서버 검색 조건.
  /// 참고: project_id 목록은 그 프로젝트 전용 + 서재에서 연결한 캐릭터를 함께 돌려준다.
  static Map<String, String> queryOf(CharacterScope scope, String text) => {
        ...switch (scope) {
          AllCharacters() => const <String, String>{},
          LibraryCharacters() => const {'scope': 'library'},
          ProjectCharacters(:final id) => {'project_id': '$id'},
        },
        if (text.isNotEmpty) 'q': text,
      };

  @override
  Future<List<CharacterSummary>> fetchList({CharacterScope scope = const CharacterScope.all(), String text = ''}) async =>
      (await _api.getList('/api/characters', queryOf(scope, text))).map(CharacterSummary.fromJson).toList();

  @override
  Future<CharacterDetail> fetchDetail(int id) async => CharacterDetail.fromJson(await _api.getMap('/api/characters/$id'));
}
