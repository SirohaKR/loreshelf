// 캐릭터 목록 화면의 상태 — 고른 필터 + (디바운스가 끝난) 검색어
import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/character_scope.dart';

part 'character_list_state.freezed.dart';

@freezed
abstract class CharacterListState with _$CharacterListState {
  const factory CharacterListState({
    @Default(CharacterScope.all()) CharacterScope scope,
    @Default('') String text,
  }) = _CharacterListState;
}
