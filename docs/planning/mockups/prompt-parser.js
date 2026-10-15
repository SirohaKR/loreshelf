// 이미지 프롬프트 자동 분류기 (프로토타입)
// 입력: WebUI 'parameters' 텍스트 / NovelAI 태그 / Midjourney 문장 등 붙여넣은 전체 프롬프트
// 출력: { platform, categories: {key: [{tag, weight}]}, negative, loras, settings }

const PROMPT_CATEGORIES = [
  // 순서가 중요: 위에서부터 먼저 걸리는 쪽으로 분류
  ['quality', '품질', /\b(masterpiece|best quality|high quality|amazing quality|very aesthetic|aesthetic|absurdres|highres|ultra[- ]detailed|extremely detailed|8k|4k|newest|score_\d\w*)\b/],
  ['style', '스타일·화풍', /(^artist:|^by |\bstyle\b|\b(anime|illustration|watercolor|oil painting|realistic|photorealistic|flat colou?r|cel shading|sketch|lineart|painterly|chibi|pixel art|3d|render|monochrome|greyscale|retro|coloring)\b)/],
  ['expression', '표정', /\b(smile|smiling|blush|expressionless|frown|angry|crying|tears|pout|smirk|grin|serious|sad|surprised|open mouth|closed mouth|closed eyes|half-closed eyes)\b/],
  ['pose', '포즈·구도', /\b(standing|sitting|kneeling|lying|walking|running|from above|from below|from side|from behind|side view|upper body|full body|cowboy shot|portrait|close-up|wide shot|looking at viewer|looking back|looking away|arms crossed|hand on hip|hands? up|holding\b.*|dynamic pose|pov|dutch angle|profile)\b/],
  ['outfit', '의상·소품', /\b(armor|dress|cape|cloak|sword|weapon|uniform|gloves|gauntlets|boots|hat|jacket|shirt|skirt|ribbon|earrings?|necklace|choker|coat|hood|scarf|belt|pants|shorts|apron|glasses|crown|bow|kimono|sleeves|thighhighs|socks)\b/],
  ['character', '인물·외형', /(^\d+(girl|boy|other)s?$|^solo$|\b(hair|eyes|bangs|ponytail|braid|twintails|ahoge|skin|freckles|ears|horns|tail|wings|female|male|woman|man|girl|boy|mature|young|tall|petite|muscular|scar|mole)\b)/],
  ['background', '배경·조명', /\b(background|outdoors|indoors|forest|city|street|night|day|sky|clouds?|ruins|castle|room|snow|rain|sunset|sunrise|moon|moonlight|stars?|light|lighting|shadow|bokeh|depth of field|embers|fire|smoke|water|ocean|field|flowers?|cherry blossoms|window|backlighting|rim light|glow)\b/],
];
const CATEGORY_LABELS = Object.fromEntries(PROMPT_CATEGORIES.map(([k, l]) => [k, l]));
CATEGORY_LABELS.etc = '미분류';

function parseWeight(raw) {
  let t = raw.trim(), w = 1;
  let m;
  if ((m = t.match(/^(-?[\d.]+)::(.+?)(::)?$/))) return { tag: m[2].trim(), weight: +m[1] };      // NovelAI V4: 1.2::tag::
  if ((m = t.match(/^\((.+):\s*([\d.]+)\)$/))) return { tag: m[1].trim(), weight: +m[2] };       // (tag:1.2)
  while (/^\(.*\)$/.test(t)) { t = t.slice(1, -1); w *= 1.1; }                                     // ((tag))
  while (/^\{.*\}$/.test(t)) { t = t.slice(1, -1); w *= 1.05; }                                    // {tag} NovelAI
  while (/^\[.*\]$/.test(t)) { t = t.slice(1, -1); w /= 1.1; }                                     // [tag]
  return { tag: t.trim(), weight: Math.round(w * 100) / 100 };
}

function classifyTag(tag) {
  const norm = tag.toLowerCase().replace(/_/g, ' ');
  for (const [key, , re] of PROMPT_CATEGORIES) if (re.test(norm)) return key;
  return 'etc';
}

function parsePrompt(text) {
  const out = { platform: '알 수 없음', categories: {}, negative: [], loras: [], settings: {} };
  let positive = text;

  // WebUI 형식: 'Negative prompt:' 줄, 'Steps: ..' 설정 줄
  const stepsIdx = positive.search(/^\s*Steps:/m);
  if (stepsIdx >= 0) {
    positive.slice(stepsIdx).split(/,\s*(?=[A-Za-z][\w ]*:)/).forEach(pair => {
      const i = pair.indexOf(':');
      if (i > 0) out.settings[pair.slice(0, i).trim()] = pair.slice(i + 1).trim();
    });
    positive = positive.slice(0, stepsIdx);
    out.platform = 'Stable Diffusion (WebUI 계열)';
  }
  const negIdx = positive.search(/Negative prompt:/i);
  if (negIdx >= 0) {
    out.negative = positive.slice(negIdx).replace(/Negative prompt:/i, '').split(/,|\n/).map(s => s.trim()).filter(Boolean);
    positive = positive.slice(0, negIdx);
  }

  // Midjourney 파라미터: --ar 2:3 --niji 6 --sref ...
  positive = positive.replace(/--(\w+)\s+([^\s-][^\s]*)?/g, (_, k, v) => {
    out.settings['--' + k] = v || 'on';
    out.platform = 'Midjourney';
    return '';
  });

  // LoRA: <lora:name:0.8>
  positive = positive.replace(/<lora:([^:>]+)(?::([\d.]+))?>/g, (_, name, w) => {
    out.loras.push({ name, weight: w ? +w : 1 });
    return '';
  });

  if (out.platform === '알 수 없음' && /\{[^}]+\}|::/.test(positive)) out.platform = 'NovelAI';

  positive.split(/,|\n/).map(s => s.trim()).filter(Boolean).forEach(raw => {
    const { tag, weight } = parseWeight(raw);
    if (!tag) return;
    const key = classifyTag(tag);
    (out.categories[key] ||= []).push({ tag, weight });
  });
  return out;
}

if (typeof module !== 'undefined') module.exports = { parsePrompt, CATEGORY_LABELS };
