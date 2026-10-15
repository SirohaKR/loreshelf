// 기기에 남겨 두는 값(서버 주소, 세션 쿠키, 테마)을 담는 SharedPreferences.
// 열 때 비동기라서 main()에서 먼저 열고 ProviderScope.overrides로 넣어 준다.
// 여기서 바로 쓰려고 하면 아직 안 넣었다는 뜻이라 에러를 낸다.
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError('main()에서 override 해야 해요');
