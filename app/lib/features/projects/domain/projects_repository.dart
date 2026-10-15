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
}
