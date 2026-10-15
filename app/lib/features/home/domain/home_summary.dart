// 엔티티: 홈 화면 요약 — GET /api/home
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/domain/user.dart';
import '../../characters/domain/character.dart';
import '../../projects/domain/project.dart';

part 'home_summary.freezed.dart';
part 'home_summary.g.dart';

@freezed
abstract class HomeSummary with _$HomeSummary {
  const factory HomeSummary({
    User? user,
    required HomeCounts counts,
    @Default([]) List<CharacterSummary> recentCharacters,
    @Default([]) List<ProjectSummary> projects,
  }) = _HomeSummary;

  factory HomeSummary.fromJson(Map<String, Object?> json) => _$HomeSummaryFromJson(json);
}

/// 숫자 요약 (서버가 주는 worlds 수는 v0.2부터 화면에서 숨겨서 받지 않는다)
@freezed
abstract class HomeCounts with _$HomeCounts {
  const factory HomeCounts({
    @Default(0) int characters,
    @Default(0) int libraryCharacters,
    @Default(0) int projects,
    @Default(0) int publicItems,
  }) = _HomeCounts;

  factory HomeCounts.fromJson(Map<String, Object?> json) => _$HomeCountsFromJson(json);
}
