// 엔티티: 장르·세계관 태그 (v0.2) — 프로젝트에 붙는다. category: genre·setting·mood·trope·game·custom
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/int_bool_converter.dart';

part 'genre.freezed.dart';
part 'genre.g.dart';

@freezed
abstract class Genre with _$Genre {
  const factory Genre({
    required int id,
    required String category,
    required String name,
    /// 내가 직접 추가한 태그 (지울 수 있음)
    @IntBool() @Default(false) bool isCustom,
  }) = _Genre;

  factory Genre.fromJson(Map<String, Object?> json) => _$GenreFromJson(json);
}
