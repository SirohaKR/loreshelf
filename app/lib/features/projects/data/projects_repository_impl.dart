// 리포지토리 구현: GET /api/projects, /api/projects/:id
// 고치기: POST·PUT /api/projects, 장르 태그 GET·POST·DELETE /api/genres, 이미지 POST /api/assets
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../domain/genre.dart';
import '../domain/project.dart';
import '../domain/project_draft.dart';
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

  @override
  Future<ProjectDetail> save(int? id, ProjectDraft draft) async => ProjectDetail.fromJson(
        id == null ? await _api.post('/api/projects', draft.toPayload()) : await _api.put('/api/projects/$id', draft.toPayload()),
      );

  @override
  Future<List<Genre>> fetchGenres() async => (await _api.getList('/api/genres')).map(Genre.fromJson).toList();

  @override
  Future<Genre> addGenre(String name) async => Genre.fromJson({...await _api.post('/api/genres', {'name': name}), 'is_custom': 1});

  @override
  Future<void> deleteGenre(int id) => _api.delete('/api/genres/$id');

  @override
  Future<int> uploadImage(Uint8List bytes, String fileName) async => (await _api.upload('/api/assets', bytes, fileName))['id'] as int;
}
