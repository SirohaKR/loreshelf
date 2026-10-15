// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenTag _$GenTagFromJson(Map<String, dynamic> json) => _GenTag(
  tag: json['tag'] as String,
  weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$GenTagToJson(_GenTag instance) => <String, dynamic>{
  'tag': instance.tag,
  'weight': instance.weight,
};

_GenLoraUse _$GenLoraUseFromJson(Map<String, dynamic> json) => _GenLoraUse(
  genLoraId: (json['gen_lora_id'] as num?)?.toInt(),
  name: json['name'] as String,
  weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$GenLoraUseToJson(_GenLoraUse instance) =>
    <String, dynamic>{
      'gen_lora_id': instance.genLoraId,
      'name': instance.name,
      'weight': instance.weight,
    };

_GenPreset _$GenPresetFromJson(Map<String, dynamic> json) => _GenPreset(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  tags:
      (json['tags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => GenTag.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const {},
  negative:
      (json['negative'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  loras:
      (json['loras'] as List<dynamic>?)
          ?.map((e) => GenLoraUse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$GenPresetToJson(_GenPreset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tags': instance.tags.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
      'negative': instance.negative,
      'loras': instance.loras.map((e) => e.toJson()).toList(),
    };

_GenRecord _$GenRecordFromJson(Map<String, dynamic> json) => _GenRecord(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String?,
  assetId: (json['asset_id'] as num?)?.toInt(),
  genPlatformId: (json['gen_platform_id'] as num?)?.toInt(),
  genModelId: (json['gen_model_id'] as num?)?.toInt(),
  genPresetId: (json['gen_preset_id'] as num?)?.toInt(),
  platformName: json['platform_name'] as String?,
  modelName: json['model_name'] as String?,
  presetName: json['preset_name'] as String?,
  promptRaw: json['prompt_raw'] as String?,
  tags:
      (json['tags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => GenTag.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const {},
  negative:
      (json['negative'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  loras:
      (json['loras'] as List<dynamic>?)
          ?.map((e) => GenLoraUse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  seed: (json['seed'] as num?)?.toInt(),
  sampler: json['sampler'] as String?,
  steps: (json['steps'] as num?)?.toInt(),
  cfgScale: (json['cfg_scale'] as num?)?.toDouble(),
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  note: json['note'] as String?,
  isCover: json['is_cover'] == null
      ? false
      : const IntBool().fromJson(json['is_cover']),
  extra: json['extra'] as Map<String, dynamic>? ?? const {},
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$GenRecordToJson(_GenRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'asset_id': instance.assetId,
      'gen_platform_id': instance.genPlatformId,
      'gen_model_id': instance.genModelId,
      'gen_preset_id': instance.genPresetId,
      'platform_name': instance.platformName,
      'model_name': instance.modelName,
      'preset_name': instance.presetName,
      'prompt_raw': instance.promptRaw,
      'tags': instance.tags.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
      'negative': instance.negative,
      'loras': instance.loras.map((e) => e.toJson()).toList(),
      'seed': instance.seed,
      'sampler': instance.sampler,
      'steps': instance.steps,
      'cfg_scale': instance.cfgScale,
      'width': instance.width,
      'height': instance.height,
      'note': instance.note,
      'is_cover': const IntBool().toJson(instance.isCover),
      'extra': instance.extra,
      'created_at': instance.createdAt,
    };

_GenLora _$GenLoraFromJson(Map<String, dynamic> json) => _GenLora(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  fileName: json['file_name'] as String?,
  baseModel: json['base_model'] as String?,
  triggerWords: json['trigger_words'] as String?,
  defaultWeight: (json['default_weight'] as num?)?.toDouble() ?? 1.0,
  sourceUrl: json['source_url'] as String?,
  note: json['note'] as String?,
  useCount: (json['use_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GenLoraToJson(_GenLora instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'file_name': instance.fileName,
  'base_model': instance.baseModel,
  'trigger_words': instance.triggerWords,
  'default_weight': instance.defaultWeight,
  'source_url': instance.sourceUrl,
  'note': instance.note,
  'use_count': instance.useCount,
};
