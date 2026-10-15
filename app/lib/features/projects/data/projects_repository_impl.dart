// 리포지토리 구현: GET /api/projects, /api/projects/:id
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../domain/project.dart';
import '../domain/projects_repository.dart';

part 'projects_repository_impl.g.dart';

@Riverpod(keepAlive: true)
ProjectsRepository projectsRepository(Ref ref) => ProjectsRepositoryImpl(ref.watch(apiClientProvider));

class ProjectsRepositoryImpl implements ProjectsRepository {
  ProjectsRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<List<ProjectSummary>> fetchList() async =>
      (await _api.getList('/api/projects')).map(ProjectSummary.fromJson).toList();

  @override
  Future<ProjectDetail> fetchDetail(int id) async => ProjectDetail.fromJson(await _api.getMap('/api/projects/$id'));
}
