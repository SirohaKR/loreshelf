// 엔티티: 이미지 생성 — 고정 프롬프트(GenPreset)와 생성 기록(GenRecord)
// GET /api/characters/:id/gen-presets, /gen-records 의 JSON 모양 그대로.
// 프롬프트 글 만들기는 서버와 같은 shared 패키지(formatPrompt)를 쓴다.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loreshelf_shared/loreshelf_shared.dart' show PromptLora, PromptTag, formatPrompt, formatTag, promptCategoryKeys;

import '../../../core/utils/int_bool_converter.dart';

// 카테고리 키·화면 이름은 shared 것을 그대로 내보낸다
export 'package:loreshelf_shared/loreshelf_shared.dart' show promptCategoryKeys, promptCategoryLabels;

export 'gen_extras.dart';

part 'gen.freezed.dart';
part 'gen.g.dart';

@freezed
abstract class GenTag with _$GenTag {
  const factory GenTag({required String tag, @Default(1.0) double weight}) = _GenTag;

  factory GenTag.fromJson(Map<String, Object?> json) => _$GenTagFromJson(json);
}

/// 쓴 LoRA — 목록에 없는 LoRA(생성 기록)는 genLoraId가 null
@freezed
abstract class GenLoraUse with _$GenLoraUse {
  const factory GenLoraUse({int? genLoraId, required String name, @Default(1.0) double weight}) = _GenLoraUse;

  factory GenLoraUse.fromJson(Map<String, Object?> json) => _$GenLoraUseFromJson(json);
}

/// 프리셋·기록 공통: 분류된 태그 → 붙여넣을 글
mixin PromptParts {
  Map<String, List<GenTag>> get tags;
  List<String> get negative;
  List<GenLoraUse> get loras;

  /// 화면 순서대로, 태그가 있는 카테고리만
  Iterable<String> get usedCategories => promptCategoryKeys.where((k) => tags[k]?.isNotEmpty ?? false);

  Map<String, List<PromptTag>> get _shared => {
        for (final e in tags.entries) e.key: [for (final t in e.value) PromptTag(t.tag, t.weight)],
      };

  /// 전체 프롬프트 (SD 형식 또는 NovelAI 형식)
  String promptText({bool novelai = false}) => formatPrompt(_shared,
      negative: negative, loras: [for (final l in loras) PromptLora(l.name, l.weight)], novelai: novelai);

  /// 한 카테고리 줄만
  String lineOf(String category) => [for (final t in tags[category] ?? const <GenTag>[]) formatTag(PromptTag(t.tag, t.weight))].join(', ');
}

@freezed
abstract class GenPreset with _$GenPreset, PromptParts {
  const GenPreset._();

  const factory GenPreset({
    required int id,
    required String name,
    @Default({}) Map<String, List<GenTag>> tags,
    @Default([]) List<String> negative,
    @Default([]) List<GenLoraUse> loras,
  }) = _GenPreset;

  factory GenPreset.fromJson(Map<String, Object?> json) => _$GenPresetFromJson(json);
}

@freezed
abstract class GenRecord with _$GenRecord, PromptParts {
  const GenRecord._();

  const factory GenRecord({
    required int id,
    String? title,
    int? assetId,
    int? genPlatformId,
    int? genModelId,
    int? genPresetId,
    String? platformName,
    String? modelName,
    String? presetName,
    String? promptRaw,
    @Default({}) Map<String, List<GenTag>> tags,
    @Default([]) List<String> negative,
    @Default([]) List<GenLoraUse> loras,
    int? seed,
    String? sampler,
    int? steps,
    double? cfgScale,
    int? width,
    int? height,
    String? note,
    @IntBool() @Default(false) bool isCover,
    @Default({}) Map<String, Object?> extra,
    String? createdAt,
  }) = _GenRecord;

  factory GenRecord.fromJson(Map<String, Object?> json) => _$GenRecordFromJson(json);

  /// "2984471023 · Euler a · 28스텝"
  String get seedLine => [if (seed != null) '$seed', ?sampler, if (steps != null) '$steps스텝'].join(' · ');
}

/// LoRA 사전 (생성 도구 목록) — 고정 프롬프트는 이 목록에 있는 LoRA만 저장할 수 있다
@freezed
abstract class GenLora with _$GenLora {
  const factory GenLora({
    required int id,
    required String name,
    String? fileName,
    String? baseModel,
    String? triggerWords,
    @Default(1.0) double defaultWeight,
    String? sourceUrl,
    String? note,
    @Default(0) int useCount,
  }) = _GenLora;

  factory GenLora.fromJson(Map<String, Object?> json) => _$GenLoraFromJson(json);
}
