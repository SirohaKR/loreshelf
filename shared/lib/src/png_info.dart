// PNG 안에 숨은 생성 정보 읽기 (외부 API 없음).
// - SD WebUI / Forge: `parameters` 텍스트 → parsePrompt 그대로
// - NovelAI: `Comment` JSON (prompt, uc, seed, steps, scale, sampler, width, height) + `Source`(모델)
// - ComfyUI: `prompt`(API 형식 그래프) + `workflow` JSON → KSampler에서 거꾸로 따라가 프롬프트·설정 찾기

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart' show ZLibDecoder;

import 'prompt_parser.dart';

const _pngSignature = [137, 80, 78, 71, 13, 10, 26, 10];

bool isPng(List<int> bytes) {
  if (bytes.length < 8) return false;
  for (var i = 0; i < 8; i++) {
    if (bytes[i] != _pngSignature[i]) return false;
  }
  return true;
}

/// PNG의 텍스트 칸(tEXt / zTXt / iTXt) 전부 → {키워드: 내용}. PNG가 아니거나 깨졌으면 읽은 데까지.
Map<String, String> readPngText(Uint8List bytes) {
  final out = <String, String>{};
  if (!isPng(bytes)) return out;
  final view = ByteData.sublistView(bytes);
  var pos = 8;
  while (pos + 8 <= bytes.length) {
    final len = view.getUint32(pos);
    final type = String.fromCharCodes(bytes, pos + 4, pos + 8);
    final start = pos + 8;
    final end = start + len;
    if (end + 4 > bytes.length) break;
    final data = Uint8List.sublistView(bytes, start, end);
    try {
      final entry = switch (type) {
        'tEXt' => _tEXt(data),
        'zTXt' => _zTXt(data),
        'iTXt' => _iTXt(data),
        _ => null,
      };
      if (entry != null) out[entry.$1] = entry.$2;
    } on Object {
      // 칸 하나가 깨져도 나머지는 읽는다
    }
    if (type == 'IEND') break;
    pos = end + 4; // CRC 건너뜀
  }
  return out;
}

int _nul(Uint8List d, int from) {
  final i = d.indexOf(0, from);
  if (i < 0) throw const FormatException('NUL 없음');
  return i;
}

// 규격상 tEXt는 Latin-1이지만 NovelAI·ComfyUI는 UTF-8을 그대로 넣는다 → UTF-8 먼저 시도
String _text(List<int> b) {
  try {
    return utf8.decode(b);
  } on FormatException {
    return latin1.decode(b);
  }
}

(String, String) _tEXt(Uint8List d) {
  final k = _nul(d, 0);
  return (latin1.decode(d.sublist(0, k)), _text(d.sublist(k + 1)));
}

(String, String) _zTXt(Uint8List d) {
  final k = _nul(d, 0);
  return (latin1.decode(d.sublist(0, k)), _text(ZLibDecoder().decodeBytes(d.sublist(k + 2))));
}

(String, String) _iTXt(Uint8List d) {
  final k = _nul(d, 0);
  final compressed = d[k + 1] == 1;
  final lang = _nul(d, k + 3);
  final translated = _nul(d, lang + 1);
  final body = d.sublist(translated + 1);
  return (latin1.decode(d.sublist(0, k)), utf8.decode(compressed ? ZLibDecoder().decodeBytes(body) : body, allowMalformed: true));
}

/// PNG에서 찾은 생성 정보.
class GenerationInfo {
  /// PromptPlatform 값 (WebUI / NovelAI / ComfyUI)
  final String platform;
  /// 원문 그대로 (gen_records.prompt_raw). WebUI는 parameters 전체, NovelAI·ComfyUI는 긍정 프롬프트.
  final String promptRaw;
  final ParsedPrompt parsed;
  /// 숫자 칸으로 옮길 것들
  final int? seed;
  final int? steps;
  final String? sampler;
  final double? cfgScale;
  final int? width;
  final int? height;
  final String? model;
  /// 플랫폼별 추가 정보 (gen_records.extra_json). ComfyUI는 'workflow' 원문도 여기에.
  final Map<String, Object?> extra;

  const GenerationInfo({
    required this.platform,
    required this.promptRaw,
    required this.parsed,
    this.seed,
    this.steps,
    this.sampler,
    this.cfgScale,
    this.width,
    this.height,
    this.model,
    this.extra = const {},
  });

  Map<String, Object?> toJson() => {
        'platform': platform,
        'prompt_raw': promptRaw,
        'parsed': parsed.toJson(),
        'seed': seed,
        'steps': steps,
        'sampler': sampler,
        'cfg_scale': cfgScale,
        'width': width,
        'height': height,
        'model': model,
        'extra': extra,
      };
}

/// PNG 바이트 → 생성 정보. 정보가 없으면 null (Midjourney·SNS에서 받은 이미지는 대개 지워져 있음).
GenerationInfo? readGenerationInfo(Uint8List bytes, {Map<String, String> learned = const {}}) {
  final text = readPngText(bytes);
  final params = text['parameters'];
  if (params != null && params.trim().isNotEmpty) return _fromWebui(params, learned);
  final comment = text['Comment'];
  if (comment != null) {
    final info = _fromNovelai(comment, text, learned);
    if (info != null) return info;
  }
  if (text['prompt'] != null || text['workflow'] != null) return _fromComfy(text, learned);
  return null;
}

GenerationInfo _fromWebui(String params, Map<String, String> learned) {
  final p = parsePrompt(params, learned: learned)..platform = PromptPlatform.webui;
  final size = p.size;
  final extra = <String, Object?>{};
  for (final k in ['Model hash', 'Lora hashes', 'VAE', 'Clip skip', 'Denoising strength', 'Hires upscale', 'Version']) {
    if (p.settings[k] != null) extra[k] = p.settings[k];
  }
  return GenerationInfo(
    platform: PromptPlatform.webui,
    promptRaw: params,
    parsed: p,
    seed: p.seed,
    steps: p.steps,
    sampler: p.sampler,
    cfgScale: p.cfgScale,
    width: size?.$1,
    height: size?.$2,
    model: p.model,
    extra: extra,
  );
}

GenerationInfo? _fromNovelai(String comment, Map<String, String> text, Map<String, String> learned) {
  final Object? decoded;
  try {
    decoded = jsonDecode(comment);
  } on FormatException {
    return null;
  }
  if (decoded is! Map || decoded['prompt'] is! String) return null;
  final j = decoded.cast<String, Object?>();
  // V4는 v4_prompt.caption.base_caption 에도 있지만 prompt 칸이 같이 들어 있다
  final prompt = (j['prompt'] ?? text['Description'] ?? '').toString();
  final p = parsePrompt(prompt, learned: learned)..platform = PromptPlatform.novelai;
  final uc = j['uc'];
  if (uc is String) p.negative.addAll(uc.split(RegExp(r'[,\n]')).map((s) => s.trim()).where((s) => s.isNotEmpty));
  return GenerationInfo(
    platform: PromptPlatform.novelai,
    promptRaw: prompt,
    parsed: p,
    seed: _int(j['seed']),
    steps: _int(j['steps']),
    sampler: j['sampler']?.toString(),
    cfgScale: _double(j['scale']),
    width: _int(j['width']),
    height: _int(j['height']),
    model: text['Source'],
    extra: {
      for (final k in ['noise_schedule', 'cfg_rescale', 'sm', 'sm_dyn', 'strength', 'noise'])
        if (j[k] != null) k: j[k],
    },
  );
}

GenerationInfo _fromComfy(Map<String, String> text, Map<String, String> learned) {
  Map<String, Object?> graph = {};
  try {
    final g = jsonDecode(text['prompt'] ?? '{}');
    if (g is Map) graph = g.cast<String, Object?>();
  } on FormatException {
    // 그래프가 없거나 깨짐 → 워크플로만 보관
  }
  Map<String, Object?> inputsOf(Object? node) =>
      node is Map && node['inputs'] is Map ? (node['inputs'] as Map).cast<String, Object?>() : const {};
  String typeOf(Object? node) => node is Map ? (node['class_type'] ?? '').toString() : '';

  // 연결 [노드id, 출력번호] → 그 노드에서 문자열 text 찾기 (중간 노드를 몇 단계 따라감)
  String? textFrom(Object? link, [int depth = 0]) {
    if (link is String) return link;
    if (link is! List || link.isEmpty || depth > 6) return null;
    final inputs = inputsOf(graph[link.first.toString()]);
    for (final k in ['text', 'text_g', 'prompt', 'conditioning', 'conditioning_1', 'positive', 'clip']) {
      final v = inputs[k];
      if (v is String && k != 'clip') return v;
      if (v is List) {
        final t = textFrom(v, depth + 1);
        if (t != null) return t;
      }
    }
    return null;
  }

  Map<String, Object?> sampler = const {};
  String? model;
  int? width, height;
  final loras = <PromptLora>[];
  for (final node in graph.values) {
    final type = typeOf(node);
    final inputs = inputsOf(node);
    if (sampler.isEmpty && type.startsWith('KSampler')) sampler = inputs;
    if (type.startsWith('CheckpointLoader') && inputs['ckpt_name'] != null) model ??= inputs['ckpt_name'].toString();
    if (type.startsWith('LoraLoader') && inputs['lora_name'] != null) {
      loras.add(PromptLora(_stripExt(inputs['lora_name'].toString()), _double(inputs['strength_model']) ?? 1));
    }
    if (type.contains('LatentImage') && inputs['width'] is num) {
      width ??= _int(inputs['width']);
      height ??= _int(inputs['height']);
    }
  }
  final positive = textFrom(sampler['positive']) ?? '';
  final negative = textFrom(sampler['negative']) ?? '';
  final p = parsePrompt(positive, learned: learned)..platform = PromptPlatform.comfyui;
  p.loras.addAll(loras);
  p.negative.addAll(negative.split(RegExp(r'[,\n]')).map((s) => s.trim()).where((s) => s.isNotEmpty));
  return GenerationInfo(
    platform: PromptPlatform.comfyui,
    promptRaw: positive,
    parsed: p,
    seed: _int(sampler['seed'] ?? sampler['noise_seed']),
    steps: _int(sampler['steps']),
    sampler: sampler['sampler_name']?.toString(),
    cfgScale: _double(sampler['cfg']),
    width: width,
    height: height,
    model: model,
    extra: {
      if (sampler['scheduler'] != null) 'scheduler': sampler['scheduler'],
      if (text['workflow'] != null) 'workflow': text['workflow'],
    },
  );
}

String _stripExt(String name) => name.replaceAll(RegExp(r'\.(safetensors|ckpt|pt)$'), '').split(RegExp(r'[\\/]')).last;
int? _int(Object? v) => v is num ? v.toInt() : int.tryParse('${v ?? ''}');
double? _double(Object? v) => v is num ? v.toDouble() : double.tryParse('${v ?? ''}');
