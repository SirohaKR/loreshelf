// 챗봇 카드(노드) 종류와 종류별 content_json 모양 — 서버(저장 전 검사)와 앱(편집 화면)이 같이 쓴다.
// 종류별 테이블 13개 대신 JSON 한 칸에 담는 이유: 플랫폼이 칸을 자주 바꿔서 마이그레이션 없이 따라가려고.
// 그래서 모양 검사는 여기 한 곳에서만 한다. JSON 키는 DB 규칙대로 snake_case.
//
// 글자 수 한도(플랫폼마다 다름)는 여기서 막지 않는다 → platform_limits.dart 에서 경고로.
// 여기서 막는 것: 자료형, 정해진 값(선택지), 플랫폼 입력칸 자체가 받는 범위(매크로 지속 턴 1~5 등).

/// 카드 종류 — DB chatbot_nodes.kind 값과 같은 순서·이름.
const chatbotNodeKinds = [
  'story', 'character', 'user', 'image', 'macro', 'extra_cast',
  'preset_note', 'variable', 'update_rule', 'trigger', 'status_view', 'achievement', 'hub',
];

/// 화면에 보이는 이름.
const chatbotNodeKindLabels = {
  'story': '스토리',
  'character': '인물',
  'user': '유저',
  'image': '이미지',
  'macro': '매크로',
  'extra_cast': '기타 인물',
  'preset_note': '프리셋 노트',
  'variable': '변수',
  'update_rule': '업데이트 규칙',
  'trigger': '트리거',
  'status_view': '상태창',
  'achievement': '업적',
  'hub': '허브',
};

/// content_json 모양이 틀렸을 때. message는 화면에 그대로 보여 줄 한국어.
class ChatbotContentError implements Exception {
  final String message;
  ChatbotContentError(this.message);
  @override
  String toString() => message;
}

// ───── 칸 정의 ─────

sealed class _Field {
  final String label;
  const _Field(this.label);
  Object? normalize(Object? v);
}

/// 글 (없으면 빈 글)
class _Text extends _Field {
  const _Text(super.label);
  @override
  Object? normalize(Object? v) {
    if (v == null) return '';
    if (v is String) return v;
    throw ChatbotContentError('$label은(는) 글이어야 해요');
  }
}

/// 정수 (범위가 있으면 검사). 기본값이 없으면 비워 둘 수 있음(null)
class _Int extends _Field {
  final int? min, max;
  final int? defaultValue;
  const _Int(super.label, {this.min, this.max, this.defaultValue});
  @override
  Object? normalize(Object? v) {
    if (v == null || v == '') return defaultValue;
    final n = v is int ? v : (v is num && v == v.roundToDouble() ? v.toInt() : (v is String ? int.tryParse(v.trim()) : null));
    if (n == null) throw ChatbotContentError('$label은(는) 정수여야 해요');
    if ((min != null && n < min!) || (max != null && n > max!)) {
      throw ChatbotContentError('$label은(는) ${min ?? ''}~${max ?? ''} 사이여야 해요');
    }
    return n;
  }
}

class _Bool extends _Field {
  final bool defaultValue;
  const _Bool(super.label, {this.defaultValue = false});
  @override
  Object? normalize(Object? v) {
    if (v == null) return defaultValue;
    if (v is bool) return v;
    if (v == 1 || v == 0) return v == 1;
    throw ChatbotContentError('$label은(는) 참/거짓이어야 해요');
  }
}

/// 정해진 값 중 하나
class _Choice extends _Field {
  final List<String> values;
  const _Choice(super.label, this.values);
  @override
  Object? normalize(Object? v) {
    if (v == null) return values.first;
    if (v is String && values.contains(v)) return v;
    throw ChatbotContentError('$label 값이 이상해요: $v');
  }
}

/// 글 목록 (빈 글·앞뒤 공백은 정리)
class _TextList extends _Field {
  const _TextList(super.label);
  @override
  Object? normalize(Object? v) {
    if (v == null) return <String>[];
    if (v is! List) throw ChatbotContentError('$label은(는) 목록이어야 해요');
    final out = <String>[];
    for (final e in v) {
      if (e is! String) throw ChatbotContentError('$label 안에 글이 아닌 값이 있어요');
      if (e.trim().isNotEmpty) out.add(e.trim());
    }
    return out;
  }
}

/// 묶음 목록 (각 줄이 같은 모양)
class _ObjectList extends _Field {
  final Map<String, _Field> shape;
  const _ObjectList(super.label, this.shape);
  @override
  Object? normalize(Object? v) {
    if (v == null) return <Map<String, Object?>>[];
    if (v is! List) throw ChatbotContentError('$label은(는) 목록이어야 해요');
    return [for (final e in v) _normalizeShape(shape, e, label)];
  }
}

Map<String, Object?> _normalizeShape(Map<String, _Field> shape, Object? raw, String where) {
  raw ??= const <String, Object?>{};
  if (raw is! Map) throw ChatbotContentError('$where 모양이 이상해요');
  // 모르는 키는 버린다 (예전 버전 화면이 보낸 칸이 쌓이지 않게)
  return {for (final e in shape.entries) e.key: e.value.normalize(raw[e.key])};
}

// ───── 종류별 모양 (기획서 1-1 표 · 2-4 기타 인물 · 3-2 예시) ─────

const _storyShape = {
  'is_start': _Bool('시작 노드', defaultValue: true), // 로플 캔버스: 켠 노드만 시작 메시지·가이드
  'key_info': _Text('중요 정보'), // 매 턴 AI에 전달
  'full_story': _Text('전체 스토리'), // 참고 자료(컴파일)
  'start_messages': _ObjectList('시작 메시지', {'name': _Text('이름'), 'body': _Text('내용')}), // 로판 시작 설정 여러 개
  'start_guide': _Text('시작 가이드'),
  'creator_notice': _Text('크리에이터 공지'),
};

const _characterShape = {
  'one_line': _Text('한 줄 소개'),
  'key_info': _Text('중요 정보'),
  'detail': _Text('상세 설명'),
  'secret': _Text('비밀'),
  'solo_first_message': _Text('단독 대화 첫 메시지'),
  'display_priority': _Int('표시 우선순위', defaultValue: 0),
  'show_in_preview': _Bool('미리보기에 보이기', defaultValue: true),
};

const _userShape = {
  'name': _Text('이름'), // 비우면 {{user}} (이용자 별명)
  'body': _Text('설정'),
};

const _imageShape = {
  'asset_id': _Int('이미지 파일'), // assets.id
  'usage': _Choice('쓰임', ['emotion', 'situation', 'background']),
  'description': _Text('설명'),
  'tags': _TextList('태그'),
};

const _macroShape = {
  'mode': _Choice('발동 방식', ['always', 'keyword']),
  'keywords': _TextList('낱말'),
  'body': _Text('내용'),
  'priority': _Int('우선순위', defaultValue: 0),
  'duration_turns': _Int('지속 턴 수', min: 1, max: 5, defaultValue: 1),
};

const _extraCastShape = {
  'people': _ObjectList('기타 인물', {
    'name': _Text('이름'),
    'role': _Text('역할·관계'),
    'speech': _Text('말투'),
    'first_scene': _Text('처음 나오는 상황'),
    'character_id': _Int('서재 캐릭터'), // characters.id (선택)
  }),
  'allow_improvised': _Bool('즉흥 등장', defaultValue: true),
  'improvise_rule': _Text('즉흥 등장 규칙'),
};

const _presetNoteShape = {
  'notes': _ObjectList('프리셋', {
    'emoji': _Text('이모지'),
    'title': _Text('제목'),
    'description': _Text('설명'),
    'body': _Text('내용'),
    'priority': _Int('우선순위', defaultValue: 0),
  }),
};

const _variableShape = {
  'name': _Text('변수 이름'), // { } 금지는 validateVariableName
  'value_kind': _Choice('종류', ['number', 'boolean', 'text']),
  'initial_value': _Text('처음 값'),
};

const _updateRuleShape = {
  'body': _Text('규칙'), // 변수는 {{var_이름}}
};

/// 트리거: 조건을 모두 만족하면 동작들을 켠다. 대상 카드는 같은 작품의 노드 번호
const _triggerShape = {
  'conditions': _ObjectList('조건', {
    'variable': _Text('변수'),
    'operator': _Choice('비교', ['eq', 'ne', 'gt', 'gte', 'lt', 'lte']),
    'value': _Text('값'),
  }),
  'actions': _ObjectList('동작', {
    'action': _Choice('동작 종류', ['scene', 'image', 'macro', 'preset_note', 'achievement']),
    'chatbot_node_id': _Int('대상 카드'),
  }),
};

const _statusViewShape = <String, _Field>{}; // 내용은 chatbot_status_views 테이블 (chatbot_status_view_id)

const _achievementShape = {
  'asset_id': _Int('이미지 파일'),
  'description': _Text('설명'),
  'display_priority': _Int('표시 우선순위', defaultValue: 0),
  'is_hidden': _Bool('히든'),
  'hint': _Text('힌트'),
  'reward_credits': _Int('리워드 크레딧', min: 0, max: 5000, defaultValue: 0),
};

const _hubShape = <String, _Field>{};

const Map<String, Map<String, _Field>> _shapes = {
  'story': _storyShape,
  'character': _characterShape,
  'user': _userShape,
  'image': _imageShape,
  'macro': _macroShape,
  'extra_cast': _extraCastShape,
  'preset_note': _presetNoteShape,
  'variable': _variableShape,
  'update_rule': _updateRuleShape,
  'trigger': _triggerShape,
  'status_view': _statusViewShape,
  'achievement': _achievementShape,
  'hub': _hubShape,
};

/// 화면·요청에서 온 content를 검사해서 저장할 모양으로 정리한다.
/// 빠진 칸은 기본값으로 채우고, 모르는 키는 버린다. 틀리면 [ChatbotContentError].
Map<String, Object?> normalizeNodeContent(String kind, Object? raw) {
  final shape = _shapes[kind] ?? (throw ChatbotContentError('없는 카드 종류예요: $kind'));
  final out = _normalizeShape(shape, raw, chatbotNodeKindLabels[kind]!);
  if (kind == 'variable') {
    final problem = validateVariableName(out['name'] as String);
    if (problem != null && (out['name'] as String).isNotEmpty) throw ChatbotContentError(problem);
  }
  return out;
}

/// 새 카드의 빈 내용 (기본값만 채운 것).
Map<String, Object?> emptyNodeContent(String kind) => normalizeNodeContent(kind, const <String, Object?>{});

/// 변수 이름 검사 — 로플챗은 `{` `}` 를 못 쓰고, `{{var_이름}}` 으로 적기 때문에 공백도 막는다. 문제 없으면 null.
String? validateVariableName(String name) {
  if (name.trim().isEmpty) return '변수 이름을 적어 주세요';
  if (name.contains('{') || name.contains('}')) return '변수 이름에 { } 는 쓸 수 없어요';
  if (RegExp(r'\s').hasMatch(name)) return '변수 이름에 띄어쓰기는 쓸 수 없어요';
  return null;
}
