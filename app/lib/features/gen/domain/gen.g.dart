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
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$GenRecordToJson(_GenRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'asset_id': instance.assetId,
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
      'created_at': instance.createdAt,
    };
