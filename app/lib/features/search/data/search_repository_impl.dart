// 리포지토리 구현: GET /api/search?q=검색어
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../domain/search_repository.dart';
import '../domain/search_result.dart';

part 'search_repository_impl.g.dart';

@Riverpod(keepAlive: true)
SearchRepository searchRepository(Ref ref) => SearchRepositoryImpl(ref.watch(apiClientProvider));

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<SearchResults> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const SearchResults();
    return SearchResults.fromJson(await _api.getMap('/api/search', {'q': q}));
  }
}
