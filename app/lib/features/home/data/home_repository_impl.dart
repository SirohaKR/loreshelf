// 리포지토리 구현: GET /api/home
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_client_provider.dart';
import '../domain/home_repository.dart';
import '../domain/home_summary.dart';

part 'home_repository_impl.g.dart';

@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) => HomeRepositoryImpl(ref.watch(apiClientProvider));

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<HomeSummary> fetchSummary() async => HomeSummary.fromJson(await _api.getMap('/api/home'));
}
