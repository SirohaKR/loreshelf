// 프로젝트 목록 — 프로젝트 화면과 캐릭터 목록의 필터 칩이 함께 쓴다
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/projects_repository_impl.dart';
import '../domain/project.dart';

part 'project_list_provider.g.dart';

@riverpod
Future<List<ProjectSummary>> projectList(Ref ref) => ref.watch(projectsRepositoryProvider).fetchList();
