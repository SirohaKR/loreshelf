// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CharacterSummary _$CharacterSummaryFromJson(Map<String, dynamic> json) =>
    _CharacterSummary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      tagline: json['tagline'] as String?,
      themeColor: json['theme_color'] as String?,
      portraitAssetId: (json['portrait_asset_id'] as num?)?.toInt(),
      visibility: json['visibility'] as String? ?? 'private',
      isFavorite: json['is_favorite'] == null
          ? false
          : const IntBool().fromJson(json['is_favorite']),
      worldId: (json['world_id'] as num?)?.toInt(),
      worldName: json['world_name'] as String?,
      projectId: (json['project_id'] as num?)?.toInt(),
      projectName: json['project_name'] as String?,
      sourceCharacterId: (json['source_character_id'] as num?)?.toInt(),
      updatedAt: json['updated_at'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      membership: json['membership'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$CharacterSummaryToJson(_CharacterSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_en': instance.nameEn,
      'tagline': instance.tagline,
      'theme_color': instance.themeColor,
      'portrait_asset_id': instance.portraitAssetId,
      'visibility': instance.visibility,
      'is_favorite': const IntBool().toJson(instance.isFavorite),
      'world_id': instance.worldId,
      'world_name': instance.worldName,
      'project_id': instance.projectId,
      'project_name': instance.projectName,
      'source_character_id': instance.sourceCharacterId,
      'updated_at': instance.updatedAt,
      'tags': instance.tags,
      'membership': instance.membership,
      'role': instance.role,
    };

_CharacterDetail _$CharacterDetailFromJson(Map<String, dynamic> json) =>
    _CharacterDetail(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      tagline: json['tagline'] as String?,
      quote: json['quote'] as String?,
      themeColor: json['theme_color'] as String?,
      portraitAssetId: (json['portrait_asset_id'] as num?)?.toInt(),
      bodyMd: json['body_md'] as String?,
      visibility: json['visibility'] as String? ?? 'private',
      isFavorite: json['is_favorite'] == null
          ? false
          : const IntBool().fromJson(json['is_favorite']),
      projectId: (json['project_id'] as num?)?.toInt(),
      projectName: json['project_name'] as String?,
      projectKind: json['project_kind'] as String?,
      worldName: json['world_name'] as String?,
      sourceCharacterName: json['source_character_name'] as String?,
      sourceCharacterId: (json['source_character_id'] as num?)?.toInt(),
      updatedAt: json['updated_at'] as String?,
      worldId: (json['world_id'] as num?)?.toInt(),
      isCardDownloadable: json['is_card_downloadable'] == null
          ? false
          : const IntBool().fromJson(json['is_card_downloadable']),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      fields:
          (json['fields'] as List<dynamic>?)
              ?.map((e) => CharacterField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      traits:
          (json['traits'] as List<dynamic>?)
              ?.map((e) => Trait.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      quotes:
          (json['quotes'] as List<dynamic>?)
              ?.map((e) => Quote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      gallery:
          (json['gallery'] as List<dynamic>?)
              ?.map((e) => GalleryImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      linkedProjects:
          (json['linked_projects'] as List<dynamic>?)
              ?.map((e) => LinkedProject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      projectGenres:
          (json['project_genres'] as List<dynamic>?)
              ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CharacterDetailToJson(
  _CharacterDetail instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'name_en': instance.nameEn,
  'tagline': instance.tagline,
  'quote': instance.quote,
  'theme_color': instance.themeColor,
  'portrait_asset_id': instance.portraitAssetId,
  'body_md': instance.bodyMd,
  'visibility': instance.visibility,
  'is_favorite': const IntBool().toJson(instance.isFavorite),
  'project_id': instance.projectId,
  'project_name': instance.projectName,
  'project_kind': instance.projectKind,
  'world_name': instance.worldName,
  'source_character_name': instance.sourceCharacterName,
  'source_character_id': instance.sourceCharacterId,
  'updated_at': instance.updatedAt,
  'world_id': instance.worldId,
  'is_card_downloadable': const IntBool().toJson(instance.isCardDownloadable),
  'sort_order': instance.sortOrder,
  'fields': instance.fields.map((e) => e.toJson()).toList(),
  'traits': instance.traits.map((e) => e.toJson()).toList(),
  'quotes': instance.quotes.map((e) => e.toJson()).toList(),
  'tags': instance.tags,
  'gallery': instance.gallery.map((e) => e.toJson()).toList(),
  'linked_projects': instance.linkedProjects.map((e) => e.toJson()).toList(),
  'project_genres': instance.projectGenres.map((e) => e.toJson()).toList(),
};

_CharacterField _$CharacterFieldFromJson(Map<String, dynamic> json) =>
    _CharacterField(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
      value: json['value'] as String? ?? '',
      isSecret: json['is_secret'] == null
          ? false
          : const IntBool().fromJson(json['is_secret']),
    );

Map<String, dynamic> _$CharacterFieldToJson(_CharacterField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'value': instance.value,
      'is_secret': const IntBool().toJson(instance.isSecret),
    };

_Trait _$TraitFromJson(Map<String, dynamic> json) => _Trait(
  id: (json['id'] as num).toInt(),
  leftLabel: json['left_label'] as String,
  rightLabel: json['right_label'] as String?,
  valuePercent: (json['value_percent'] as num?)?.toInt() ?? 50,
);

Map<String, dynamic> _$TraitToJson(_Trait instance) => <String, dynamic>{
  'id': instance.id,
  'left_label': instance.leftLabel,
  'right_label': instance.rightLabel,
  'value_percent': instance.valuePercent,
};

_Quote _$QuoteFromJson(Map<String, dynamic> json) => _Quote(
  id: (json['id'] as num).toInt(),
  body: json['body'] as String,
  situation: json['situation'] as String?,
  isSecret: json['is_secret'] == null
      ? false
      : const IntBool().fromJson(json['is_secret']),
);

Map<String, dynamic> _$QuoteToJson(_Quote instance) => <String, dynamic>{
  'id': instance.id,
  'body': instance.body,
  'situation': instance.situation,
  'is_secret': const IntBool().toJson(instance.isSecret),
};

_GalleryImage _$GalleryImageFromJson(Map<String, dynamic> json) =>
    _GalleryImage(
      id: (json['id'] as num).toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      caption: json['caption'] as String?,
      originalName: json['original_name'] as String?,
    );

Map<String, dynamic> _$GalleryImageToJson(_GalleryImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'caption': instance.caption,
      'original_name': instance.originalName,
    };

_LinkedProject _$LinkedProjectFromJson(Map<String, dynamic> json) =>
    _LinkedProject(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      kind: json['kind'] as String? ?? 'etc',
      role: json['role'] as String?,
    );

Map<String, dynamic> _$LinkedProjectToJson(_LinkedProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': instance.kind,
      'role': instance.role,
    };
