// API 테스트 — 메모리 DB + 임시 폴더로 서버를 띄우지 않고 핸들러를 직접 부른다.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:server/app.dart';
import 'package:server/core/context.dart';
import 'package:server/core/db.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class Client {
  final Handler handler;
  String? cookie;
  Client(this.handler);

  Future<(int, dynamic)> call(String method, String path, [Object? data, Map<String, String>? headers]) async {
    final res = await handler(Request(method, Uri.parse('http://localhost$path'),
        body: data is Uint8List ? data : (data == null ? null : jsonEncode(data)),
        headers: {'cookie': ?cookie, ...?headers}));
    final setCookie = res.headers['set-cookie'];
    if (setCookie != null) cookie = setCookie.split(';').first;
    final type = res.headers['content-type'] ?? '';
    if (!type.startsWith('application/json')) return (res.statusCode, await res.read().expand((b) => b).toList());
    final text = await res.readAsString();
    return (res.statusCode, text.isEmpty ? null : jsonDecode(text));
  }

  Future<dynamic> ok(String method, String path, [Object? data, Map<String, String>? headers]) async {
    final (status, b) = await call(method, path, data, headers);
    expect(status, inInclusiveRange(200, 299), reason: '$method $path → $status $b');
    return b;
  }
}

Uint8List _png(int w, int h) {
  final image = img.Image(width: w, height: h, numChannels: 4);
  img.fill(image, color: img.ColorRgba8(200, 80, 60, 128));
  return img.encodePng(image);
}

void main() {
  late Directory tmp;
  late Client c;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('loreshelf_test');
    final app = AppContext(
      db: Db.memory(),
      config: Config(dbPath: ':memory:', assetsDir: '${tmp.path}/assets', migrationsDir: 'migrations', webDir: 'web', port: 0),
    );
    c = Client(buildApp(app));
  });

  tearDown(() => tmp.delete(recursive: true));

  Future<void> setup() => c.ok('POST', '/api/auth/setup', {'login_name': 'owner', 'password': 'password1', 'display_name': '주인장'});

  group('계정', () {
    test('처음엔 계정 만들기가 필요하고, 한 번 만들면 더 못 만든다', () async {
      expect((await c.ok('GET', '/api/auth/me'))['needs_setup'], isTrue);
      expect((await c.call('GET', '/api/home')).$1, 401);
      await setup();
      expect((await c.ok('GET', '/api/auth/me'))['user']['display_name'], '주인장');
      expect((await c.call('POST', '/api/auth/setup', {'login_name': 'other', 'password': 'password1'})).$1, 403);
    });

    test('로그아웃 → 틀린 비밀번호 거부 → 로그인', () async {
      await setup();
      await c.ok('POST', '/api/auth/logout');
      expect((await c.call('GET', '/api/home')).$1, 401);
      expect((await c.call('POST', '/api/auth/login', {'login_name': 'owner', 'password': 'wrong-pass'})).$1, 401);
      await c.ok('POST', '/api/auth/login', {'login_name': 'owner', 'password': 'password1'});
      expect((await c.ok('GET', '/api/home'))['counts']['characters'], 0);
    });

    test('설정: 허용된 값만 저장', () async {
      await setup();
      expect((await c.ok('PUT', '/api/settings', {'theme': 'dark'}))['theme'], 'dark');
      expect((await c.call('PUT', '/api/settings', {'theme': 'pink'})).$1, 400);
      expect((await c.call('PUT', '/api/settings', {'unknown': '1'})).$1, 400);
    });
  });

  group('세계관 · 프로젝트 · 캐릭터', () {
    setUp(setup);

    test('프로젝트 전용 / 서재 연결 / 분기 / 서재로 꺼내기', () async {
      final world = await c.ok('POST', '/api/worlds', {'name': '벨로트 대륙', 'visibility': 'public'});
      final project = await c.ok('POST', '/api/projects', {'name': '잿빛 왕관', 'kind': 'game', 'world_id': world['id']});
      final pid = project['id'];

      final lia = await c.ok('POST', '/api/characters', {
        'name': '리아 벨로트', 'project_id': pid, 'world_id': world['id'], 'theme_color': '#c9573f',
        'fields': [{'label': '나이', 'value': '23세'}, {'label': '비밀', 'value': '사실 공주', 'is_secret': true}, {'label': '', 'value': ''}],
        'traits': [{'left_label': '내향', 'right_label': '외향', 'value_percent': 28}],
        'quotes': [{'body': '따라오지 마.', 'situation': '첫 만남'}],
        'tags': ['#기사', '은발', '기사'],
      });
      expect(lia['project_name'], '잿빛 왕관');
      expect(lia['theme_color'], '#C9573F');
      expect((lia['fields'] as List).length, 2, reason: '빈 줄은 버림');
      expect(lia['fields'][1]['is_secret'], 1);
      expect(lia['tags'], ['기사', '은발']);

      final mir = await c.ok('POST', '/api/characters', {'name': '미르'}); // 서재
      await c.ok('POST', '/api/projects/$pid/characters', {'character_id': mir['id'], 'role': 'NPC'});
      expect((await c.call('POST', '/api/projects/$pid/characters', {'character_id': lia['id']})).$1, 400, reason: '전용은 연결 불가');

      var detail = await c.ok('GET', '/api/projects/$pid');
      final members = {for (final m in detail['characters'] as List) m['name']: m};
      expect(members['리아 벨로트']['membership'], 'own');
      expect(members['미르']['membership'], 'linked');
      expect(members['미르']['role'], 'NPC');

      final library = await c.ok('GET', '/api/characters?scope=library');
      expect([for (final x in library as List) x['name']], ['미르']);

      // 분기: 미르를 이 프로젝트용으로 복사
      final fork = await c.ok('POST', '/api/characters/${mir['id']}/fork', {'project_id': pid});
      expect(fork['source_character_id'], mir['id']);
      expect(fork['project_id'], pid);

      // 리아를 서재로 꺼내기
      final moved = await c.ok('POST', '/api/characters/${lia['id']}/move', {'project_id': null});
      expect(moved['project_id'], isNull);
      expect((moved['fields'] as List).length, 2);

      final w = await c.ok('GET', '/api/worlds/${world['id']}');
      expect((w['characters'] as List).length, 1);
      expect((w['projects'] as List).single['own_character_count'], 1); // 분기한 미르
      expect((w['projects'] as List).single['linked_character_count'], 1);
    });

    test('고치기: 딸린 칸은 통째로 바뀌고 안 쓰는 태그는 정리', () async {
      final ch = await c.ok('POST', '/api/characters', {'name': '카이엔', 'tags': ['마법사', '궁정']});
      final updated = await c.ok('PUT', '/api/characters/${ch['id']}', {
        'name': '카이엔', 'tagline': '시간을 훔치는 마법사', 'tags': ['마법사'], 'fields': [{'label': '키', 'value': '181cm'}],
      });
      expect(updated['tags'], ['마법사']);
      expect(updated['tagline'], '시간을 훔치는 마법사');
      final tags = await c.ok('GET', '/api/tags') as List;
      expect([for (final t in tags) t['name']], ['마법사']);
    });

    test('성격 축: 오른쪽을 비우면 한쪽짜리(강도)로 저장, 왼쪽은 필수', () async {
      final ch = await c.ok('POST', '/api/characters', {
        'name': '세린',
        'traits': [
          {'left_label': '내향', 'right_label': '외향', 'value_percent': 30},
          {'left_label': '신중함', 'right_label': '  ', 'value_percent': 80},
          {'left_label': '차분함', 'value_percent': 120},
        ],
      });
      final traits = (await c.ok('GET', '/api/characters/${ch['id']}'))['traits'] as List;
      expect([for (final t in traits) [t['left_label'], t['right_label'], t['value_percent']]], [
        ['내향', '외향', 30],
        ['신중함', null, 80],
        ['차분함', null, 100],
      ]);
      final bad = await c.call('PUT', '/api/characters/${ch['id']}', {
        'name': '세린', 'traits': [{'left_label': '', 'right_label': '외향'}],
      });
      expect(bad.$1, 400, reason: '왼쪽 없이 오른쪽만은 안 됨');
    });

    test('잘못된 값은 거부', () async {
      expect((await c.call('POST', '/api/characters', {'name': ''})).$1, 400);
      expect((await c.call('POST', '/api/characters', {'name': 'x', 'visibility': 'secret'})).$1, 400);
      expect((await c.call('POST', '/api/characters', {'name': 'x', 'theme_color': 'red'})).$1, 400);
      expect((await c.call('POST', '/api/characters', {'name': 'x', 'project_id': 999})).$1, 404);
      expect((await c.call('POST', '/api/projects', {'name': 'x', 'kind': 'novel'})).$1, 400);
      expect((await c.call('GET', '/api/characters/999')).$1, 404);
    });

    test('검색: 이름·태그·기본 정보·대사', () async {
      await c.ok('POST', '/api/characters', {
        'name': '서하린', 'tags': ['편의점'], 'fields': [{'label': '직업', 'value': '대학생'}], 'quotes': [{'body': '또 왔네.'}],
      });
      await c.ok('POST', '/api/worlds', {'name': '편의점 세계'});
      Future<String?> matched(String q) async => ((await c.ok('GET', '/api/search?q=${Uri.encodeComponent(q)}'))['characters'] as List).firstOrNull?['matched_in'] as String?;
      expect(await matched('하린'), 'name');
      expect(await matched('편의점'), 'tag');
      expect(await matched('대학생'), 'field');
      expect(await matched('또 왔'), 'quote');
      expect(await matched('100%'), isNull, reason: '% 는 글자 그대로');
      expect(((await c.ok('GET', '/api/search?q=편의점'))['worlds'] as List).length, 1);
    });

    test('휴지통: 프로젝트를 지우면 전용 캐릭터도 숨고, 되살리면 돌아온다. 영구 삭제하면 같이 삭제', () async {
      final p = await c.ok('POST', '/api/projects', {'name': '임시', 'kind': 'etc'});
      await c.ok('POST', '/api/characters', {'name': 'NPC', 'project_id': p['id']});
      await c.ok('DELETE', '/api/projects/${p['id']}');
      expect((await c.ok('GET', '/api/characters') as List), isEmpty);
      expect((await c.ok('GET', '/api/trash'))['projects'][0]['own_character_count'], 1);

      await c.ok('POST', '/api/trash/projects/${p['id']}/restore');
      expect((await c.ok('GET', '/api/characters') as List).length, 1);

      await c.ok('DELETE', '/api/projects/${p['id']}');
      await c.ok('DELETE', '/api/trash/projects/${p['id']}');
      expect((await c.ok('GET', '/api/trash'))['projects'], isEmpty);
      expect((await c.ok('GET', '/api/home'))['counts']['characters'], 0);
      expect((await c.call('DELETE', '/api/trash/nothing/1')).$1, 404);
    });
  });

  group('장르·세계관 태그', () {
    setUp(setup);

    test('기본 목록 → 프로젝트에 붙이기 → 태그로 거르기 → 검색 → 직접 추가·삭제', () async {
      final list = await c.ok('GET', '/api/genres') as List;
      expect(list.length, greaterThan(100));
      int idOf(String name) => list.firstWhere((g) => g['name'] == name)['id'] as int;
      final rofan = idOf('로맨스 판타지'), school = idOf('학원'), revenge = idOf('복수');
      expect({for (final g in list) g['category']}, containsAll(['genre', 'setting', 'mood', 'trope', 'game']));

      final p = await c.ok('POST', '/api/projects', {'name': '잿빛 왕관', 'kind': 'game', 'genre_ids': [rofan, revenge, rofan]});
      expect([for (final g in p['genres'] as List) g['name']], containsAll(['로맨스 판타지', '복수']));
      expect((p['genres'] as List).length, 2, reason: '중복은 하나로');
      await c.ok('POST', '/api/projects', {'name': '별빛 학원', 'kind': 'etc', 'genre_ids': [school]});

      final filtered = await c.ok('GET', '/api/projects?genre_id=$rofan') as List;
      expect([for (final x in filtered) x['name']], ['잿빛 왕관']);
      expect(((await c.ok('GET', '/api/search?q=${Uri.encodeComponent('판타지')}'))['projects'] as List).single['name'], '잿빛 왕관');

      // genre_ids 없이 고치면 태그는 그대로, 빈 목록이면 다 빠짐
      var u = await c.ok('PUT', '/api/projects/${p['id']}', {'name': '잿빛 왕관', 'kind': 'game', 'progress_percent': 10});
      expect((u['genres'] as List).length, 2);
      u = await c.ok('PUT', '/api/projects/${p['id']}', {'name': '잿빛 왕관', 'kind': 'game', 'genre_ids': []});
      expect(u['genres'], isEmpty);

      // 전용 캐릭터 상세에 프로젝트 태그가 같이 온다
      await c.ok('PUT', '/api/projects/${p['id']}', {'name': '잿빛 왕관', 'kind': 'game', 'genre_ids': [revenge]});
      final ch = await c.ok('POST', '/api/characters', {'name': '리아', 'project_id': p['id']});
      expect([for (final g in ch['project_genres'] as List) g['name']], ['복수']);

      // 직접 추가: 기본 제공과 같은 이름이면 그 태그를 돌려줌
      expect((await c.ok('POST', '/api/genres', {'name': '#학원'}))['id'], school);
      final mine = await c.ok('POST', '/api/genres', {'name': '왕녀 생존기'});
      expect(mine['category'], 'custom');
      expect((await c.call('DELETE', '/api/genres/$school')).$1, 404, reason: '기본 제공은 못 지움');
      await c.ok('DELETE', '/api/genres/${mine['id']}');
      expect((await c.call('POST', '/api/projects', {'name': 'x', 'genre_ids': [999999]})).$1, 404);
    });
  });

  group('이미지', () {
    setUp(setup);

    test('올리기 → 썸네일 → 갤러리·대표 이미지 → 같은 파일은 한 번만 저장', () async {
      final png = _png(1200, 800);
      final asset = await c.ok('POST', '/api/assets', png, {'x-file-name': Uri.encodeComponent('리아.png')});
      expect(asset['width'], 1200);
      expect(asset['mime_type'], 'image/png');
      expect(asset['original_name'], '리아.png');

      final again = await c.ok('POST', '/api/assets', png, {'x-file-name': 'copy.png'});
      expect(again['id'], asset['id']);

      final (thumbStatus, thumb) = await c.call('GET', '/api/assets/${asset['id']}/thumb');
      expect(thumbStatus, 200);
      final decoded = img.decodeJpg(Uint8List.fromList(thumb as List<int>))!;
      expect(decoded.width, 480);
      expect(decoded.height, 320);

      final ch = await c.ok('POST', '/api/characters', {'name': '리아'});
      var d = await c.ok('POST', '/api/characters/${ch['id']}/assets', {'asset_id': asset['id'], 'set_portrait': true});
      expect(d['portrait_asset_id'], asset['id']);
      expect((d['gallery'] as List).length, 1);
      d = await c.ok('DELETE', '/api/characters/${ch['id']}/assets/${asset['id']}');
      expect(d['portrait_asset_id'], isNull);
    });

    test('이미지가 아닌 파일은 거부', () async {
      final (status, _) = await c.call('POST', '/api/assets', Uint8List.fromList(utf8.encode('<script>alert(1)</script>')));
      expect(status, 415);
    });
  });

  group('이미지·프롬프트 (2단계)', () {
    setUp(setup);

    const sample = '1girl, lia bellot, silver hair, silver armor, smile, <lora:liaBellot_v2:0.8>\n'
        'Negative prompt: lowres, bad hands\n'
        'Steps: 28, Sampler: Euler a, CFG scale: 6, Seed: 2984471023, Size: 832x1216, Model: illustriousXL_v01';

    test('자동 분류 + 내 사전 학습', () async {
      var p = await c.ok('POST', '/api/gen/parse', {'text': sample});
      expect(p['platform'], 'Stable Diffusion WebUI');
      expect(p['categories']['etc'], [{'tag': 'lia bellot', 'weight': 1.0}]);
      expect(p['loras'], [{'name': 'liaBellot_v2', 'weight': 0.8}]);
      expect(p['settings']['Seed'], '2984471023');

      final rule = await c.ok('POST', '/api/gen/tag-rules', {'tag': 'Lia_Bellot', 'category': 'character'});
      expect(rule['tag'], 'lia bellot');
      p = await c.ok('POST', '/api/gen/parse', {'text': sample});
      expect(p['categories']['etc'], isNull);
      expect((p['categories']['character'] as List).map((t) => t['tag']), contains('lia bellot'));
      // 같은 태그를 다시 옮기면 카테고리만 바뀐다
      await c.ok('POST', '/api/gen/tag-rules', {'tag': 'lia bellot', 'category': 'etc'});
      expect((await c.ok('GET', '/api/gen/tag-rules') as List).length, 1);
      expect((await c.call('POST', '/api/gen/tag-rules', {'tag': 'x', 'category': 'weird'})).$1, 400);
      await c.ok('DELETE', '/api/gen/tag-rules/${rule['id']}');
      expect(await c.ok('GET', '/api/gen/tag-rules'), isEmpty);
    });

    test('플랫폼(기본 4개)·모델·LoRA 목록', () async {
      final platforms = await c.ok('GET', '/api/gen/platforms') as List;
      expect(platforms.map((p) => p['name']), ['NovelAI', 'Stable Diffusion WebUI', 'ComfyUI', 'Midjourney']);
      final sd = platforms[1];
      final m = await c.ok('POST', '/api/gen/models', {'gen_platform_id': sd['id'], 'name': 'illustriousXL_v01', 'base_model': 'Illustrious'});
      expect(m['base_model'], 'Illustrious');
      expect((await c.ok('GET', '/api/gen/platforms') as List)[1]['models'].length, 1);
      await c.ok('PUT', '/api/gen/platforms/${sd['id']}', {'name': 'Forge'});
      expect((await c.call('PUT', '/api/gen/platforms/${sd['id']}', {'name': 'NovelAI'})).$1, 409);

      final l = await c.ok('POST', '/api/gen/loras', {'name': 'liaBellot_v2', 'trigger_words': 'lia bellot', 'default_weight': 0.8});
      expect(l['default_weight'], 0.8);
      expect((await c.call('POST', '/api/gen/loras', {'name': 'LIABELLOT_V2'})).$1, 409);
      expect((await c.call('PUT', '/api/gen/loras/${l['id']}', {'default_weight': 99})).$1, 400);
      await c.ok('PUT', '/api/gen/loras/${l['id']}', {'note': '캐릭터 LoRA'});
      expect((await c.ok('GET', '/api/gen/loras') as List).single['note'], '캐릭터 LoRA');
    });

    test('고정 프롬프트(의상 프리셋)', () async {
      final ch = await c.ok('POST', '/api/characters', {'name': '리아'});
      final lora = await c.ok('POST', '/api/gen/loras', {'name': 'liaBellot_v2', 'default_weight': 0.8});
      final preset = await c.ok('POST', '/api/characters/${ch['id']}/gen-presets', {
        'name': '전투복',
        'tags': {
          'character': [{'tag': 'silver hair', 'weight': 1.2}],
          'outfit': [{'tag': 'silver armor'}],
          'weird': ['oops'],
        },
        'negative': 'lowres, bad hands',
        'loras': [{'name': 'liaBellot_v2'}],
      });
      expect(preset['tags']['character'], [{'tag': 'silver hair', 'weight': 1.2}]);
      expect(preset['tags']['outfit'], [{'tag': 'silver armor', 'weight': 1.0}]);
      expect(preset['tags']['etc'], [{'tag': 'oops', 'weight': 1.0}]);
      expect(preset['negative'], ['lowres', 'bad hands']);
      expect(preset['loras'].single['gen_lora_id'], lora['id']);
      expect(preset['loras'].single['weight'], 0.8);

      expect((await c.call('POST', '/api/characters/${ch['id']}/gen-presets', {'name': '평상복', 'loras': [{'name': '없는것'}]})).$1, 400);
      await c.ok('PUT', '/api/gen/presets/${preset['id']}', {'name': '전투복 v2', 'loras': []});
      final list = await c.ok('GET', '/api/characters/${ch['id']}/gen-presets') as List;
      expect(list.single['name'], '전투복 v2');
      expect(list.single['loras'], isEmpty);
      expect(list.single['tags']['outfit'], isNotEmpty); // 안 보낸 칸은 그대로
      await c.ok('DELETE', '/api/gen/presets/${preset['id']}');
      expect(await c.ok('GET', '/api/characters/${ch['id']}/gen-presets'), isEmpty);
    });

    test('PNG 생성 정보 읽기 → 생성 기록 (플랫폼·모델 자동 추가, ★대표는 하나)', () async {
      final ch = await c.ok('POST', '/api/characters', {'name': '리아'});
      final image = img.Image(width: 4, height: 4)..textData = {'parameters': sample};
      final asset = await c.ok('POST', '/api/assets', img.encodePng(image), {'x-file-name': 'gen.png'});
      final read = await c.ok('GET', '/api/gen/png-info/${asset['id']}');
      final info = read['info'];
      expect(info['platform'], 'Stable Diffusion WebUI');
      expect([info['seed'], info['steps'], info['cfg_scale'], info['width'], info['height']], [2984471023, 28, 6.0, 832, 1216]);
      expect(info['model'], 'illustriousXL_v01');

      final plain = await c.ok('POST', '/api/assets', _png(5, 5), {'x-file-name': 'plain.png'});
      expect((await c.ok('GET', '/api/gen/png-info/${plain['id']}'))['info'], isNull);

      final lora = await c.ok('POST', '/api/gen/loras', {'name': 'liaBellot_v2'});
      final rec = await c.ok('POST', '/api/characters/${ch['id']}/gen-records', {
        'asset_id': asset['id'],
        'platform': info['platform'],
        'model': info['model'],
        'prompt_raw': info['prompt_raw'],
        'tags': info['parsed']['categories'],
        'negative': info['parsed']['negative'],
        'loras': [...(info['parsed']['loras'] as List), {'name': 'unknownLora', 'weight': 0.5}],
        'seed': info['seed'], 'steps': info['steps'], 'cfg_scale': info['cfg_scale'], 'sampler': info['sampler'],
        'width': info['width'], 'height': info['height'],
        'extra': info['extra'],
        'is_cover': true,
      });
      expect(rec['platform_name'], 'Stable Diffusion WebUI');
      expect(rec['model_name'], 'illustriousXL_v01');
      expect(rec['seed'], 2984471023);
      expect(rec['loras'], [
        {'gen_lora_id': lora['id'], 'name': 'liaBellot_v2', 'weight': 0.8},
        {'gen_lora_id': null, 'name': 'unknownLora', 'weight': 0.5},
      ]);
      expect(rec['is_cover'], 1);
      final platforms = await c.ok('GET', '/api/gen/platforms') as List;
      expect(platforms.where((p) => p['name'] == 'Stable Diffusion WebUI').single['models'].single['name'], 'illustriousXL_v01');

      final second = await c.ok('POST', '/api/characters/${ch['id']}/gen-records', {'title': '두 번째', 'is_cover': 1});
      final list = await c.ok('GET', '/api/characters/${ch['id']}/gen-records') as List;
      expect(list.map((r) => [r['id'], r['is_cover']]), [[second['id'], 1], [rec['id'], 0]]);

      expect((await c.call('PUT', '/api/gen/records/${rec['id']}', {'seed': 'abc'})).$1, 400);
      expect((await c.call('PUT', '/api/gen/records/${rec['id']}', {'model': 'x', 'gen_platform_id': null})).$1, 400);
      final edited = await c.ok('PUT', '/api/gen/records/${rec['id']}', {'note': '손이 잘 나옴', 'loras': []});
      expect(edited['note'], '손이 잘 나옴');
      expect(edited['loras'], isEmpty);
      expect(edited['seed'], 2984471023);

      await c.ok('DELETE', '/api/gen/records/${rec['id']}');
      expect((await c.call('GET', '/api/gen/records/${rec['id']}')).$1, 404);
    });

    test('다른 캐릭터의 프리셋은 못 씀, 휴지통의 캐릭터는 못 봄', () async {
      final a = await c.ok('POST', '/api/characters', {'name': 'A'});
      final b = await c.ok('POST', '/api/characters', {'name': 'B'});
      final preset = await c.ok('POST', '/api/characters/${a['id']}/gen-presets', {'name': '기본'});
      expect((await c.call('POST', '/api/characters/${b['id']}/gen-records', {'gen_preset_id': preset['id']})).$1, 400);
      await c.ok('DELETE', '/api/characters/${a['id']}');
      expect((await c.call('GET', '/api/characters/${a['id']}/gen-presets')).$1, 404);
      expect((await c.call('PUT', '/api/gen/presets/${preset['id']}', {'name': 'x'})).$1, 404);
    });
  });
}
