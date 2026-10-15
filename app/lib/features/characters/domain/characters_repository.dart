// 리포지토리 인터페이스: 캐릭터를 "무엇을" 가져올 수 있나
import 'dart:typed_data';

import 'character.dart';
import 'character_draft.dart';
import 'character_scope.dart';

abstract interface class CharactersRepository {
  /// [scope] 안에서, [text]가 있으면 이름·소개·태그 검색
  Future<List<CharacterSummary>> fetchList({CharacterScope scope = const CharacterScope.all(), String text = ''});

  Future<CharacterDetail> fetchDetail(int id);

  /// [id]가 null이면 새로 만들고, 있으면 고친다. 저장된 상세를 돌려준다
  Future<CharacterDetail> save(int? id, CharacterDraft draft);

  /// 이미지 파일을 올리고 그 번호(asset id)를 돌려준다 — 아직 어느 캐릭터에도 안 붙은 상태
  Future<int> uploadImage(Uint8List bytes, String fileName);

  /// 갤러리에 넣기 ([setPortrait]면 대표 이미지로도)
  Future<CharacterDetail> addToGallery(int id, int assetId, {bool setPortrait = false});

  /// 갤러리에서 빼기 (대표 이미지였으면 대표도 비워진다)
  Future<CharacterDetail> removeFromGallery(int id, int assetId);

  Future<void> setFavorite(int id, bool favorite);

  /// [projectId]가 null이면 공용 서재로 꺼내기
  Future<CharacterDetail> move(int id, int? projectId);

  /// 복사본을 만들어 [projectId] 전용(또는 서재)으로 — 새 캐릭터를 돌려준다
  Future<CharacterDetail> fork(int id, int? projectId);

  /// 휴지통으로
  Future<void> delete(int id);
}
