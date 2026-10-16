// 이미지·프롬프트 화면에서 같이 쓰는 일반 클래스 (코드 생성 없음): 네거티브 세트, 공통 기본값, 복사용 합친 프롬프트
import 'package:loreshelf_shared/loreshelf_shared.dart' show PromptTag, addNegativeTags, mergePromptTags, stripPromptDefaults, withPromptDefaults;

import 'gen.dart';

/// 네거티브 세트 (GET /api/gen/negative-sets) — 기본 세트(builtin)는 id가 없고 고칠 수 없다
class GenNegativeSet {
  const GenNegativeSet({this.id, required this.name, required this.negative, this.builtin = false});
  final int? id;
  final String name;
  final List<String> negative;
  final bool builtin;

  factory GenNegativeSet.fromJson(Map<String, Object?> json) => GenNegativeSet(
        id: json['id'] as int?,
        name: json['name'] as String,
        negative: [for (final t in json['negative'] as List? ?? const []) '$t'],
        builtin: json['builtin'] == true,
      );
}

/// 화면에 보여 줄 태그 묶음 (PromptRows에 넘기는 용도)
class PromptData with PromptParts {
  PromptData(this.tags, [this.negative = const [], this.loras = const []]);
  @override
  final Map<String, List<GenTag>> tags;
  @override
  final List<String> negative;
  @override
  final List<GenLoraUse> loras;
}

/// 모든 캐릭터 공통 기본값 (GET /api/gen/defaults) — 늘 넣는 품질 태그·네거티브
class GenDefaults {
  const GenDefaults({this.quality = const [], this.negative = const []});
  final List<String> quality;
  final List<String> negative;

  factory GenDefaults.fromJson(Map<String, Object?> json) => GenDefaults(
        quality: [for (final t in json['quality'] as List? ?? const []) '$t'],
        negative: [for (final t in json['negative'] as List? ?? const []) '$t'],
      );

  /// 붙여 넣은 태그에서 기본값과 겹치는 것을 뺀 결과 + 뺀 태그들
  ({Map<String, List<GenTag>> tags, List<String> negative, List<String> removed}) strip(Map<String, List<GenTag>> tags, List<String> neg) {
    final s = stripPromptDefaults(_toShared(tags), neg, quality: quality, defaultNegative: negative);
    return (tags: _toGen(s.tags), negative: s.negative, removed: [...s.removedQuality, ...s.removedNegative]);
  }
}

/// 복사할 때 공통 기본값을 합친 것 (기본 품질은 품질 칸 앞에, 기본 네거티브는 네거티브 앞에)
class WithDefaults with PromptParts {
  WithDefaults(GenDefaults d, PromptParts p) : loras = p.loras {
    final w = withPromptDefaults(_toShared(p.tags), p.negative, quality: d.quality, defaultNegative: d.negative);
    tags = _toGen(w.tags);
    negative = w.negative;
  }
  @override
  late final Map<String, List<GenTag>> tags;
  @override
  late final List<String> negative;
  @override
  final List<GenLoraUse> loras;
}

Map<String, List<GenTag>> _toGen(Map<String, List<PromptTag>> m) => {
      for (final e in m.entries) e.key: [for (final t in e.value) GenTag(tag: t.tag, weight: t.weight)],
    };

/// 기록 + 그 기록의 고정 프롬프트를 합친 것 (고정 쪽이 앞, 겹치는 태그는 한 번만) — 복사할 때 쓴다
class MergedPrompt with PromptParts {
  MergedPrompt(GenPreset preset, PromptParts record)
      : tags = {
          for (final e in mergePromptTags(_toShared(preset.tags), _toShared(record.tags)).entries)
            e.key: [for (final t in e.value) GenTag(tag: t.tag, weight: t.weight)],
        },
        negative = addNegativeTags(preset.negative, record.negative),
        loras = [
          ...preset.loras,
          for (final l in record.loras)
            if (!preset.loras.any((p) => p.name.toLowerCase() == l.name.toLowerCase())) l,
        ];
  @override
  final Map<String, List<GenTag>> tags;
  @override
  final List<String> negative;
  @override
  final List<GenLoraUse> loras;
}

Map<String, List<PromptTag>> _toShared(Map<String, List<GenTag>> m) => {
      for (final e in m.entries) e.key: [for (final t in e.value) PromptTag(t.tag, t.weight)],
    };
