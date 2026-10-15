// 홈 데이터 — @riverpod 함수 하나 = FutureProvider. 생성되는 이름은 함수 이름 + Provider = homeSummaryProvider.
// @riverpod(소문자)는 autoDispose: 홈 화면을 아무도 안 보면 값을 버리고, 다시 보면 새로 받는다.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/home_repository_impl.dart';
import '../domain/home_summary.dart';

part 'home_provider.g.dart';

@riverpod
Future<HomeSummary> homeSummary(Ref ref) => ref.watch(homeRepositoryProvider).fetchSummary();
