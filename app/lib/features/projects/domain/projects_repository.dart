// 리포지토리 인터페이스: 프로젝트를 "무엇을" 가져올 수 있나
import 'dart:typed_data';

import 'genre.dart';
import 'project.dart';
import 'project_draft.dart';

abstract interface class ProjectsRepository {
  Future<List<ProjectSummary>> fetchList();
  Future<ProjectDetail> fetchDetail(int id);

  /// [id]가 null이면 새로 만들고, 있으면 고친다
  Future<ProjectDetail> save(int? id, ProjectDraft draft);

  /// 장르·세계관 태그 전체 (기본 + 내가 추가한 것)
  Future<List<Genre>> fetchGenres();

  /// 태그 직접 추가 — 같은 이름이 있으면 그걸 돌려준다
  Future<Genre> addGenre(String name);

  /// 내가 추가한 태그 지우기
  Future<void> deleteGenre(int id);

  /// 대표 이미지 올리기 → 파일 번호
  Future<int> uploadImage(Uint8List bytes, String fileName);

  /// 서재 캐릭터를 이 프로젝트에 연결 (이미 연결돼 있으면 역할만 바꿈). 캐릭터는 그대로 공용 서재에 남는다
  Future<ProjectDetail> linkCharacter(int projectId, int characterId, {String? role});

  /// 연결 끊기 (캐릭터 자체는 지워지지 않는다)
  Future<ProjectDetail> unlinkCharacter(int projectId, int characterId);

  /// 휴지통으로 (이 프로젝트 전용 캐릭터도 같이 숨겨진다 — 서버가 한다)
  Future<void> delete(int id);
}
