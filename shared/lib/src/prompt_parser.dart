// 이미지 프롬프트 자동 분류기.
// 입력: WebUI 'parameters' 텍스트 / NovelAI 태그 / Midjourney 문장 등 붙여넣은 전체 프롬프트
// 출력: ParsedPrompt { platform, categories: {key: [{tag, weight}]}, negative, loras, settings }
// (docs/planning/mockups/prompt-parser.js 프로토타입을 옮긴 것)

/// 분류 카테고리 키 — DB gen_tag_rules.category, tags_json 키와 같다. 순서 = 화면 순서.
const promptCategoryKeys = ['character', 'personality', 'outfit', 'props', 'expression', 'pose', 'background', 'style', 'quality', 'etc'];

const promptCategoryLabels = {
  'character': '인물·외형',
  'personality': '성격·분위기',
  'outfit': '의상',
  'props': '소품',
  'expression': '표정',
  'pose': '포즈·구도',
  'background': '배경·조명',
  'style': '스타일·화풍',
  'quality': '품질',
  'etc': '미분류',
};

/// 붙여넣은 프롬프트를 나눌 때 각 칸이 기본으로 가는 곳 (화면에서 칸마다 바꿀 수 있음).
/// fixed = 캐릭터의 고정 프롬프트(정체성), outfit = 의상 프리셋, scene = 이번 생성 기록에만.
const promptCategoryDefaultTarget = {
  'character': 'fixed',
  'personality': 'fixed',
  'outfit': 'outfit',
  'props': 'scene',
  'expression': 'scene',
  'pose': 'scene',
  'background': 'scene',
  'style': 'fixed',
  'quality': 'fixed',
  'etc': 'scene',
};

/// 플랫폼 이름 (감지 결과). 못 알아보면 null.
abstract final class PromptPlatform {
  static const webui = 'Stable Diffusion WebUI';
  static const novelai = 'NovelAI';
  static const midjourney = 'Midjourney';
  static const comfyui = 'ComfyUI';
}

// 성격 단어 — 태그 전체가 이 단어(들)일 때만 성격으로 본다 ("gentle smile"은 표정, "cold eyes"는 외형)
const _traits = 'shy|quiet|prudent|cautious|careful|cheerful|cold|cool|gentle|kind|calm|timid|confident|arrogant|aloof|stoic|'
    'tsundere|yandere|kuudere|dandere|deredere|genki|mischievous|playful|elegant|graceful|innocent|naive|mysterious|'
    'introverted|introvert|extroverted|extrovert|reserved|dignified|noble|wise|cunning|sly|flirty|flirtatious|energetic|'
    'carefree|melancholic|melancholy|lonely|caring|polite|strict|stern|lazy|brave|proud|cocky|serene|tender|warm|friendly|'
    'cheeky|charismatic|composed|honest|sincere|stubborn|clumsy|airheaded|bubbly|sweet|sassy|haughty|modest|humble|'
    'thoughtful|intelligent|clever|wild|fierce|lively|bright|gloomy|grumpy|aggressive|sensitive|loyal|soft-spoken';
const _traitMod = r'(?:(?:very|slightly|somewhat|a bit|bit|kind of|a little) )?';
const _traitTail = r'(?: (?:personality|impression|demeanor|demeanour|temperament|vibe|aura|type|nature|attitude|look|person))?';

// 순서가 중요: 위에서부터 먼저 걸리는 쪽으로 분류.
// 동작(holding/offering/giving …)으로 시작하는 태그는 포즈가 의상·소품·배경보다 먼저, 꽃은 밭·정원이 아니면 소품.
final _rules = <(String, RegExp)>[
  ('quality', RegExp(r'(\b(masterpiece|best quality|high quality|amazing quality|great quality|good quality|normal quality|top quality|very aesthetic|aesthetic|absurdres|highres|ultra[- ]?detailed|extremely detailed|highly detailed|hyper[- ]?detailed|super detailed|very detailed|intricate details?|fine details?|8k|4k|uhd|hdr|newest|score_\d\w*|sharp focus)\b|^detailed$)')),
  ('personality', RegExp('(^$_traitMod(?:$_traits)(?:(?:,? and |, | |-)$_traitMod(?:$_traits))*$_traitTail\$|\\b(personality|impression|demeanou?r|temperament|vibe|aura|attitude)\\b)')),
  ('style', RegExp(r'(^artist:|^by |\bstyle\b|\b(anime|manga|manhwa|webtoon|comic|cartoon|illustration|watercolou?r|oil painting|acrylic|gouache|ink|realistic|semi-realistic|photorealistic|flat colou?rs?|flat shading|cel[- ]?shad(ing|ed)|soft shading|shading|sketch|lineart|line art|linework|outlines?|lines|painterly|chibi|pixel art|2d|2\.5d|3d|render|cgi?|digital (art|painting)|concept art|official art|game cg|monochrome|greyscale|grayscale|retro|vintage|coloring|colou?r palette|palette|vivid colou?rs|pastel colou?rs|muted colou?rs|bold colou?rs|high contrast|traditional media)\b)')),
  ('expression', RegExp(r'\b(smile|smiling|smirk|grin|laugh|laughing|blush|blushing|expressionless|frown|frowning|angry|crying|tears|teary|pout|pouting|serious|sad|surprised|shocked|embarrassed|nervous|worried|scared|annoyed|smug|determined|sleepy|tired|bored|disgusted|confused|happy|wink|winking|tongue out|open mouth|closed mouth|parted lips|clenched teeth|closed eyes|half-closed eyes|expression)\b')),
  ('pose', RegExp(r"(^(holding|offering|giving|handing|presenting|showing|carrying|hugging|embracing|raising|lifting|grabbing|clutching|reaching|pointing|waving|touching|adjusting|pulling|playing|eating|drinking|reading|writing|smelling|sniffing|kissing|throwing|catching|wielding|swinging|leaning|resting)\b|\b(standing|sitting|seated|kneeling|lying|walking|running|jumping|crouching|squatting|floating|stretching|from above|from below|from side|from behind|from (the )?front|(front|back|rear|side|three[- ]quarters?|top|full[- ]body) view|facing (the )?viewer|facing away|upper body|lower body|full body|half body|cowboy shot|portrait|bust shot|close[- ]?up|medium shot|long shot|wide shot|head ?shot|(chest|waist|knee|thigh|shoulder)[- ]up|frame|framing|centered|looking at viewer|looking back|looking away|looking (up|down|to the side)|head tilt|tilted head|head tilted|tilting head|arms crossed|crossed arms|hand on (own )?(hip|chest|chin|cheek)|hands? on hips|hands? up|hands together|arms behind back|arms up|in front of (chest|face|body|self)|peace sign|v sign|salute|dynamic pose|pose|pov|dutch angle|low angle|high angle|bird'?s[- ]eye|worm'?s[- ]eye|fisheye|perspective|foreshortening|profile)\b)")),
  ('outfit', RegExp(r'(\b(hair|neck) (ribbon|bow|ornament|clip|flower|band|tie)s?\b|\b(armor|armour|dress|cape|cloak|uniform|gloves|gauntlets|boots|hat|cap|beret|jacket|blazer|shirt|t-shirt|blouse|sweater|hoodie|cardigan|vest|waistcoat|suit|tuxedo|tailcoat|cravat|ascot|tie|necktie|bow ?tie|collar|collared|skirt|earrings?|necklace|pendant|brooch|bracelet|choker|coat|overcoat|hood|scarf|belt|pants|trousers|jeans|shorts|leggings|stockings|pantyhose|apron|glasses|eyewear|monocle|crown|tiara|veil|headband|hairband|hairpin|hairclip|bow|kimono|yukata|hanbok|robe|tunic|corset|bodysuit|swimsuit|bikini|pajamas|sleeves|sleeveless|cuffs|cufflinks|buttons?|unbuttoned|thighhighs|socks|shoes|heels|sneakers|sandals|loafers|mask|eyepatch|outfit|clothes|clothing|attire|costume|lingerie|frills|lace)\b)')),
  ('props', RegExp(r"^(?!.*\b(field|garden|meadow|background|petals|tree|bed|falling)\b).*\b(bouquet|flowers?|roses?|lil(y|ies)|tulips?|sunflowers?|daisy|daisies|carnations?|peony|peonies|orchids?|lavender|baby'?s breath|gypsophila|ribbons?|gift|present|gift box|letter|envelope|book|cup|teacup|mug|wine glass|umbrella|parasol|hand fan|folding fan|phone|smartphone|bag|handbag|backpack|sword|katana|weapon|gun|rifle|pistol|staff|wand|spear|scythe|dagger|knife|shield|lantern|candle|cake|food|instrument|guitar|violin|microphone|camera|teddy bear|stuffed (animal|toy)|doll|cigarette|pipe|key|cards?|tray|basket|balloons?)\b")),
  ('character', RegExp(r'(^\d+(girl|boy|other|person|people|man|woman|men|women)s?$|^solo( focus)?$|\b(hair|haired|eyes|eye|pupils|irises|heterochromia|eyelids|eyelashes|eyebrows|bangs|ponytail|braid|twintails|ahoge|skin|complexion|freckles|ears|horns|tail|wings|fangs?|face|facial|jaw|jawline|chin|cheekbones|nose|forehead|beard|stubble|mustache|dark circles|female|male|woman|man|girl|boy|mature|young|adult|teen|teenage|child|elderly|middle-aged|years old|tall|petite|slender|slim|thin|chubby|curvy|muscular|toned|abs|body|figure|build|handsome|beautiful|pretty|cute|bishounen|bishoujo|ikemen|elf|demon|scar|mole|tan|tanned|pale)\b)')),
  ('background', RegExp(r'\b(background|outdoors|indoors|forest|city|street|night|day|sky|clouds?|ruins|castle|room|snow|rain|sunset|sunrise|moon|moonlight|stars?|light|lighting|lit|shadows?|bokeh|depth of field|embers|fire|smoke|water|ocean|sea|beach|field|garden|meadow|flowers?|petals|cherry blossoms|window|backlighting|rim light|glow|sunlight|cinematic|ambient|atmosphere|scenery|landscape)\b')),
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

// ───── 고정 프롬프트 / 이번 생성 기록으로 나누기 ─────

/// 칸 하나가 갈 곳: 'fixed'(고정 프롬프트 = 의상 프리셋) 또는 'scene'(이번 생성 기록에만).
/// [targets]에 없는 칸은 [promptCategoryDefaultTarget] 기본값 (의상은 고정 프롬프트로 간다).
String promptTargetOf(String category, [Map<String, String> targets = const {}]) {
  final t = targets[category] ?? promptCategoryDefaultTarget[category] ?? 'scene';
  return t == 'scene' ? 'scene' : 'fixed';
}

/// 분류 결과를 고정 쪽과 이번만 쪽으로 나눈다
({Map<String, List<PromptTag>> fixed, Map<String, List<PromptTag>> scene}) splitPromptTags(
  Map<String, List<PromptTag>> categories, {
  Map<String, String> targets = const {},
}) {
  final fixed = <String, List<PromptTag>>{};
  final scene = <String, List<PromptTag>>{};
  categories.forEach((k, list) {
    if (list.isEmpty) return;
    (promptTargetOf(k, targets) == 'fixed' ? fixed : scene)[k] = [...list];
  });
  return (fixed: fixed, scene: scene);
}

/// [add] 중에서 [base]에 아직 없는 태그만 (어느 칸에 있든 정규화한 글이 같으면 이미 있는 것으로 본다)
Map<String, List<PromptTag>> newPromptTags(Map<String, List<PromptTag>> base, Map<String, List<PromptTag>> add) {
  final seen = {for (final list in base.values) for (final t in list) normalizeTag(t.tag)};
  final out = <String, List<PromptTag>>{};
  for (final k in [...promptCategoryKeys, ...add.keys.where((k) => !promptCategoryKeys.contains(k))]) {
    for (final t in add[k] ?? const <PromptTag>[]) {
      if (seen.add(normalizeTag(t.tag))) out.putIfAbsent(k, () => []).add(t);
    }
  }
  return out;
}

/// [base]에 [add]의 새 태그만 붙인 결과 (칸 순서 유지)
Map<String, List<PromptTag>> mergePromptTags(Map<String, List<PromptTag>> base, Map<String, List<PromptTag>> add) {
  final extra = newPromptTags(base, add);
  final keys = {...base.keys, ...extra.keys};
  return {
    for (final k in [...promptCategoryKeys.where(keys.contains), ...keys.where((k) => !promptCategoryKeys.contains(k))])
      k: [...?base[k], ...?extra[k]],
  };
}
