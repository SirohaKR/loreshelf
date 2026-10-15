// 리포지토리 인터페이스: 프로젝트를 "무엇을" 가져올 수 있나
import 'project.dart';

abstract interface class ProjectsRepository {
  Future<List<ProjectSummary>> fetchList();
  Future<ProjectDetail> fetchDetail(int id);
}
