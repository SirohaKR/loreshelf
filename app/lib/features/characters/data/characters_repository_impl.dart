// 리포지토리 구현: GET /api/characters?scope=library | project_id=3 & q=검색어, /api/characters/:id
// 고치기: POST·PUT /api/characters, /favorite, /move, /fork, /assets, 이미지 올리기 POST /api/assets
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../domain/character.dart';
import '../domain/character_draft.dart';
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

  @override
  Future<CharacterDetail> save(int? id, CharacterDraft draft) async => CharacterDetail.fromJson(
        id == null ? await _api.post('/api/characters', draft.toPayload()) : await _api.put('/api/characters/$id', draft.toPayload()),
      );

  @override
  Future<int> uploadImage(Uint8List bytes, String fileName) async => (await _api.upload('/api/assets', bytes, fileName))['id'] as int;

  @override
  Future<CharacterDetail> addToGallery(int id, int assetId, {bool setPortrait = false}) async =>
      CharacterDetail.fromJson(await _api.post('/api/characters/$id/assets', {'asset_id': assetId, 'set_portrait': setPortrait}));

  @override
  Future<CharacterDetail> removeFromGallery(int id, int assetId) async =>
      CharacterDetail.fromJson(await _api.delete('/api/characters/$id/assets/$assetId'));

  @override
  Future<void> setFavorite(int id, bool favorite) => _api.put('/api/characters/$id/favorite', {'is_favorite': favorite});

  @override
  Future<CharacterDetail> move(int id, int? projectId) async =>
      CharacterDetail.fromJson(await _api.post('/api/characters/$id/move', {'project_id': projectId}));

  @override
  Future<CharacterDetail> fork(int id, int? projectId) async =>
      CharacterDetail.fromJson(await _api.post('/api/characters/$id/fork', {'project_id': projectId}));

  @override
  Future<void> delete(int id) => _api.delete('/api/characters/$id');
}
