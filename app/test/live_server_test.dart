// 실제 개발 서버에 붙여 보는 테스트 — 평소엔 건너뛰고, 서버를 켜 둔 상태에서 비밀번호를 넘겨야 돈다.
//   LORESHELF_LIVE_PASSWORD=개발계정비번 flutter test test/live_server_test.dart
//   (서버 주소는 LORESHELF_LIVE_URL, 기본 http://localhost:5091 · 아이디는 LORESHELF_LIVE_USER, 기본 dev)
// 진짜 리포지토리 구현(data/)으로 모든 화면의 데이터를 받아 보고, 서버 JSON ↔ 엔티티가 맞는지 확인한다.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:loreshelf_app/core/network/api_client.dart';
import 'package:loreshelf_app/features/auth/data/auth_repository_impl.dart';
import 'package:loreshelf_app/features/characters/data/characters_repository_impl.dart';
import 'package:loreshelf_app/features/characters/domain/character_draft.dart';
import 'package:loreshelf_app/features/characters/domain/character_scope.dart';
import 'package:loreshelf_app/features/home/data/home_repository_impl.dart';
import 'package:loreshelf_app/features/projects/data/projects_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final env = Platform.environment;
  final password = env['LORESHELF_LIVE_PASSWORD'];

  final skip = password == null ? 'LORESHELF_LIVE_PASSWORD가 없어서 건너뜀' : false;

  Future<(ApiClient, AuthRepositoryImpl)> login() async {
    SharedPreferences.setMockInitialValues({});
    final api = ApiClient(baseUrl: '');
    final auth = AuthRepositoryImpl(api, await SharedPreferences.getInstance());
    await auth.login(
      serverUrl: env['LORESHELF_LIVE_URL'] ?? 'http://localhost:5091',
      loginName: env['LORESHELF_LIVE_USER'] ?? 'dev',
      password: password!,
    );
    return (api, auth);
  }

  test('개발 서버의 실제 응답이 엔티티로 읽힌다', () async {
    final (api, auth) = await login();
    final user = (await auth.currentUser())!;
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
  }, skip: skip);

  test('고치기: 만들기 → 고치기 → 이미지 → 즐겨찾기·옮기기·분기 → 휴지통', () async {
    final (api, _) = await login();
    final repo = CharactersRepositoryImpl(api);
    final made = await repo.save(
      null,
      CharacterDraft.empty().copyWith(
        name: '앱 테스트 캐릭터',
        themeColor: '#3E8FA8',
        traits: [TraitDraft(key: nextRowKey(), leftLabel: '신중함', valuePercent: 80)],
        quotes: [QuoteDraft(key: nextRowKey(), body: '안녕', isSecret: true)],
        tags: ['앱테스트'],
      ),
    );
    final ids = [made.id];
    try {
      expect(made.traits.single.rightLabel, isNull); // 한쪽짜리
      expect(made.quotes.single.isSecret, isTrue);
      expect(made.fields.map((f) => f.label), defaultFieldLabels); // 값이 비어도 항목 이름이 있으면 남는다 (웹과 같음)
      // 상세 → 편집 값 → 다시 저장해도 그대로
      final again = await repo.save(made.id, CharacterDraft.fromDetail(made).copyWith(tagline: '고쳤어요'));
      expect(again.tagline, '고쳤어요');
      expect(again.traits.map((t) => t.leftLabel), ['신중함']);
      expect(again.tags, ['앱테스트']);

      // 1x1 PNG 올려서 갤러리 → 대표 → 빼기
      final png = base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==');
      final assetId = await repo.uploadImage(png, '앱 테스트.png');
      var d = await repo.addToGallery(made.id, assetId);
      expect(d.gallery.map((g) => g.id), contains(assetId));
      d = await repo.addToGallery(made.id, assetId, setPortrait: true);
      expect(d.portraitAssetId, assetId);
      d = await repo.removeFromGallery(made.id, assetId);
      expect(d.portraitAssetId, isNull);
      expect(d.gallery, isEmpty);

      await repo.setFavorite(made.id, true);
      expect((await repo.fetchDetail(made.id)).isFavorite, isTrue);
      final projects = await ProjectsRepositoryImpl(api).fetchList();
      if (projects.isNotEmpty) {
        expect((await repo.move(made.id, projects.first.id)).projectId, projects.first.id);
        expect((await repo.move(made.id, null)).projectId, isNull);
      }
      final forked = await repo.fork(made.id, null);
      ids.add(forked.id);
      expect(forked.id, isNot(made.id));
    } finally {
      for (final id in ids) {
        await repo.delete(id);
      }
    }
    await expectLater(repo.fetchDetail(made.id), throwsA(isA<ApiException>()));
  }, skip: skip);
}
