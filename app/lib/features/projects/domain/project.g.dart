// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectSummary _$ProjectSummaryFromJson(Map<String, dynamic> json) =>
    _ProjectSummary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      kind: json['kind'] as String? ?? 'etc',
      summary: json['summary'] as String?,
      worldId: (json['world_id'] as num?)?.toInt(),
      worldName: json['world_name'] as String?,
      coverAssetId: (json['cover_asset_id'] as num?)?.toInt(),
      progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
      visibility: json['visibility'] as String? ?? 'private',
      updatedAt: json['updated_at'] as String?,
      ownCharacterCount: (json['own_character_count'] as num?)?.toInt() ?? 0,
      linkedCharacterCount:
          (json['linked_character_count'] as num?)?.toInt() ?? 0,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProjectSummaryToJson(_ProjectSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': instance.kind,
      'summary': instance.summary,
      'world_id': instance.worldId,
      'world_name': instance.worldName,
      'cover_asset_id': instance.coverAssetId,
      'progress_percent': instance.progressPercent,
      'visibility': instance.visibility,
      'updated_at': instance.updatedAt,
      'own_character_count': instance.ownCharacterCount,
      'linked_character_count': instance.linkedCharacterCount,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
    };

_ProjectDetail _$ProjectDetailFromJson(Map<String, dynamic> json) =>
    _ProjectDetail(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      kind: json['kind'] as String? ?? 'etc',
      summary: json['summary'] as String?,
      bodyMd: json['body_md'] as String?,
      worldId: (json['world_id'] as num?)?.toInt(),
      worldName: json['world_name'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      coverAssetId: (json['cover_asset_id'] as num?)?.toInt(),
      progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
      visibility: json['visibility'] as String? ?? 'private',
      updatedAt: json['updated_at'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      characters:
          (json['characters'] as List<dynamic>?)
              ?.map((e) => CharacterSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProjectDetailToJson(_ProjectDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': instance.kind,
      'summary': instance.summary,
      'body_md': instance.bodyMd,
      'world_id': instance.worldId,
      'world_name': instance.worldName,
      'sort_order': instance.sortOrder,
      'cover_asset_id': instance.coverAssetId,
      'progress_percent': instance.progressPercent,
      'visibility': instance.visibility,
      'updated_at': instance.updatedAt,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
      'characters': instance.characters.map((e) => e.toJson()).toList(),
    };
