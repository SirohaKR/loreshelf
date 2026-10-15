// 엔티티(freezed + json_serializable) 테스트 — 서버가 실제로 보내는 JSON 모양 그대로 넣어 본다
import 'package:flutter_test/flutter_test.dart';
import 'package:loreshelf_app/features/characters/data/characters_repository_impl.dart';
import 'package:loreshelf_app/features/characters/domain/character.dart';
import 'package:loreshelf_app/features/characters/domain/character_scope.dart';
import 'package:loreshelf_app/features/home/domain/home_summary.dart';

void main() {
  test('캐릭터 상세: snake_case → camelCase, 0/1 → bool, 하위 목록까지', () {
    final ch = CharacterDetail.fromJson({
      'id': 1,
      'user_id': 1, // 엔티티에 없는 키는 무시된다
      'name': '리아 벨로트',
      'name_en': 'Lia Bellot',
      'theme_color': '#C9573F',
      'portrait_asset_id': 1,
      'is_favorite': 1,
      'project_id': 1,
      'project_kind': 'game',
      'fields': [
        {'id': 5, 'label': '진짜 정체', 'value': '사실 공주 본인', 'is_secret': 1},
      ],
      'traits': [
        {'id': 1, 'left_label': '내향', 'right_label': '외향', 'value_percent': 28},
      ],
      'quotes': [
        {'id': 1, 'body': '…따라오지 마.', 'situation': null, 'is_secret': 0},
      ],
      'tags': ['기사', '은발'],
      'gallery': [
        {'id': 1, 'width': 600, 'height': 800, 'caption': null, 'original_name': 'Lia.png'},
      ],
      'linked_projects': [],
      'project_genres': [
        {'id': 1, 'category': 'genre', 'name': '로맨스 판타지'},
      ],
    });

    expect(ch.nameEn, 'Lia Bellot');
    expect(ch.isFavorite, isTrue);
    expect(ch.inLibrary, isFalse);
    expect(ch.fields.single.isSecret, isTrue);
    expect(ch.traits.single.valuePercent, 28);
    expect(ch.quotes.single.isSecret, isFalse);
    expect(ch.gallery.single.originalName, 'Lia.png');
    expect(ch.projectGenres.single.name, '로맨스 판타지');
    expect(ch.bodyMd, isNull); // 빠진 값은 null
  });

  test('freezed: 값이 같으면 ==, copyWith는 새 객체', () {
    const a = CharacterSummary(id: 3, name: '미르', tags: ['NPC']);
    const b = CharacterSummary(id: 3, name: '미르', tags: ['NPC']);
    expect(a, b);
    expect(a.hashCode, b.hashCode);

    final renamed = a.copyWith(name: '미르2');
    expect(renamed.name, '미르2');
    expect(a.name, '미르'); // 원본은 그대로 (불변)
  });

  test('홈: 빠진 목록은 기본값 [], 세계관 숫자 같은 모르는 키는 무시', () {
    final home = HomeSummary.fromJson({
      'user': {'id': 1, 'login_name': 'dev', 'display_name': '서연'},
      'counts': {'characters': 6, 'worlds': 2, 'library_characters': 3, 'projects': 2, 'public_items': 3},
      'projects': [
        {
          'id': 1, 'kind': 'game', 'name': '잿빛 왕관', 'progress_percent': 60,
          'own_character_count': 1, 'linked_character_count': 2, 'genres': [],
        },
      ],
    });
    expect(home.user?.displayName, '서연');
    expect(home.counts.libraryCharacters, 3);
    expect(home.recentCharacters, isEmpty);
    expect(home.projects.single.characterCount, 3);
  });

  test('필터(유니온) → 서버 검색 조건은 data 쪽에서, 같은 필터는 ==', () {
    expect(CharactersRepositoryImpl.queryOf(const CharacterScope.all(), ''), isEmpty);
    expect(CharactersRepositoryImpl.queryOf(const CharacterScope.library(), ''), {'scope': 'library'});
    expect(CharactersRepositoryImpl.queryOf(const CharacterScope.project(id: 2, name: '서하린 챗봇'), '카'),
        {'project_id': '2', 'q': '카'});

    expect(const CharacterScope.project(id: 2, name: 'x'), const CharacterScope.project(id: 2, name: 'x'));
    expect(const CharacterScope.all(), isNot(const CharacterScope.library()));
  });
}
