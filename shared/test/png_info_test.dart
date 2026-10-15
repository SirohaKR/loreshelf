import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart' show ZLibEncoder, getCrc32;
import 'package:loreshelf_shared/loreshelf_shared.dart';
import 'package:test/test.dart';

// 테스트용 PNG: 1x1 IHDR + 텍스트 칸들 + IEND (그림 데이터는 필요 없음)
Uint8List png(List<(String, List<int>)> chunks) {
  final b = BytesBuilder()..add([137, 80, 78, 71, 13, 10, 26, 10]);
  void chunk(String type, List<int> data) {
    final head = ByteData(4)..setUint32(0, data.length);
    final typed = [...ascii.encode(type), ...data];
    final crc = ByteData(4)..setUint32(0, getCrc32(typed));
    b
      ..add(head.buffer.asUint8List())
      ..add(typed)
      ..add(crc.buffer.asUint8List());
  }

  chunk('IHDR', [0, 0, 0, 1, 0, 0, 0, 1, 8, 6, 0, 0, 0]);
  for (final (t, d) in chunks) {
    chunk(t, d);
  }
  chunk('IEND', []);
  return b.toBytes();
}

List<int> tEXt(String k, String v) => [...latin1.encode(k), 0, ...utf8.encode(v)];
List<int> zTXt(String k, String v) => [...latin1.encode(k), 0, 0, ...ZLibEncoder().encode(latin1.encode(v))];
List<int> iTXt(String k, String v, {bool compress = false}) => [
      ...latin1.encode(k), 0, compress ? 1 : 0, 0, 0, 0, // 언어·번역 키워드는 비움
      ...(compress ? ZLibEncoder().encode(utf8.encode(v)) : utf8.encode(v)),
    ];

const webui = '1girl, silver hair, <lora:lia:0.7>\nNegative prompt: lowres\n'
    'Steps: 30, Sampler: Euler a, CFG scale: 5.5, Seed: 42, Size: 832x1216, Model hash: abc123, Model: illustriousXL, Lora hashes: "lia: 9f9f"';

void main() {
  test('PNG가 아니면 빈 결과', () {
    expect(readPngText(Uint8List.fromList([1, 2, 3])), isEmpty);
    expect(readGenerationInfo(Uint8List.fromList(utf8.encode('GIF89a...'))), isNull);
  });

  test('tEXt · zTXt · iTXt(압축/비압축) 모두 읽는다', () {
    final t = readPngText(png([
      ('tEXt', tEXt('a', '하나')),
      ('zTXt', zTXt('b', 'two')),
      ('iTXt', iTXt('c', '셋')),
      ('iTXt', iTXt('d', '넷 four', compress: true)),
    ]));
    expect(t, {'a': '하나', 'b': 'two', 'c': '셋', 'd': '넷 four'});
  });

  test('정보 없는 PNG는 null', () {
    expect(readGenerationInfo(png([('tEXt', tEXt('Software', 'paint'))])), isNull);
  });

  test('WebUI parameters', () {
    final g = readGenerationInfo(png([('iTXt', iTXt('parameters', webui))]))!;
    expect(g.platform, PromptPlatform.webui);
    expect(g.promptRaw, webui);
    expect((g.seed, g.steps, g.sampler, g.cfgScale, g.width, g.height, g.model), (42, 30, 'Euler a', 5.5, 832, 1216, 'illustriousXL'));
    expect(g.parsed.loras.single.name, 'lia');
    expect(g.parsed.negative, ['lowres']);
    expect(g.extra['Model hash'], 'abc123');
    expect(g.extra['Lora hashes'], 'lia: 9f9f');
  });

  test('NovelAI Comment', () {
    final comment = jsonEncode({
      'prompt': '1girl, {silver hair}, red eyes',
      'uc': 'lowres, bad hands',
      'seed': 777,
      'steps': 28,
      'scale': 5,
      'sampler': 'k_euler_ancestral',
      'width': 832,
      'height': 1216,
      'noise_schedule': 'karras',
    });
    final g = readGenerationInfo(png([
      ('tEXt', tEXt('Software', 'NovelAI')),
      ('tEXt', tEXt('Source', 'NovelAI Diffusion V4.5 4BDE2A90')),
      ('tEXt', tEXt('Comment', comment)),
    ]))!;
    expect(g.platform, PromptPlatform.novelai);
    expect(g.promptRaw, '1girl, {silver hair}, red eyes');
    expect(g.parsed.tagsOf('character').map((t) => t.toString()), ['1girl:1.0', 'silver hair:1.05', 'red eyes:1.0']);
    expect(g.parsed.negative, ['lowres', 'bad hands']);
    expect((g.seed, g.steps, g.cfgScale, g.width, g.height), (777, 28, 5.0, 832, 1216));
    expect(g.model, 'NovelAI Diffusion V4.5 4BDE2A90');
    expect(g.extra, {'noise_schedule': 'karras'});
  });

  test('ComfyUI 그래프에서 KSampler를 따라가 찾는다', () {
    final graph = {
      '4': {'class_type': 'CheckpointLoaderSimple', 'inputs': {'ckpt_name': 'illustriousXL_v01.safetensors'}},
      '10': {'class_type': 'LoraLoader', 'inputs': {'lora_name': 'chars/lia_v2.safetensors', 'strength_model': 0.8, 'model': ['4', 0]}},
      '5': {'class_type': 'EmptyLatentImage', 'inputs': {'width': 832, 'height': 1216, 'batch_size': 1}},
      '6': {'class_type': 'CLIPTextEncode', 'inputs': {'text': '1girl, silver hair, smile', 'clip': ['10', 1]}},
      '7': {'class_type': 'CLIPTextEncode', 'inputs': {'text': 'lowres, bad hands', 'clip': ['10', 1]}},
      '3': {
        'class_type': 'KSampler',
        'inputs': {'seed': 123, 'steps': 25, 'cfg': 6.5, 'sampler_name': 'euler', 'scheduler': 'normal', 'positive': ['6', 0], 'negative': ['7', 0]},
      },
    };
    final g = readGenerationInfo(png([
      ('tEXt', tEXt('prompt', jsonEncode(graph))),
      ('tEXt', tEXt('workflow', '{"nodes":[]}')),
    ]))!;
    expect(g.platform, PromptPlatform.comfyui);
    expect(g.promptRaw, '1girl, silver hair, smile');
    expect(g.parsed.negative, ['lowres', 'bad hands']);
    expect((g.seed, g.steps, g.cfgScale, g.sampler, g.width, g.height), (123, 25, 6.5, 'euler', 832, 1216));
    expect(g.model, 'illustriousXL_v01.safetensors');
    expect(g.parsed.loras.single.toJson(), {'name': 'lia_v2', 'weight': 0.8});
    expect(g.extra['workflow'], '{"nodes":[]}');
  });

  test('칸 하나가 깨져도 나머지는 읽는다', () {
    final t = readPngText(png([
      ('zTXt', [...latin1.encode('bad'), 0, 0, 1, 2, 3]),
      ('tEXt', tEXt('ok', 'yes')),
    ]));
    expect(t, {'ok': 'yes'});
  });
}
