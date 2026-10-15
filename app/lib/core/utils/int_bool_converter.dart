// 서버(SQLite)는 참/거짓을 0·1 숫자로 보낸다 → Dart에선 bool로 쓰고 싶다.
// json_serializable의 JsonConverter: fromJson(서버 값 → Dart), toJson(Dart → 서버 값).
import 'package:json_annotation/json_annotation.dart';

class IntBool implements JsonConverter<bool, Object?> {
  const IntBool();

  @override
  bool fromJson(Object? json) => json == true || json == 1;

  @override
  Object? toJson(bool value) => value ? 1 : 0;
}
