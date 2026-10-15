// 엔티티: 장르·세계관 태그 (v0.2) — 프로젝트에 붙는다. category: genre·setting·mood·trope·game·custom
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre.freezed.dart';
part 'genre.g.dart';

@freezed
abstract class Genre with _$Genre {
  const factory Genre({
    required int id,
    required String category,
    required String name,
  }) = _Genre;

  factory Genre.fromJson(Map<String, Object?> json) => _$GenreFromJson(json);
}
