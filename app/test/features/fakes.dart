// 위젯 테스트용 가짜 리포지토리 — domain/의 인터페이스만 구현하면 화면은 진짜와 구별하지 못한다.
// (Java로 치면 interface의 테스트용 구현 / Mockito 없이 손으로 만든 mock)
import 'dart:typed_data';

import 'package:loreshelf_app/core/network/api_client.dart';
import 'package:loreshelf_app/features/auth/domain/auth_repository.dart';
import 'package:loreshelf_app/features/auth/domain/user.dart';
import 'package:loreshelf_app/features/characters/domain/character.dart';
import 'package:loreshelf_app/features/characters/domain/character_draft.dart';
import 'package:loreshelf_app/features/characters/domain/character_scope.dart';
import 'package:loreshelf_app/features/characters/domain/characters_repository.dart';
import 'package:loreshelf_app/features/home/domain/home_repository.dart';
import 'package:loreshelf_app/features/home/domain/home_summary.dart';
import 'package:loreshelf_app/features/projects/domain/genre.dart';
import 'package:loreshelf_app/features/projects/domain/project.dart';
import 'package:loreshelf_app/features/projects/domain/project_draft.dart';
import 'package:loreshelf_app/features/projects/domain/projects_repository.dart';

const me = User(id: 1, loginName: 'dev', displayName: '주인장');
const lia = CharacterSummary(id: 1, name: '리아 벨로트', tagline: '몰락한 왕가의 마지막 기사', themeColor: '#C9573F', projectId: 1);
const mir = CharacterSummary(id: 3, name: '미르', tagline: '말하는 고양이', isFavorite: true);
const crown = ProjectSummary(
  id: 1,
  name: '잿빛 왕관',
  kind: 'game',
  progressPercent: 60,
  ownCharacterCount: 1,
  genres: [Genre(id: 1, category: 'genre', name: '로맨스 판타지')],
);

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.user, this.password = 'pw'});
  User? user;
  final String password;

  @override
  String get serverUrl => 'http://test';

  @override
  set onSessionExpired(void Function()? callback) {}

  @override
  Future<User?> currentUser() async => user;

  @override
  Future<User> login({required String serverUrl, required String loginName, required String password}) async {
    if (password != this.password) throw ApiException(401, '아이디 또는 비밀번호가 맞지 않아요');
    return user = me;
  }

  @override
  Future<void> logout() async => user = null;

  @override
  Future<void> forgetSession() async => user = null;
}

class FakeHomeRepository implements HomeRepository {
  @override
  Future<HomeSummary> fetchSummary() async => const HomeSummary(
        user: me,
        counts: HomeCounts(characters: 6, libraryCharacters: 3, projects: 2, publicItems: 3),
        recentCharacters: [lia, mir],
        projects: [crown],
      );
}

class FakeProjectsRepository implements ProjectsRepository {
  @override
  Future<List<ProjectSummary>> fetchList() async => [crown];

  @override
  Future<ProjectDetail> fetchDetail(int id) async => ProjectDetail(id: id, name: crown.name, genres: crown.genres);

  final genres = [
    const Genre(id: 1, category: 'genre', name: '로맨스 판타지'),
    const Genre(id: 2, category: 'setting', name: '학원'),
    const Genre(id: 3, category: 'mood', name: '복수'),
  ];
  final saved = <Map<String, Object?>>[];

  @override
  Future<ProjectDetail> save(int? id, ProjectDraft draft) async {
    saved.add(draft.toPayload());
    return ProjectDetail(id: id ?? 50, name: draft.name, genres: draft.genres);
  }

  @override
  Future<List<Genre>> fetchGenres() async => genres;

  @override
  Future<Genre> addGenre(String name) async {
    final g = Genre(id: 90 + genres.length, category: 'custom', name: name, isCustom: true);
    genres.add(g);
    return g;
  }

  @override
  Future<void> deleteGenre(int id) async => genres.removeWhere((g) => g.id == id);

  @override
  Future<int> uploadImage(Uint8List bytes, String fileName) async => 88;
}

/// 어떤 조건으로 불렸는지 기록해 둔다
class FakeCharactersRepository implements CharactersRepository {
  final asked = <CharacterScope>[];

  @override
  Future<List<CharacterSummary>> fetchList({CharacterScope scope = const CharacterScope.all(), String text = ''}) async {
    asked.add(scope);
    return switch (scope) {
      LibraryCharacters() => [mir],
      ProjectCharacters() => [lia],
      AllCharacters() => [lia, mir],
    };
  }

  @override
  Future<CharacterDetail> fetchDetail(int id) async =>
      details[id] ?? CharacterDetail(id: id, name: id == 1 ? lia.name : mir.name);

  // ── 고치기: 무엇이 불렸는지 calls에 적고, 결과는 details에 반영 ──
  final details = <int, CharacterDetail>{};
  final calls = <String>[];
  final saved = <Map<String, Object?>>[];
  var _nextId = 100;

  @override
  Future<CharacterDetail> save(int? id, CharacterDraft draft) async {
    if (draft.name == '실패') throw ApiException(400, '이름이 이상해요');
    saved.add(draft.toPayload());
    final cid = id ?? _nextId++;
    return details[cid] = CharacterDetail(id: cid, name: draft.name, tags: draft.tags, portraitAssetId: draft.portraitAssetId);
  }

  @override
  Future<int> uploadImage(Uint8List bytes, String fileName) async {
    calls.add('upload $fileName');
    return 77;
  }

  @override
  Future<CharacterDetail> addToGallery(int id, int assetId, {bool setPortrait = false}) async {
    calls.add('gallery+ $assetId${setPortrait ? ' portrait' : ''}');
    return fetchDetail(id);
  }

  @override
  Future<CharacterDetail> removeFromGallery(int id, int assetId) async {
    calls.add('gallery- $assetId');
    return fetchDetail(id);
  }

  @override
  Future<void> setFavorite(int id, bool favorite) async => calls.add('favorite $id $favorite');

  @override
  Future<CharacterDetail> move(int id, int? projectId) async {
    calls.add('move $id $projectId');
    return fetchDetail(id);
  }

  @override
  Future<CharacterDetail> fork(int id, int? projectId) async {
    calls.add('fork $id $projectId');
    return CharacterDetail(id: _nextId++, name: '${(await fetchDetail(id)).name} (분기)');
  }

  @override
  Future<void> delete(int id) async => calls.add('delete $id');
}
