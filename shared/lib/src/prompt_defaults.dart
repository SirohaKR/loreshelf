// 모든 캐릭터 공통 기본값 — "높은 품질을 위해 늘 넣는" 품질 태그·네거티브.
// 사용자마다 한 번만 저장하고(DB settings: gen_default_quality, gen_default_negative),
// 붙여 넣을 때는 겹치는 태그를 빼서 캐릭터만의 태그만 남기고, 복사할 때는 다시 합쳐서 내보낸다.
import 'negative_sets.dart';
import 'prompt_parser.dart';

/// 처음 쓸 때의 기본 품질 태그 (사용자가 고칠 수 있음)
const initialDefaultQuality = ['masterpiece', 'best quality', 'high quality', 'highly detailed'];

/// 처음 쓸 때의 기본 네거티브 = 기본 세트 중 품질·손·얼굴·글자
final initialDefaultNegative = [
  for (final s in defaultNegativeSets)
    if (s.key != 'etc') ...s.tags,
];

/// 붙여 넣은 태그에서 공통 기본값과 겹치는 것을 뺀다. removed* = 뺀 것 (화면에 작게 보여 줄 것)
({Map<String, List<PromptTag>> tags, List<String> negative, List<String> removedQuality, List<String> removedNegative}) stripPromptDefaults(
  Map<String, List<PromptTag>> tags,
  List<String> negative, {
  required List<String> quality,
  required List<String> defaultNegative,
}) {
  final q = {for (final t in quality) normalizeTag(t)};
  final n = {for (final t in defaultNegative) normalizeTag(t)};
  final removedQuality = <String>[];
  final out = <String, List<PromptTag>>{};
  tags.forEach((k, list) {
    final kept = <PromptTag>[];
    for (final t in list) {
      if (q.contains(normalizeTag(t.tag))) {
        removedQuality.add(t.tag);
      } else {
        kept.add(t);
      }
    }
    if (kept.isNotEmpty) out[k] = kept;
  });
  final removedNegative = [for (final t in negative) if (n.contains(normalizeTag(t))) t];
  return (
    tags: out,
    negative: [for (final t in negative) if (!n.contains(normalizeTag(t))) t],
    removedQuality: removedQuality,
    removedNegative: removedNegative,
  );
}

/// 복사할 때: 공통 기본 품질은 품질 칸 앞에, 기본 네거티브는 네거티브 앞에 (겹치는 건 한 번만)
({Map<String, List<PromptTag>> tags, List<String> negative}) withPromptDefaults(
  Map<String, List<PromptTag>> tags,
  List<String> negative, {
  required List<String> quality,
  required List<String> defaultNegative,
}) =>
    (
      tags: mergePromptTags({if (quality.isNotEmpty) 'quality': [for (final t in quality) PromptTag(t, 1)]}, tags),
      negative: addNegativeTags(addNegativeTags(const [], defaultNegative), negative),
    );
