// 사용자 설정 API — 화면 테마 등. 저장할 수 있는 이름은 아래 목록에 있는 것만.
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/http.dart';
import 'settings_repository.dart';

/// 설정 이름 → 허용 값 (null이면 자유 글).
const _allowed = <String, List<String>?>{
  'theme': ['system', 'light', 'dark'],
  'chat_nickname': null, // 챗봇 미리보기에서 {{user}} 자리에 들어갈 대화용 별명 (비우면 계정 이름)
};

/// 자유 글 설정의 최대 글자 수
const _maxLength = {'chat_nickname': 30};

class SettingsRoutes {
  final SettingsRepository settings;
  SettingsRoutes(AppContext app) : settings = SettingsRepository(app.db);

  void register(Router r) {
    r.get('/api/settings', (Request req) => json(settings.all(req.ctx.user)));
    r.put('/api/settings', _put);
  }

  Future<Response> _put(Request req) async {
    final uid = req.ctx.user, b = await body(req);
    settings.db.tx(() {
      for (final e in b.entries) {
        if (!_allowed.containsKey(e.key)) throw ApiError('없는 설정이에요: ${e.key}');
        final values = _allowed[e.key], v = strOrNull(e.value);
        if (values != null && v != null && !values.contains(v)) throw ApiError('허용되지 않는 값이에요: $v');
        final max = _maxLength[e.key];
        if (max != null && v != null && v.runes.length > max) throw ApiError('$max자까지 적을 수 있어요');
        settings.put(uid, e.key, v);
      }
    });
    return json(settings.all(uid));
  }
}
