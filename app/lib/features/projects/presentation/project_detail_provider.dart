// 프로젝트 상세 — 함수에 매개변수(id)를 더 받으면 "family"가 된다: projectDetailProvider(3)
// id마다 따로 캐시된다 (Map<int, 상세>와 비슷).
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/projects_repository_impl.dart';
import '../domain/project.dart';

part 'project_detail_provider.g.dart';

@riverpod
Future<ProjectDetail> projectDetail(Ref ref, int id) => ref.watch(projectsRepositoryProvider).fetchDetail(id);
