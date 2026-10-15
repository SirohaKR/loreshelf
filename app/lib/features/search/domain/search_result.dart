// 엔티티: 통합 검색 결과 — GET /api/search?q=
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

/// matchedIn: name·tagline·tag·field·quote·body 중 어디서 찾았는지
@freezed
abstract class SearchCharacterHit with _$SearchCharacterHit {
  const factory SearchCharacterHit({
    required int id,
    required String name,
    String? nameEn,
    String? tagline,
    String? themeColor,
    int? portraitAssetId,
    String? projectName,
    @Default('body') String matchedIn,
  }) = _SearchCharacterHit;

  factory SearchCharacterHit.fromJson(Map<String, Object?> json) => _$SearchCharacterHitFromJson(json);
}

@freezed
abstract class SearchWorldHit with _$SearchWorldHit {
  const factory SearchWorldHit({required int id, required String name, String? summary}) = _SearchWorldHit;

  factory SearchWorldHit.fromJson(Map<String, Object?> json) => _$SearchWorldHitFromJson(json);
}

@freezed
abstract class SearchProjectHit with _$SearchProjectHit {
  const factory SearchProjectHit({required int id, required String name, @Default('etc') String kind, String? summary}) = _SearchProjectHit;

  factory SearchProjectHit.fromJson(Map<String, Object?> json) => _$SearchProjectHitFromJson(json);
}

@freezed
abstract class SearchResults with _$SearchResults {
  const factory SearchResults({
    @Default([]) List<SearchCharacterHit> characters,
    @Default([]) List<SearchWorldHit> worlds,
    @Default([]) List<SearchProjectHit> projects,
  }) = _SearchResults;

  const SearchResults._();

  factory SearchResults.fromJson(Map<String, Object?> json) => _$SearchResultsFromJson(json);

  int get total => characters.length + worlds.length + projects.length;
}
