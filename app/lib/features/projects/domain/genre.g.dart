// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Genre _$GenreFromJson(Map<String, dynamic> json) => _Genre(
  id: (json['id'] as num).toInt(),
  category: json['category'] as String,
  name: json['name'] as String,
  isCustom: json['is_custom'] == null
      ? false
      : const IntBool().fromJson(json['is_custom']),
);

Map<String, dynamic> _$GenreToJson(_Genre instance) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'name': instance.name,
  'is_custom': const IntBool().toJson(instance.isCustom),
};
