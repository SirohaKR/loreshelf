// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchCharacterHit _$SearchCharacterHitFromJson(Map<String, dynamic> json) =>
    _SearchCharacterHit(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      tagline: json['tagline'] as String?,
      themeColor: json['theme_color'] as String?,
      portraitAssetId: (json['portrait_asset_id'] as num?)?.toInt(),
      projectName: json['project_name'] as String?,
      matchedIn: json['matched_in'] as String? ?? 'body',
    );

Map<String, dynamic> _$SearchCharacterHitToJson(_SearchCharacterHit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_en': instance.nameEn,
      'tagline': instance.tagline,
      'theme_color': instance.themeColor,
      'portrait_asset_id': instance.portraitAssetId,
      'project_name': instance.projectName,
      'matched_in': instance.matchedIn,
    };

_SearchWorldHit _$SearchWorldHitFromJson(Map<String, dynamic> json) =>
    _SearchWorldHit(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      summary: json['summary'] as String?,
    );

Map<String, dynamic> _$SearchWorldHitToJson(_SearchWorldHit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'summary': instance.summary,
    };

_SearchProjectHit _$SearchProjectHitFromJson(Map<String, dynamic> json) =>
    _SearchProjectHit(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      kind: json['kind'] as String? ?? 'etc',
      summary: json['summary'] as String?,
    );

Map<String, dynamic> _$SearchProjectHitToJson(_SearchProjectHit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': instance.kind,
      'summary': instance.summary,
    };

_SearchResults _$SearchResultsFromJson(Map<String, dynamic> json) =>
    _SearchResults(
      characters:
          (json['characters'] as List<dynamic>?)
              ?.map(
                (e) => SearchCharacterHit.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      worlds:
          (json['worlds'] as List<dynamic>?)
              ?.map((e) => SearchWorldHit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      projects:
          (json['projects'] as List<dynamic>?)
              ?.map((e) => SearchProjectHit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SearchResultsToJson(_SearchResults instance) =>
    <String, dynamic>{
      'characters': instance.characters.map((e) => e.toJson()).toList(),
      'worlds': instance.worlds.map((e) => e.toJson()).toList(),
      'projects': instance.projects.map((e) => e.toJson()).toList(),
    };
