// 챗봇 설정 API — 작품(스토리 묶음), 카드(노드), 카드 사이 선.
// 고치기(PUT)는 보낸 칸만 바꾼다 (캔버스에서 자리만 옮길 때 position_x/y만 보내도 되게).
import 'dart:convert';

import 'package:loreshelf_shared/loreshelf_shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/context.dart';
import '../../core/db.dart';
import '../../core/http.dart';
import '../../core/owned.dart';
import 'chatbot_repository.dart';

const chatbotEditModes = ['simple', 'canvas'];
const chatbotPlatforms = ['rofan', 'rplay'];

class ChatbotRoutes {
  final Db db;
  final ChatbotRepository chatbot;

  ChatbotRoutes(AppContext app)
      : db = app.db,
        chatbot = ChatbotRepository(app.db);

  void register(Router r) {
    r.get('/api/chatbot/meta', (Request req) => json(_meta()));
    r.get('/api/chatbot/stories', (Request req) =>
        json(chatbot.stories(req.ctx.user, characterId: toIntOrNull(req.url.queryParameters['character_id']))));
    r.post('/api/chatbot/stories', _createStory);
    r.get('/api/chatbot/stories/<id>', (Request req, String id) => json(chatbot.storyDetail(req.ctx.user, pathInt(id))));
    r.put('/api/chatbot/stories/<id>', _updateStory);
    r.delete('/api/chatbot/stories/<id>', (Request req, String id) {
      chatbot.softDeleteStory(req.ctx.user, pathInt(id));
      return ok();
    });

    r.post('/api/chatbot/stories/<id>/nodes', _createNode);
    r.get('/api/chatbot/nodes/<id>', (Request req, String id) => json(chatbot.node(req.ctx.user, pathInt(id))));
    r.put('/api/chatbot/nodes/<id>', _updateNode);
    r.delete('/api/chatbot/nodes/<id>', (Request req, String id) {
      chatbot.deleteNode(req.ctx.user, pathInt(id));
      return ok();
    });

    r.post('/api/chatbot/stories/<id>/links', _createLink);
    r.delete('/api/chatbot/links/<id>', (Request req, String id) {
      chatbot.deleteLink(req.ctx.user, pathInt(id));
      return ok();
    });
  }

  /// 웹 화면이 쓰는 표 — 카드 종류·이름, 빈 카드 모양, 플랫폼 글자 수 한도.
  /// 한도 숫자는 shared의 표(platform_limits.dart) 하나에만 두고 화면은 여기서 받아 쓴다.
  static Map<String, Object?> _meta() => {
        'kinds': chatbotNodeKinds,
        'kind_labels': chatbotNodeKindLabels,
        'empty_content': {for (final k in chatbotNodeKinds) k: emptyNodeContent(k)},
        'limits_checked_on': platformLimitsCheckedOn,
        'limits': {
          for (final e in platformLimits.entries)
            e.key: {'platform': e.value.platform, 'label': e.value.label, 'max': e.value.max, 'unit': e.value.unit.name},
        },
        'count_limits': {for (final e in platformCountLimits.entries) e.key: {'label': e.value.label, 'max': e.value.max}},
      };

  // ───── 작품 ─────

  Map<String, Object?> _storyValues(int uid, Map<String, Object?> b) {
    final platforms = b['target_platforms'];
    if (platforms is! List || platforms.any((p) => !chatbotPlatforms.contains(p))) {
      throw ApiError('내보낼 플랫폼은 ${chatbotPlatforms.join(', ')} 중에서 골라 주세요');
    }
    return {
      'main_character_id': ownedIdOrNull(db, 'characters', uid, b['main_character_id'], '대표 캐릭터'),
      'project_id': ownedIdOrNull(db, 'projects', uid, b['project_id'], '프로젝트'),
      'title': requireStr(b['title'], '작품 제목', max: 100),
      'edit_mode': oneOf(b['edit_mode'], chatbotEditModes, 'simple'),
      'target_platforms_json': jsonEncode([for (final p in chatbotPlatforms) if (platforms.contains(p)) p]),
      'sort_order': toIntOrNull(b['sort_order']) ?? 0,
    };
  }

  /// 새 작품 = 작품 + 가운데 스토리 카드 하나 (간편 모드는 이 카드에 나머지를 붙인다)
  Future<Response> _createStory(Request req) async {
    final uid = req.ctx.user;
    final v = _storyValues(uid, {'target_platforms': chatbotPlatforms, ...await body(req)});
    final id = db.tx(() {
      final id = chatbot.createStory(uid, v);
      chatbot.createNode(id, _nodeValues(uid, {'kind': 'story', 'title': v['title']}, kind: 'story'));
      return id;
    });
    return json(chatbot.storyDetail(uid, id), status: 201);
  }

  Future<Response> _updateStory(Request req, String id) async {
    final uid = req.ctx.user, sid = pathInt(id);
    chatbot.updateStory(uid, sid, _storyValues(uid, {...chatbot.story(uid, sid), ...await body(req)}));
    return json(chatbot.story(uid, sid));
  }

  // ───── 카드 ─────

  Map<String, Object?> _nodeValues(int uid, Map<String, Object?> b, {required String kind}) {
    final Map<String, Object?> content;
    try {
      content = normalizeNodeContent(kind, b['content']);
    } on ChatbotContentError catch (e) {
      throw ApiError(e.message);
    }
    return {
      'kind': kind,
      'title': strOrNull(b['title']) == null ? chatbotNodeKindLabels[kind] : requireStr(b['title'], '카드 이름', max: 100),
      'source_character_id': ownedIdOrNull(db, 'characters', uid, b['source_character_id'], '캐릭터'),
      'chatbot_status_view_id': ownedIdOrNull(db, 'chatbot_status_views', uid, b['chatbot_status_view_id'], '상태창'),
      'content_json': jsonEncode(content),
      'is_enabled': b.containsKey('is_enabled') ? toFlag(b['is_enabled']) : 1,
      'position_x': toIntOrNull(b['position_x']),
      'position_y': toIntOrNull(b['position_y']),
      'sort_order': toIntOrNull(b['sort_order']) ?? 0,
    };
  }

  Future<Response> _createNode(Request req, String id) async {
    final uid = req.ctx.user, sid = pathInt(id);
    chatbot.story(uid, sid);
    final b = await body(req);
    final kind = oneOf(strOrNull(b['kind']) ?? (throw ApiError('카드 종류를 골라 주세요')), chatbotNodeKinds, '');
    final values = _nodeValues(uid, b, kind: kind);
    // 간편 모드의 "카드 붙이기" = 카드 + 스토리 카드로 가는 선 하나 (같이 만들어야 반쪽짜리가 안 남음)
    final linkTo = toIntOrNull(b['link_to_chatbot_node_id']);
    final nid = db.tx(() {
      final nid = chatbot.createNode(sid, values);
      if (linkTo != null) chatbot.createLink(sid, nid, linkTo);
      return nid;
    });
    return json(chatbot.node(uid, nid), status: 201);
  }

  /// 카드 종류는 바꿀 수 없다 (칸 모양이 달라서). 다른 종류가 필요하면 새로 만든다.
  Future<Response> _updateNode(Request req, String id) async {
    final uid = req.ctx.user, nid = pathInt(id);
    final current = chatbot.node(uid, nid);
    final b = await body(req);
    if (b.containsKey('kind') && b['kind'] != current['kind']) throw ApiError('카드 종류는 바꿀 수 없어요');
    chatbot.updateNode(uid, nid, _nodeValues(uid, {...current, ...b}, kind: current['kind'] as String));
    return json(chatbot.node(uid, nid));
  }

  // ───── 선 ─────

  Future<Response> _createLink(Request req, String id) async {
    final uid = req.ctx.user, sid = pathInt(id);
    chatbot.story(uid, sid);
    final b = await body(req);
    final from = toIntOrNull(b['from_chatbot_node_id']) ?? (throw ApiError('잇기 시작할 카드를 골라 주세요'));
    final to = toIntOrNull(b['to_chatbot_node_id']) ?? (throw ApiError('이을 카드를 골라 주세요'));
    final lid = chatbot.createLink(sid, from, to);
    return json(chatbot.link(uid, lid), status: 201);
  }
}
