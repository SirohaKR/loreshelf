// 엔티티: 고정 프롬프트·생성 기록 편집 중인 값 — 웹 character_prompt.js의 편집 폼과 같은 모양
// (POST/PUT /api/characters/:id/gen-presets, /api/gen/presets/:id, .../gen-records, /api/gen/records/:id)
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loreshelf_shared/loreshelf_shared.dart' show GenerationInfo, parsePrompt;

import 'gen.dart';

part 'gen_draft.freezed.dart';

/// 붙여넣은 프롬프트 글을 분류해서 tags·negative·loras로 — 고정 프롬프트·생성 기록 편집 폼이 같이 쓴다
({Map<String, List<GenTag>> tags, List<String> negative, List<GenLoraUse> loras}) classify(String text, {Map<String, String> learned = const {}}) {
  final p = parsePrompt(text, learned: learned);
  return (
    tags: {for (final e in p.categories.entries) e.key: [for (final t in e.value) GenTag(tag: t.tag, weight: t.weight)]},
    negative: p.negative,
    loras: [for (final l in p.loras) GenLoraUse(name: l.name, weight: l.weight)],
  );
}

@freezed
abstract class GenPresetDraft with _$GenPresetDraft, PromptParts {
  const GenPresetDraft._();

  const factory GenPresetDraft({
    @Default('') String name,
    @Default({}) Map<String, List<GenTag>> tags,
    @Default([]) List<String> negative,
    @Default([]) List<GenLoraUse> loras,
  }) = _GenPresetDraft;

  factory GenPresetDraft.empty() => const GenPresetDraft();

  factory GenPresetDraft.fromPreset(GenPreset p) => GenPresetDraft(name: p.name, tags: p.tags, negative: p.negative, loras: p.loras);

  String? get problem => name.trim().isEmpty ? '이름을 입력해 주세요' : null;

  /// 붙여넣은 글로 tags·negative·loras를 다시 채운 새 값
  GenPresetDraft classified(String text, {Map<String, String> learned = const {}}) {
    final c = classify(text, learned: learned);
    return copyWith(tags: c.tags, negative: c.negative, loras: c.loras);
  }

  Map<String, Object?> toPayload() => {
        'name': name.trim(),
        'tags': {for (final e in tags.entries) e.key: [for (final t in e.value) t.toJson()]},
        'negative': negative,
        'loras': [for (final l in loras) l.toJson()],
      };
}

@freezed
abstract class GenRecordDraft with _$GenRecordDraft, PromptParts {
  const GenRecordDraft._();

  const factory GenRecordDraft({
    int? assetId,
    String? platform,
    String? model,
    int? genPresetId,
    @Default('') String title,
    @Default('') String promptRaw,
    @Default({}) Map<String, List<GenTag>> tags,
    @Default([]) List<String> negative,
    @Default([]) List<GenLoraUse> loras,
    int? seed,
    String? sampler,
    int? steps,
    double? cfgScale,
    int? width,
    int? height,
    @Default('') String note,
    @Default(false) bool isCover,
    @Default({}) Map<String, Object?> extra,
  }) = _GenRecordDraft;

  factory GenRecordDraft.empty() => const GenRecordDraft();

  factory GenRecordDraft.fromRecord(GenRecord r) => GenRecordDraft(
        assetId: r.assetId,
        platform: r.platformName,
        model: r.modelName,
        genPresetId: r.genPresetId,
        title: r.title ?? '',
        promptRaw: r.promptRaw ?? '',
        tags: r.tags,
        negative: r.negative,
        loras: r.loras,
        seed: r.seed,
        sampler: r.sampler,
        steps: r.steps,
        cfgScale: r.cfgScale,
        width: r.width,
        height: r.height,
        note: r.note ?? '',
        isCover: r.isCover,
        extra: r.extra,
      );

  /// PNG에서 읽은 생성 정보로 처음부터 채우기 (가져오기 흐름)
  factory GenRecordDraft.fromGenerationInfo(GenerationInfo info, {int? assetId, String? title}) => GenRecordDraft(
        assetId: assetId,
        platform: info.platform,
        model: info.model,
        title: title ?? '',
        promptRaw: info.promptRaw,
        tags: {for (final e in info.parsed.categories.entries) e.key: [for (final t in e.value) GenTag(tag: t.tag, weight: t.weight)]},
        negative: info.parsed.negative,
        loras: [for (final l in info.parsed.loras) GenLoraUse(name: l.name, weight: l.weight)],
        seed: info.seed,
        sampler: info.sampler,
        steps: info.steps,
        cfgScale: info.cfgScale,
        width: info.width,
        height: info.height,
        extra: info.extra,
      );

  /// 붙여넣은 글로 tags·negative·loras를 다시 채운 새 값 (promptRaw도 같이 저장)
  GenRecordDraft classified(String text, {Map<String, String> learned = const {}}) {
    final c = classify(text, learned: learned);
    return copyWith(promptRaw: text, tags: c.tags, negative: c.negative, loras: c.loras);
  }

  Map<String, Object?> toPayload() => {
        'asset_id': assetId,
        'platform': platform?.trim().isEmpty == true ? null : platform?.trim(),
        'model': model?.trim().isEmpty == true ? null : model?.trim(),
        'gen_preset_id': genPresetId,
        'title': title.trim().isEmpty ? null : title.trim(),
        'prompt_raw': promptRaw.isEmpty ? null : promptRaw,
        'tags': {for (final e in tags.entries) e.key: [for (final t in e.value) t.toJson()]},
        'negative': negative,
        'loras': [for (final l in loras) l.toJson()],
        'seed': seed,
        'sampler': sampler,
        'steps': steps,
        'cfg_scale': cfgScale,
        'width': width,
        'height': height,
        'note': note.trim().isEmpty ? null : note.trim(),
        'is_cover': isCover,
        if (extra.isNotEmpty) 'extra': extra,
      };
}
