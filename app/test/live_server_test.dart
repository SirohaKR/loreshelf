// 실제 개발 서버에 붙여 보는 테스트 — 평소엔 건너뛰고, 서버를 켜 둔 상태에서 비밀번호를 넘겨야 돈다.
//   LORESHELF_LIVE_PASSWORD=개발계정비번 flutter test test/live_server_test.dart
//   (서버 주소는 LORESHELF_LIVE_URL, 기본 http://localhost:5091 · 아이디는 LORESHELF_LIVE_USER, 기본 dev)
// 진짜 리포지토리 구현(data/)으로 모든 화면의 데이터를 받아 보고, 서버 JSON ↔ 엔티티가 맞는지 확인한다.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:loreshelf_app/core/network/api_client.dart';
import 'package:loreshelf_app/features/auth/data/auth_repository_impl.dart';
import 'package:loreshelf_app/features/characters/data/characters_repository_impl.dart';
import 'package:loreshelf_app/features/characters/domain/character_scope.dart';
import 'package:loreshelf_app/features/home/data/home_repository_impl.dart';
import 'package:loreshelf_app/features/projects/data/projects_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final env = Platform.environment;
  final password = env['LORESHELF_LIVE_PASSWORD'];

  test('개발 서버의 실제 응답이 엔티티로 읽힌다', () async {
    SharedPreferences.setMockInitialValues({});
    final api = ApiClient(baseUrl: '');
    final auth = AuthRepositoryImpl(api, await SharedPreferences.getInstance());
    final user = await auth.login(
      serverUrl: env['LORESHELF_LIVE_URL'] ?? 'http://localhost:5091',
      loginName: env['LORESHELF_LIVE_USER'] ?? 'dev',
      password: password!,
    );
    expect(api.cookie, startsWith('ls_session='));
    expect(await auth.currentUser(), user);

    final home = await HomeRepositoryImpl(api).fetchSummary();
    expect(home.user, user);

    final projectsRepo = ProjectsRepositoryImpl(api);
    final charactersRepo = CharactersRepositoryImpl(api);
    final projects = await projectsRepo.fetchList();
    for (final p in projects) {
      final d = await projectsRepo.fetchDetail(p.id);
      expect(d.genres.length, p.genres.length);
      // 프로젝트별 목록 = 그 프로젝트 상세의 캐릭터(전용 + 서재에서 연결)와 같은 사람들
      final inProject = await charactersRepo.fetchList(scope: CharacterScope.project(id: p.id, name: p.name));
      expect(inProject.map((c) => c.id).toSet(), d.characters.map((c) => c.id).toSet());
    }

    final all = await charactersRepo.fetchList();
    final library = await charactersRepo.fetchList(scope: const CharacterScope.library());
    expect(library.every((c) => c.projectId == null), isTrue);
    for (final c in all) {
      expect((await charactersRepo.fetchDetail(c.id)).name, c.name);
    }

    // 썸네일도 쿠키로 받아진다
    final withImage = all.where((c) => c.portraitAssetId != null);
    if (withImage.isNotEmpty) {
      final req = await HttpClient().getUrl(Uri.parse(api.assetUrl(withImage.first.portraitAssetId!)));
      api.imageHeaders.forEach(req.headers.set);
      final res = await req.close();
      expect(res.statusCode, 200);
      expect(res.headers.contentType?.mimeType, 'image/jpeg');
      await res.drain<void>();
    }

    // ignore: avoid_print
    print('확인: 프로젝트 ${projects.length}개, 캐릭터 ${all.length}명, 서재 ${library.length}명');
  }, skip: password == null ? 'LORESHELF_LIVE_PASSWORD가 없어서 건너뜀' : false);
}
