// 리포지토리 인터페이스: 홈 요약 가져오기
import 'home_summary.dart';

abstract interface class HomeRepository {
  Future<HomeSummary> fetchSummary();
}
