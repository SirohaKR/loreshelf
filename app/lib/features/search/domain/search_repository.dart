// 리포지토리 인터페이스: 통합 검색
import 'search_result.dart';

abstract interface class SearchRepository {
  /// [query]가 비어 있으면 서버에 묻지 않고 빈 결과
  Future<SearchResults> search(String query);
}
