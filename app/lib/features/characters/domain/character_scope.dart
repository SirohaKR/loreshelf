// 엔티티: 캐릭터를 "어디에서" 볼지 — freezed 유니온(sealed class) 예제.
// 전체 / 서재 / 특정 프로젝트 셋 중 하나. Java의 sealed interface + record 여러 개와 같은 모양.
// 서버 주소(?scope=library 같은 것)로 바꾸는 일은 data/ 쪽 몫이라 여기엔 없다.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_scope.freezed.dart';

@freezed
sealed class CharacterScope with _$CharacterScope {
  const factory CharacterScope.all() = AllCharacters;
  const factory CharacterScope.library() = LibraryCharacters;
  const factory CharacterScope.project({required int id, required String name}) = ProjectCharacters;
}
