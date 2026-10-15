// 위젯 테스트용 가짜 리포지토리 — domain/의 인터페이스만 구현하면 화면은 진짜와 구별하지 못한다.
// (Java로 치면 interface의 테스트용 구현 / Mockito 없이 손으로 만든 mock)
import 'package:loreshelf_app/core/network/api_client.dart';
import 'package:loreshelf_app/features/auth/domain/auth_repository.dart';
import 'package:loreshelf_app/features/auth/domain/user.dart';
import 'package:loreshelf_app/features/characters/domain/character.dart';
import 'package:loreshelf_app/features/characters/domain/character_scope.dart';
import 'package:loreshelf_app/features/characters/domain/characters_repository.dart';
import 'package:loreshelf_app/features/home/domain/home_repository.dart';
import 'package:loreshelf_app/features/home/domain/home_summary.dart';
import 'package:loreshelf_app/features/projects/domain/genre.dart';
import 'package:loreshelf_app/features/projects/domain/project.dart';
import 'package:loreshelf_app/features/projects/domain/projects_repository.dart';

const me = User(id: 1, loginName: 'dev', displayName: '서연');
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
  Future<CharacterDetail> fetchDetail(int id) async => CharacterDetail(id: id, name: id == 1 ? lia.name : mir.name);
}
