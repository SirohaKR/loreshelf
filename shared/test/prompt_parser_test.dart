import 'package:loreshelf_shared/loreshelf_shared.dart';
import 'package:test/test.dart';

// 목업 prompt.html의 예시와 같은 것 (JS 프로토타입 결과와 맞춰 봄)
const sample = '''masterpiece, best quality, 1girl, solo, lia bellot, (silver hair:1.2), long hair, side braid, red eyes, scar on cheek, silver armor, red cape, holding sword, light smile, looking at viewer, cowboy shot, castle ruins, embers, sunset, backlighting, anime coloring, <lora:liaBellot_v2:0.8>, <lora:flatColor:0.4>
Negative prompt: lowres, bad anatomy, bad hands, worst quality, watermark
Steps: 28, Sampler: Euler a, CFG scale: 6, Seed: 2984471023, Size: 832x1216, Model: illustriousXL_v01''';

List<String> tags(ParsedPrompt p, String k) => [for (final t in p.tagsOf(k)) t.tag];

void main() {
  group('WebUI 형식', () {
    final p = parsePrompt(sample);

    test('플랫폼·설정', () {
      expect(p.platform, PromptPlatform.webui);
      expect(p.seed, 2984471023);
      expect(p.steps, 28);
      expect(p.sampler, 'Euler a');
      expect(p.cfgScale, 6);
      expect(p.size, (832, 1216));
      expect(p.model, 'illustriousXL_v01');
    });

    test('카테고리 분류 — JS 프로토타입과 같다 (21개 중 미분류 1개)', () {
      expect(tags(p, 'quality'), ['masterpiece', 'best quality']);
      expect(tags(p, 'character'), ['1girl', 'solo', 'silver hair', 'long hair', 'side braid', 'red eyes', 'scar on cheek']);
      expect(tags(p, 'outfit'), ['silver armor', 'red cape']);
      expect(tags(p, 'pose'), ['holding sword', 'looking at viewer', 'cowboy shot']);
      expect(tags(p, 'expression'), ['light smile']);
      expect(tags(p, 'background'), ['castle ruins', 'embers', 'sunset', 'backlighting']);
      expect(tags(p, 'style'), ['anime coloring']);
      expect(tags(p, 'etc'), ['lia bellot']);
      expect(p.tagsOf('character')[2], const PromptTag('silver hair', 1.2));
    });

    test('네거티브·LoRA', () {
      expect(p.negative, ['lowres', 'bad anatomy', 'bad hands', 'worst quality', 'watermark']);
      expect([for (final l in p.loras) '${l.name}:${l.weight}'], ['liaBellot_v2:0.8', 'flatColor:0.4']);
    });

    test('toJson은 tags_json 형식', () {
      final j = p.toJson();
      expect((j['categories'] as Map)['outfit'], [
        {'tag': 'silver armor', 'weight': 1.0},
        {'tag': 'red cape', 'weight': 1.0},
      ]);
    });
  });

  test('내 사전이 기본 규칙보다 먼저', () {
    final p = parsePrompt('lia bellot, red cape', learned: {'lia bellot': 'character', 'red cape': 'etc'});
    expect(tags(p, 'character'), ['lia bellot']);
    expect(tags(p, 'etc'), ['red cape']);
  });

  test('밑줄·대소문자는 같은 태그로 본다', () {
    expect(normalizeTag('Silver_Hair '), 'silver hair');
    expect(classifyTag('Long_Hair'), 'character');
  });

  group('가중치', () {
    test('여러 표기', () {
      expect(parseWeight('(tag:1.3)'), const PromptTag('tag', 1.3));
      expect(parseWeight('((tag))'), const PromptTag('tag', 1.21));
      expect(parseWeight('{{tag}}'), const PromptTag('tag', 1.1));
      expect(parseWeight('[tag]'), const PromptTag('tag', 0.91));
      expect(parseWeight('1.2::tag::'), const PromptTag('tag', 1.2));
      expect(parseWeight('-0.5::tag'), const PromptTag('tag', -0.5));
      expect(parseWeight('plain'), const PromptTag('plain', 1));
    });
  });

  test('NovelAI 감지', () {
    final p = parsePrompt('1girl, {{silver hair}}, 1.3::red eyes::');
    expect(p.platform, PromptPlatform.novelai);
    expect(p.tagsOf('character').map((t) => t.toString()), ['1girl:1.0', 'silver hair:1.1', 'red eyes:1.3']);
  });

  test('Midjourney 파라미터', () {
    final p = parsePrompt('a silver-haired knight standing in ruins --ar 2:3 --niji 6 --tile');
    expect(p.platform, PromptPlatform.midjourney);
    expect(p.settings, {'--ar': '2:3', '--niji': '6', '--tile': 'on'});
    expect(p.tagsOf('etc').length + p.tagsOf('pose').length, 1); // 문장은 한 덩어리
  });

  test('WebUI 설정 줄: 따옴표 안의 쉼표는 자르지 않는다', () {
    final s = parseWebuiSettings('Steps: 20, Sampler: DPM++ 2M Karras, Lora hashes: "a: 1abc, b: 2def", Model hash: 4f2a, Version: v1.10.1');
    expect(s['Lora hashes'], 'a: 1abc, b: 2def');
    expect(s['Model hash'], '4f2a');
    expect(s['Sampler'], 'DPM++ 2M Karras');
    expect(s['Version'], 'v1.10.1');
  });

  group('프롬프트 글로 만들기', () {
    final tags = {
      'quality': [const PromptTag('masterpiece', 1)],
      'character': [const PromptTag('1girl', 1), const PromptTag('silver hair', 1.2)],
    };
    test('SD 형식: 카테고리 순서, 가중치, LoRA, 네거티브 줄', () {
      expect(formatPrompt(tags, negative: ['lowres'], loras: [const PromptLora('lia', 0.8)]),
          '1girl, (silver hair:1.2), masterpiece, <lora:lia:0.8>\nNegative prompt: lowres');
    });
    test('NovelAI 형식: LoRA 없음', () {
      expect(formatPrompt(tags, loras: [const PromptLora('lia', 1)], novelai: true), '1girl, 1.2::silver hair::, masterpiece');
    });
    test('다시 나누면 같은 태그', () {
      final p = parsePrompt(formatPrompt(tags, negative: ['lowres']));
      expect(p.tagsOf('character'), tags['character']);
      expect(p.negative, ['lowres']);
    });
  });

  group('긴 태그 나열 프롬프트 (사용자 예시)', () {
    const text = '''1person, anime style, illustration, comic style, 2D, bold lines, fine linework, sharp outlines, highly detailed, realistic color palette, detailed hair, flat color, cel shading, masterpiece, best quality, detail illustration, 1boy, solo, adult male, young man, black hair, short hair, 7:3 parted hair, side-swept bangs, messy bangs, hair between eyes, bangs partially covering one eye, textured hair, red eyes, sharp eyes, half-closed eyes, droopy eyelids, slight dark circles under eyes, detail eyes, slender face, sharp jawline, pale skin, handsome, quiet and prudent impression, (portrait:1.3), (chest-up:1.3), (close-up:1.2), (character fills the frame:1.2), front view, slight head tilt, (holding bouquet:1.3), (offering bouquet:1.2), bouquet in front of chest, giving flowers, looking at viewer, (faint blush:0.7), light blush on cheeks, shy, slight smile, closed mouth, white dress shirt, black vest, loosened cravat, bouquet, red roses, white roses, baby's breath, wrapped bouquet, ribbon, (white background:1.3), simple background, soft lighting''';
    final p = parsePrompt(text);

    test('미분류 없음, 칸마다 맞게', () {
      expect(tags(p, 'etc'), isEmpty);
      expect(tags(p, 'quality'), ['highly detailed', 'masterpiece', 'best quality']);
      expect(tags(p, 'style'), ['anime style', 'illustration', 'comic style', '2D', 'bold lines', 'fine linework', 'sharp outlines', 'realistic color palette', 'flat color', 'cel shading', 'detail illustration']);
      expect(tags(p, 'personality'), ['quiet and prudent impression', 'shy']);
      expect(tags(p, 'character'), [
        '1person', 'detailed hair', '1boy', 'solo', 'adult male', 'young man', 'black hair', 'short hair', '7:3 parted hair', 'side-swept bangs', 'messy bangs',
        'hair between eyes', 'bangs partially covering one eye', 'textured hair', 'red eyes', 'sharp eyes', 'droopy eyelids', 'slight dark circles under eyes',
        'detail eyes', 'slender face', 'sharp jawline', 'pale skin', 'handsome',
      ]);
      expect(tags(p, 'expression'), ['half-closed eyes', 'faint blush', 'light blush on cheeks', 'slight smile', 'closed mouth']);
      expect(tags(p, 'pose'), [
        'portrait', 'chest-up', 'close-up', 'character fills the frame', 'front view', 'slight head tilt', 'holding bouquet', 'offering bouquet',
        'bouquet in front of chest', 'giving flowers', 'looking at viewer',
      ]);
      expect(tags(p, 'outfit'), ['white dress shirt', 'black vest', 'loosened cravat']);
      expect(tags(p, 'props'), ['bouquet', 'red roses', 'white roses', "baby's breath", 'wrapped bouquet', 'ribbon']);
      expect(tags(p, 'background'), ['white background', 'simple background', 'soft lighting']);
    });
  });

  group('같은 계열 단어', () {
    final cases = {
      'personality': ['cheerful', 'cold', 'gentle', 'very shy', 'calm and gentle', 'tsundere', 'mysterious aura', 'cold impression', 'kind personality'],
      'character': ['round face', 'narrow eyes', 'tsurime eyes', 'thick eyebrows', 'long eyelashes', 'square jaw', 'tanned skin', 'beautiful'],
      'style': ['thick lines', 'clean lineart', 'soft shading', 'pastel colors', 'semi-realistic', 'digital painting', 'manhwa', '2.5D'],
      'quality': ['ultra detailed', 'intricate details', 'absurdres', 'sharp focus'],
      'pose': ['from front', 'three-quarter view', 'waist-up', 'tilted head', 'low angle', 'carrying bag', 'handing letter', 'hand on own chest', 'upper body'],
      'outfit': ['black necktie', 'red bow tie', 'ascot', 'brown waistcoat', 'white blouse', 'black trousers', 'hair ribbon', 'pearl necklace', 'loafers'],
      'props': ['flower', 'lily', 'sunflowers', 'gift box', 'red ribbon', 'umbrella', 'teacup', 'sword', 'book'],
      'background': ['flower field', 'falling petals', 'cherry blossoms', 'garden', 'sunlight', 'blurry background'],
      'expression': ['gentle smile', 'embarrassed', 'teary eyes', 'smug', 'parted lips'],
    };
    for (final MapEntry(key: cat, value: list) in cases.entries) {
      for (final t in list) {
        test('$t → $cat', () => expect(classifyTag(t), cat));
      }
    }
    test('동작이 먼저: giving flowers는 배경이 아니라 포즈', () => expect(classifyTag('giving flowers'), 'pose'));
  });

  test('카테고리 키·라벨·기본 행선지가 서로 맞다', () {
    expect(promptCategoryLabels.keys.toList(), promptCategoryKeys);
    expect(promptCategoryDefaultTarget.keys.toSet(), promptCategoryKeys.toSet());
  });

  test('빈 입력', () {
    final p = parsePrompt('  \n ');
    expect(p.platform, isNull);
    expect(p.categories, isEmpty);
  });
}
