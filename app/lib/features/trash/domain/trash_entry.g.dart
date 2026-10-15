// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trash_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrashEntry _$TrashEntryFromJson(Map<String, dynamic> json) => _TrashEntry(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  deletedAt: json['deleted_at'] as String,
  projectName: json['project_name'] as String?,
  ownCharacterCount: (json['own_character_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TrashEntryToJson(_TrashEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'deleted_at': instance.deletedAt,
      'project_name': instance.projectName,
      'own_character_count': instance.ownCharacterCount,
    };
