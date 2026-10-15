// 검색 결과 — family: searchProvider(query). 검색어가 다르면 따로 캐시된다
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/search_repository_impl.dart';
import '../domain/search_result.dart';

part 'search_provider.g.dart';

@riverpod
Future<SearchResults> search(Ref ref, String query) => ref.watch(searchRepositoryProvider).search(query);
