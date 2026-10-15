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
import 'package:loreshelf_app/features/gen/data/gen_repository_impl.dart';
import 'package:loreshelf_app/features/gen/domain/gen.dart';
import 'package:loreshelf_app/features/gen/domain/gen_draft.dart';
import 'package:loreshelf_app/features/home/data/home_repository_impl.dart';
import 'package:loreshelf_app/features/projects/data/projects_repository_impl.dart';
import 'package:loreshelf_app/features/projects/domain/project_draft.dart';
import 'package:loreshelf_app/features/search/data/search_repository_impl.dart';
import 'package:loreshelf_app/features/trash/data/trash_repository_impl.dart';
import 'package:loreshelf_app/features/trash/domain/trash_entry.dart';
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

  test('프로젝트 만들기 → 태그 직접 추가 → 고치기 → 휴지통', () async {
    final (api, _) = await login();
    final repo = ProjectsRepositoryImpl(api);
    final genres = await repo.fetchGenres();
    final custom = await repo.addGenre('앱테스트태그');
    final made = await repo.save(null, ProjectDraft(name: '앱 테스트 프로젝트', kind: 'chatbot', genres: [genres.first, custom]));
    try {
      expect(made.genres.map((g) => g.id), [genres.first.id, custom.id]);
      final again = await repo.save(made.id, ProjectDraft.fromDetail(made).copyWith(progressPercent: 35, genres: [custom]));
      expect(again.progressPercent, 35);
      expect(again.kind, 'chatbot');
      expect(again.genres.single.name, '앱테스트태그');
      expect((await repo.fetchGenres()).firstWhere((g) => g.id == custom.id).isCustom, isTrue);
    } finally {
      await api.delete('/api/projects/${made.id}');
      await repo.deleteGenre(custom.id);
    }
  }, skip: skip);

  test('프로젝트에 서재 캐릭터 연결 → 끊기, 휴지통 되살리기·영구 삭제, 검색', () async {
    final (api, _) = await login();
    final projectsRepo = ProjectsRepositoryImpl(api);
    final charactersRepo = CharactersRepositoryImpl(api);
    final trashRepo = TrashRepositoryImpl(api);
    final searchRepo = SearchRepositoryImpl(api);

    final project = await projectsRepo.save(null, const ProjectDraft(name: '앱 테스트 연결용 프로젝트'));
    final character = await charactersRepo.save(null, CharacterDraft.empty().copyWith(name: '앱 테스트 서재 캐릭터'));
    try {
      // 연결 — 역할을 붙이고, 역할만 다시 바꿔도(같은 캐릭터) upsert
      var linked = await projectsRepo.linkCharacter(project.id, character.id, role: '조언자');
      expect(linked.characters.single.role, '조언자');
      expect(linked.characters.single.membership, 'linked');
      linked = await projectsRepo.linkCharacter(project.id, character.id, role: '현자');
      expect(linked.characters.single.role, '현자');

      // 검색 — 이름으로 찾아진다 (project_name은 '전용' 캐릭터일 때만 붙음 — 연결은 project_id를 안 바꾼다)
      final found = await searchRepo.search('앱 테스트 서재 캐릭터');
      expect(found.characters.single.id, character.id);
      expect(found.characters.single.projectName, isNull);

      // 끊기 — 캐릭터는 서재에 남는다
      final unlinked = await projectsRepo.unlinkCharacter(project.id, character.id);
      expect(unlinked.characters, isEmpty);
      expect((await charactersRepo.fetchDetail(character.id)).projectId, isNull);

      // 휴지통 — 프로젝트를 지우면 목록에 뜨고, 되살리면 다시 안 보인다
      await api.delete('/api/projects/${project.id}');
      var trash = await trashRepo.fetchAll();
      final trashed = trash.projects.firstWhere((p) => p.id == project.id);
      expect(trashed.name, project.name);
      await trashRepo.restore(TrashKind.projects, project.id);
      trash = await trashRepo.fetchAll();
      expect(trash.projects.any((p) => p.id == project.id), isFalse);
      expect((await projectsRepo.fetchDetail(project.id)).name, project.name); // 되살아나서 다시 읽힌다
    } finally {
      await api.delete('/api/characters/${character.id}');
      await trashRepo.purge(TrashKind.characters, character.id);
      await api.delete('/api/projects/${project.id}');
      await trashRepo.purge(TrashKind.projects, project.id);
    }
    await expectLater(projectsRepo.fetchDetail(project.id), throwsA(isA<ApiException>()));
  }, skip: skip);

  test('고정 프롬프트·생성 기록 만들기 → 고치기 → ★대표로 → 지우기', () async {
    final (api, _) = await login();
    final charactersRepo = CharactersRepositoryImpl(api);
    final genRepo = GenRepositoryImpl(api);

    final character = await charactersRepo.save(null, CharacterDraft.empty().copyWith(name: '앱 테스트 gen 캐릭터'));
    try {
      // 사전·내 분류 사전은 읽기만 — 깨지지 않고 받아지는지만 확인
      final loras = await genRepo.fetchLoras();
      final learned = await genRepo.fetchLearnedDictionary();
      expect(learned, isA<Map<String, String>>());

      // 붙여넣은 글을 분류해서 고정 프롬프트로 저장
      final classified = classify('1girl, silver hair, masterpiece\nNegative prompt: lowres', learned: learned);
      var preset = await genRepo.savePreset(
        character.id,
        null,
        GenPresetDraft.empty().copyWith(name: '테스트 프리셋', tags: classified.tags, negative: classified.negative),
      );
      expect(preset.name, '테스트 프리셋');
      expect(preset.tags['character']!.map((t) => t.tag), contains('silver hair'));
      expect(preset.negative, ['lowres']);

      preset = await genRepo.savePreset(character.id, preset.id, GenPresetDraft.fromPreset(preset).copyWith(name: '테스트 프리셋 2'));
      expect(preset.name, '테스트 프리셋 2');
      final presets = await genRepo.fetchPresets(character.id);
      expect(presets.map((p) => p.id), contains(preset.id));

      // 생성 기록 만들기 → 고치기 → ★대표로
      var record = await genRepo.saveRecord(
        character.id,
        null,
        GenRecordDraft.empty().copyWith(
          title: '테스트 기록',
          platform: '테스트 플랫폼',
          model: '테스트 모델',
          genPresetId: preset.id,
          seed: 12345,
          steps: 20,
          loras: loras.isEmpty ? const [] : [GenLoraUse(genLoraId: loras.first.id, name: loras.first.name, weight: 0.8)],
        ),
      );
      expect(record.title, '테스트 기록');
      expect(record.platformName, '테스트 플랫폼'); // platform 이름으로 보내면 서버가 자동으로 만들어 붙인다
      expect(record.presetName, '테스트 프리셋 2');
      expect(record.seed, 12345);
      expect(record.isCover, isFalse);

      record = await genRepo.saveRecord(character.id, record.id, GenRecordDraft.fromRecord(record).copyWith(note: '메모예요'));
      expect(record.note, '메모예요');

      record = await genRepo.setCover(record.id);
      expect(record.isCover, isTrue);

      final records = await genRepo.fetchRecords(character.id);
      expect(records.first.id, record.id); // ★대표가 맨 앞

      await genRepo.deleteRecord(record.id);
      await genRepo.deletePreset(preset.id);
      expect(await genRepo.fetchRecords(character.id), isEmpty);
      expect(await genRepo.fetchPresets(character.id), isEmpty);
    } finally {
      await api.delete('/api/characters/${character.id}');
      await TrashRepositoryImpl(api).purge(TrashKind.characters, character.id);
    }
  }, skip: skip);
}
