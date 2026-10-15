// 엔티티: 캐릭터 — 목록용 요약(CharacterSummary)과 상세(CharacterDetail)
// 서버 JSON과 모양이 같아서 DTO를 따로 두지 않고 엔티티에 fromJson을 붙였다 (공부노트 참고).
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/int_bool_converter.dart';
import '../../projects/domain/genre.dart';

part 'character.freezed.dart';
part 'character.g.dart';

/// 목록·카드에 쓰는 캐릭터 요약 — GET /api/characters, /api/home 의 recent_characters,
/// 프로젝트 상세의 characters(이때만 membership·role이 있음)
@freezed
abstract class CharacterSummary with _$CharacterSummary {
  const factory CharacterSummary({
    required int id,
    required String name,
    String? nameEn,
    String? tagline,
    String? themeColor,
    int? portraitAssetId,
    @Default('private') String visibility,
    @IntBool() @Default(false) bool isFavorite,
    int? worldId,
    String? worldName,
    int? projectId,
    String? projectName,
    int? sourceCharacterId,
    String? updatedAt,
    @Default([]) List<String> tags,
    // 프로젝트 상세에서만: own(전용) / linked(서재에서 연결)
    String? membership,
    String? role,
  }) = _CharacterSummary;

  factory CharacterSummary.fromJson(Map<String, Object?> json) => _$CharacterSummaryFromJson(json);
}

/// 캐릭터 상세 — GET /api/characters/:id
@freezed
abstract class CharacterDetail with _$CharacterDetail {
  const CharacterDetail._(); // 아래처럼 직접 만든 getter를 넣으려면 private 생성자가 필요

  const factory CharacterDetail({
    required int id,
    required String name,
    String? nameEn,
    String? tagline,
    String? quote,
    String? themeColor,
    int? portraitAssetId,
    String? bodyMd,
    @Default('private') String visibility,
    @IntBool() @Default(false) bool isFavorite,
    int? projectId,
    String? projectName,
    String? projectKind,
    String? worldName,
    String? sourceCharacterName,
    int? sourceCharacterId,
    String? updatedAt,
    // 고칠 때 그대로 돌려보내야 하는 값 (화면엔 안 보임)
    int? worldId,
    @IntBool() @Default(false) bool isCardDownloadable,
    @Default(0) int sortOrder,
    @Default([]) List<CharacterField> fields,
    @Default([]) List<Trait> traits,
    @Default([]) List<Quote> quotes,
    @Default([]) List<String> tags,
    @Default([]) List<GalleryImage> gallery,
    @Default([]) List<LinkedProject> linkedProjects,
    @Default([]) List<Genre> projectGenres,
  }) = _CharacterDetail;

  factory CharacterDetail.fromJson(Map<String, Object?> json) => _$CharacterDetailFromJson(json);

  /// 서재(프로젝트에 속하지 않음) 캐릭터인지
  bool get inLibrary => projectId == null;
}

/// 프로필 항목 (나이: 23세 같은 것). is_secret = 비밀 설정
@freezed
abstract class CharacterField with _$CharacterField {
  const factory CharacterField({
    required int id,
    required String label,
    @Default('') String value,
    @IntBool() @Default(false) bool isSecret,
  }) = _CharacterField;

  factory CharacterField.fromJson(Map<String, Object?> json) => _$CharacterFieldFromJson(json);
}

/// 성격 막대 (내향 ←28%→ 외향). rightLabel 이 null 이면 한쪽짜리 (신중함 80%)
@freezed
abstract class Trait with _$Trait {
  const factory Trait({
    required int id,
    required String leftLabel,
    String? rightLabel,
    @Default(50) int valuePercent,
  }) = _Trait;

  factory Trait.fromJson(Map<String, Object?> json) => _$TraitFromJson(json);
}

/// 대사
@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required int id,
    required String body,
    String? situation,
    @IntBool() @Default(false) bool isSecret,
  }) = _Quote;

  factory Quote.fromJson(Map<String, Object?> json) => _$QuoteFromJson(json);
}

/// 갤러리 이미지 (id = asset id → /api/assets/:id/thumb, /file)
@freezed
abstract class GalleryImage with _$GalleryImage {
  const factory GalleryImage({
    required int id,
    int? width,
    int? height,
    String? caption,
    String? originalName,
  }) = _GalleryImage;

  factory GalleryImage.fromJson(Map<String, Object?> json) => _$GalleryImageFromJson(json);
}

/// 서재 캐릭터가 연결된 프로젝트 (역할 포함)
@freezed
abstract class LinkedProject with _$LinkedProject {
  const factory LinkedProject({
    required int id,
    required String name,
    @Default('etc') String kind,
    String? role,
  }) = _LinkedProject;

  factory LinkedProject.fromJson(Map<String, Object?> json) => _$LinkedProjectFromJson(json);
}
