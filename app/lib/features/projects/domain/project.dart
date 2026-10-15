// 엔티티: 프로젝트 — 목록용 요약과 상세. kind: game·chatbot·etc
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../characters/domain/character.dart';
import 'genre.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// GET /api/projects, /api/home 의 projects
@freezed
abstract class ProjectSummary with _$ProjectSummary {
  const ProjectSummary._(); // 아래처럼 직접 만든 getter를 넣으려면 private 생성자가 필요

  const factory ProjectSummary({
    required int id,
    required String name,
    @Default('etc') String kind,
    String? summary,
    int? worldId,
    String? worldName,
    int? coverAssetId,
    @Default(0) int progressPercent,
    @Default('private') String visibility,
    String? updatedAt,
    @Default(0) int ownCharacterCount,
    @Default(0) int linkedCharacterCount,
    @Default([]) List<Genre> genres,
  }) = _ProjectSummary;

  factory ProjectSummary.fromJson(Map<String, Object?> json) => _$ProjectSummaryFromJson(json);

  int get characterCount => ownCharacterCount + linkedCharacterCount;
}

/// GET /api/projects/:id — 전용 + 연결 캐릭터가 characters에 함께 온다
@freezed
abstract class ProjectDetail with _$ProjectDetail {
  const ProjectDetail._();

  const factory ProjectDetail({
    required int id,
    required String name,
    @Default('etc') String kind,
    String? summary,
    String? bodyMd,
    int? worldId,
    String? worldName,
    @Default(0) int sortOrder,
    int? coverAssetId,
    @Default(0) int progressPercent,
    @Default('private') String visibility,
    String? updatedAt,
    @Default([]) List<Genre> genres,
    @Default([]) List<CharacterSummary> characters,
  }) = _ProjectDetail;

  factory ProjectDetail.fromJson(Map<String, Object?> json) => _$ProjectDetailFromJson(json);

  /// 이 프로젝트 전용 캐릭터 수 (나머지는 서재에서 연결)
  int get ownCount => characters.where((c) => c.membership == 'own').length;
}
