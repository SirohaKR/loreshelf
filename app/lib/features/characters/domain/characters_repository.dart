// 리포지토리 인터페이스: 캐릭터를 "무엇을" 가져올 수 있나
import 'character.dart';
import 'character_scope.dart';

abstract interface class CharactersRepository {
  /// [scope] 안에서, [text]가 있으면 이름·소개·태그 검색
  Future<List<CharacterSummary>> fetchList({CharacterScope scope = const CharacterScope.all(), String text = ''});

  Future<CharacterDetail> fetchDetail(int id);
}
