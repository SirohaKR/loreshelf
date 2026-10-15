// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeSummary _$HomeSummaryFromJson(Map<String, dynamic> json) => _HomeSummary(
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  counts: HomeCounts.fromJson(json['counts'] as Map<String, dynamic>),
  recentCharacters:
      (json['recent_characters'] as List<dynamic>?)
          ?.map((e) => CharacterSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  projects:
      (json['projects'] as List<dynamic>?)
          ?.map((e) => ProjectSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$HomeSummaryToJson(_HomeSummary instance) =>
    <String, dynamic>{
      'user': instance.user?.toJson(),
      'counts': instance.counts.toJson(),
      'recent_characters': instance.recentCharacters
          .map((e) => e.toJson())
          .toList(),
      'projects': instance.projects.map((e) => e.toJson()).toList(),
    };

_HomeCounts _$HomeCountsFromJson(Map<String, dynamic> json) => _HomeCounts(
  characters: (json['characters'] as num?)?.toInt() ?? 0,
  libraryCharacters: (json['library_characters'] as num?)?.toInt() ?? 0,
  projects: (json['projects'] as num?)?.toInt() ?? 0,
  publicItems: (json['public_items'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HomeCountsToJson(_HomeCounts instance) =>
    <String, dynamic>{
      'characters': instance.characters,
      'library_characters': instance.libraryCharacters,
      'projects': instance.projects,
      'public_items': instance.publicItems,
    };
