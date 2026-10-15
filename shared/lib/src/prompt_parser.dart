// 이미지 프롬프트 자동 분류기.
// 입력: WebUI 'parameters' 텍스트 / NovelAI 태그 / Midjourney 문장 등 붙여넣은 전체 프롬프트
// 출력: ParsedPrompt { platform, categories: {key: [{tag, weight}]}, negative, loras, settings }
// (docs/planning/mockups/prompt-parser.js 프로토타입을 옮긴 것)

/// 분류 카테고리 키 — DB gen_tag_rules.category, tags_json 키와 같다. 순서 = 화면 순서.
const promptCategoryKeys = ['character', 'outfit', 'expression', 'pose', 'background', 'style', 'quality', 'etc'];

const promptCategoryLabels = {
  'character': '인물·외형',
  'outfit': '의상·소품',
  'expression': '표정',
  'pose': '포즈·구도',
  'background': '배경·조명',
  'style': '스타일·화풍',
  'quality': '품질',
  'etc': '미분류',
};

/// 플랫폼 이름 (감지 결과). 못 알아보면 null.
abstract final class PromptPlatform {
  static const webui = 'Stable Diffusion WebUI';
  static const novelai = 'NovelAI';
  static const midjourney = 'Midjourney';
  static const comfyui = 'ComfyUI';
}

// 순서가 중요: 위에서부터 먼저 걸리는 쪽으로 분류
final _rules = <(String, RegExp)>[
  ('quality', RegExp(r'\b(masterpiece|best quality|high quality|amazing quality|very aesthetic|aesthetic|absurdres|highres|ultra[- ]detailed|extremely detailed|8k|4k|newest|score_\d\w*)\b')),
  ('style', RegExp(r'(^artist:|^by |\bstyle\b|\b(anime|illustration|watercolor|oil painting|realistic|photorealistic|flat colou?r|cel shading|sketch|lineart|painterly|chibi|pixel art|3d|render|monochrome|greyscale|retro|coloring)\b)')),
  ('expression', RegExp(r'\b(smile|smiling|blush|expressionless|frown|angry|crying|tears|pout|smirk|grin|serious|sad|surprised|open mouth|closed mouth|closed eyes|half-closed eyes)\b')),
  ('pose', RegExp(r'\b(standing|sitting|kneeling|lying|walking|running|from above|from below|from side|from behind|side view|upper body|full body|cowboy shot|portrait|close-up|wide shot|looking at viewer|looking back|looking away|arms crossed|hand on hip|hands? up|holding\b.*|dynamic pose|pov|dutch angle|profile)\b')),
  ('outfit', RegExp(r'\b(armor|dress|cape|cloak|sword|weapon|uniform|gloves|gauntlets|boots|hat|jacket|shirt|skirt|ribbon|earrings?|necklace|choker|coat|hood|scarf|belt|pants|shorts|apron|glasses|crown|bow|kimono|sleeves|thighhighs|socks)\b')),
  ('character', RegExp(r'(^\d+(girl|boy|other)s?$|^solo$|\b(hair|eyes|bangs|ponytail|braid|twintails|ahoge|skin|freckles|ears|horns|tail|wings|female|male|woman|man|girl|boy|mature|young|tall|petite|muscular|scar|mole)\b)')),
  ('background', RegExp(r'\b(background|outdoors|indoors|forest|city|street|night|day|sky|clouds?|ruins|castle|room|snow|rain|sunset|sunrise|moon|moonlight|stars?|light|lighting|shadow|bokeh|depth of field|embers|fire|smoke|water|ocean|field|flowers?|cherry blossoms|window|backlighting|rim light|glow)\b')),
];

class PromptTag {
  final String tag;
  final double weight;
  const PromptTag(this.tag, this.weight);

  Map<String, Object?> toJson() => {'tag': tag, 'weight': weight};

  @override
  bool operator ==(Object other) => other is PromptTag && other.tag == tag && other.weight == weight;
  @override
  int get hashCode => Object.hash(tag, weight);
  @override
  String toString() => '$tag:$weight';
}

class PromptLora {
  final String name;
  final double weight;
  const PromptLora(this.name, this.weight);

  Map<String, Object?> toJson() => {'name': name, 'weight': weight};
}

class ParsedPrompt {
  String? platform;
  /// 카테고리 키 → 태그 목록 (빈 카테고리는 키가 없음)
  final Map<String, List<PromptTag>> categories = {};
  final List<String> negative = [];
  final List<PromptLora> loras = [];
  /// 원문 설정 그대로 (WebUI: 'Steps' → '28', Midjourney: '--ar' → '2:3')
  final Map<String, String> settings = {};

  List<PromptTag> tagsOf(String category) => categories[category] ?? const [];

  /// gen_records의 숫자 칸으로 옮길 수 있는 설정만 뽑음
  int? get seed => int.tryParse(settings['Seed'] ?? settings['seed'] ?? '');
  int? get steps => int.tryParse(settings['Steps'] ?? settings['steps'] ?? '');
  String? get sampler => settings['Sampler'] ?? settings['sampler'];
  double? get cfgScale => double.tryParse(settings['CFG scale'] ?? settings['scale'] ?? '');
  String? get model => settings['Model'];
  (int, int)? get size {
    final m = RegExp(r'^(\d+)\s*x\s*(\d+)$').firstMatch(settings['Size'] ?? '');
    if (m == null) return null;
    return (int.parse(m[1]!), int.parse(m[2]!));
  }

  Map<String, Object?> toJson() => {
        'platform': platform,
        'categories': {for (final e in categories.entries) e.key: [for (final t in e.value) t.toJson()]},
        'negative': negative,
        'loras': [for (final l in loras) l.toJson()],
        'settings': settings,
      };
}

double _round2(double w) => (w * 100).round() / 100;

/// `(tag:1.2)`, `((tag))`, `{tag}`, `[tag]`, `1.2::tag::` → 태그 + 가중치
PromptTag parseWeight(String raw) {
  var t = raw.trim();
  var w = 1.0;
  var m = RegExp(r'^(-?[\d.]+)::(.+?)(::)?$').firstMatch(t); // NovelAI V4: 1.2::tag::
  if (m != null) return PromptTag(m[2]!.trim(), double.tryParse(m[1]!) ?? 1);
  m = RegExp(r'^\((.+):\s*([\d.]+)\)$').firstMatch(t); // (tag:1.2)
  if (m != null) return PromptTag(m[1]!.trim(), double.tryParse(m[2]!) ?? 1);
  while (t.length >= 2 && t.startsWith('(') && t.endsWith(')')) {
    t = t.substring(1, t.length - 1);
    w *= 1.1;
  }
  while (t.length >= 2 && t.startsWith('{') && t.endsWith('}')) {
    t = t.substring(1, t.length - 1);
    w *= 1.05;
  }
  while (t.length >= 2 && t.startsWith('[') && t.endsWith(']')) {
    t = t.substring(1, t.length - 1);
    w /= 1.1;
  }
  return PromptTag(t.trim(), _round2(w));
}

/// 사전 규칙용 정규화: 소문자, 밑줄 → 공백 (gen_tag_rules.tag 저장 형식)
String normalizeTag(String tag) => tag.toLowerCase().replaceAll('_', ' ').trim();

/// 태그 하나를 분류. [learned]는 내 사전(정규화된 태그 → 카테고리)으로, 기본 규칙보다 먼저 본다.
String classifyTag(String tag, {Map<String, String> learned = const {}}) {
  final norm = normalizeTag(tag);
  final mine = learned[norm];
  if (mine != null) return mine;
  for (final (key, re) in _rules) {
    if (re.hasMatch(norm)) return key;
  }
  return 'etc';
}

List<String> _splitTags(String s) => s.split(RegExp(r'[,\n]')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

/// 붙여넣은 프롬프트 전체를 나눠서 분류
ParsedPrompt parsePrompt(String text, {Map<String, String> learned = const {}}) {
  final out = ParsedPrompt();
  var positive = text.replaceAll('\r\n', '\n');

  // WebUI 형식: 'Negative prompt:' 줄, 'Steps: ..' 설정 줄
  final stepsAt = RegExp(r'^\s*Steps:', multiLine: true).firstMatch(positive);
  if (stepsAt != null) {
    final settingsLine = positive.substring(stepsAt.start);
    out.settings.addAll(parseWebuiSettings(settingsLine));
    positive = positive.substring(0, stepsAt.start);
    out.platform = PromptPlatform.webui;
  }
  final negAt = RegExp(r'Negative prompt:', caseSensitive: false).firstMatch(positive);
  if (negAt != null) {
    out.negative.addAll(_splitTags(positive.substring(negAt.end)));
    positive = positive.substring(0, negAt.start);
  }

  // Midjourney 파라미터: --ar 2:3 --niji 6 --sref ...
  positive = positive.replaceAllMapped(RegExp(r'--(\w+)(?:\s+([^\s-]\S*))?'), (m) {
    out.settings['--${m[1]}'] = m[2] ?? 'on';
    out.platform = PromptPlatform.midjourney;
    return '';
  });

  // LoRA: <lora:name:0.8>
  positive = positive.replaceAllMapped(RegExp(r'<lora:([^:>]+)(?::([\d.]+))?>'), (m) {
    out.loras.add(PromptLora(m[1]!, m[2] == null ? 1 : double.tryParse(m[2]!) ?? 1));
    return '';
  });

  if (out.platform == null && RegExp(r'\{[^}]+\}|::').hasMatch(positive)) out.platform = PromptPlatform.novelai;

  for (final raw in _splitTags(positive)) {
    final t = parseWeight(raw);
    if (t.tag.isEmpty) continue;
    out.categories.putIfAbsent(classifyTag(t.tag, learned: learned), () => []).add(t);
  }
  return out;
}

/// WebUI 설정 줄 `Steps: 28, Sampler: Euler a, Lora hashes: "a: 1, b: 2"` → 키·값.
/// 쉼표가 든 값은 "..."로 감싸져 있어서, 따옴표 안의 쉼표에서는 자르지 않는다.
Map<String, String> parseWebuiSettings(String line) {
  final out = <String, String>{};
  final parts = <String>[];
  final buf = StringBuffer();
  var quoted = false;
  for (final ch in line.split('')) {
    if (ch == '"') quoted = !quoted;
    if ((ch == ',' || ch == '\n') && !quoted) {
      parts.add(buf.toString());
      buf.clear();
    } else {
      buf.write(ch);
    }
  }
  parts.add(buf.toString());
  String? lastKey;
  for (final part in parts) {
    final i = part.indexOf(':');
    final key = i > 0 ? part.substring(0, i).trim() : '';
    if (i > 0 && RegExp(r'^[A-Za-z][\w .-]*$').hasMatch(key)) {
      var v = part.substring(i + 1).trim();
      if (v.length >= 2 && v.startsWith('"') && v.endsWith('"')) v = v.substring(1, v.length - 1);
      out[key] = v;
      lastKey = key;
    } else if (lastKey != null && part.trim().isNotEmpty) {
      out[lastKey] = '${out[lastKey]}, ${part.trim()}'; // 따옴표 없이 쉼표가 든 값
    }
  }
  return out;
}

String _w(double n) {
  final r = (n * 100).round() / 100;
  return r == r.truncateToDouble() ? '${r.toInt()}' : '$r';
}

/// 태그 하나 → 글. SD: `(tag:1.2)`, NovelAI: `1.2::tag::`
String formatTag(PromptTag t, {bool novelai = false}) =>
    t.weight == 1 ? t.tag : (novelai ? '${_w(t.weight)}::${t.tag}::' : '(${t.tag}:${_w(t.weight)})');

/// 분류된 태그 → 붙여넣을 프롬프트 글 (카테고리 순서대로). 웹 화면의 promptText와 같은 결과.
/// SD 형식은 LoRA를 `<lora:이름:0.8>`로 붙이고 네거티브는 "Negative prompt:" 줄, NovelAI는 LoRA 없이 "네거티브:" 줄.
String formatPrompt(Map<String, List<PromptTag>> tags,
    {List<String> negative = const [], List<PromptLora> loras = const [], bool novelai = false}) {
  final parts = [
    for (final k in promptCategoryKeys) ...?tags[k]?.map((t) => formatTag(t, novelai: novelai)),
    if (!novelai) ...loras.map((l) => '<lora:${l.name}:${_w(l.weight)}>'),
  ];
  var out = parts.join(', ');
  if (negative.isNotEmpty) out += '\n${novelai ? '네거티브: ' : 'Negative prompt: '}${negative.join(', ')}';
  return out;
}
