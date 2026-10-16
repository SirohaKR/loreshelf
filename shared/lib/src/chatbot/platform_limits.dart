// 플랫폼별 입력칸 한도 — 로판AI · 로플챗(알플레이 스토리챗). 숫자는 이 표 하나에만 둔다.
// 두 플랫폼 다 자주 바뀌므로, 바뀌면 여기 숫자와 [platformLimitsCheckedOn] 만 고친다.
// 출처: docs/planning/챗봇-설정-기획서.md 1절 (로플 공식 크리에이터 가이드, 로판 제작 화면 직접 확인)

/// 이 표를 마지막으로 확인한 날 (화면에 "기준일"로 보여 줌)
const platformLimitsCheckedOn = '2026-10-16';

/// 세는 단위. 로판은 글자, 로플은 대부분 토큰(o200k_base)이고 크리에이터 공지만 글자.
enum LimitUnit { chars, tokens }

class PlatformLimit {
  final String platform; // 'rofan' | 'rplay'
  final String label; // 화면에 보이는 칸 이름
  final int max;
  final LimitUnit unit;
  const PlatformLimit(this.platform, this.label, this.max, this.unit);

  String get unitLabel => unit == LimitUnit.chars ? '자' : '토큰';
}

/// 칸 하나의 한도. 키 = '플랫폼.카드.칸' (간편 모드만 다른 값은 'rplay_simple.…')
const platformLimits = <String, PlatformLimit>{
  // ── 로판AI (단위: 글자) ──
  'rofan.character.name': PlatformLimit('rofan', '캐릭터 이름', 15, LimitUnit.chars),
  'rofan.character.one_line': PlatformLimit('rofan', '한줄 소개', 50, LimitUnit.chars),
  'rofan.detail': PlatformLimit('rofan', '세부 설정(세계관+캐릭터 소개+비밀)', 6000, LimitUnit.chars),
  'rofan.start.name': PlatformLimit('rofan', '시작 설정 이름', 15, LimitUnit.chars),
  'rofan.start.body': PlatformLimit('rofan', '시작 상황', 1000, LimitUnit.chars),
  'rofan.creator_comment': PlatformLimit('rofan', '제작자 코멘트', 5000, LimitUnit.chars),
  'rofan.tracker.name': PlatformLimit('rofan', '트래커 이름', 10, LimitUnit.chars),
  'rofan.tracker.item_name': PlatformLimit('rofan', '트래커 항목 이름', 15, LimitUnit.chars),
  'rofan.tracker.items_total': PlatformLimit('rofan', '트래커 항목 전체', 1000, LimitUnit.chars),
  'rofan.tracker.ai_request': PlatformLimit('rofan', '트래커 AI 편집 요청', 150, LimitUnit.chars),

  // ── 로플챗 캔버스 모드 (단위: 토큰, 공지만 글자) ──
  'rplay.story.key_info': PlatformLimit('rplay', '스토리 중요 정보', 2000, LimitUnit.tokens),
  'rplay.story.full_story': PlatformLimit('rplay', '전체 스토리', 30000, LimitUnit.tokens),
  'rplay.story.start_message': PlatformLimit('rplay', '시작 메시지', 1000, LimitUnit.tokens),
  'rplay.story.start_guide': PlatformLimit('rplay', '시작 가이드', 300, LimitUnit.tokens),
  'rplay.story.creator_notice': PlatformLimit('rplay', '크리에이터 공지', 500, LimitUnit.chars),
  'rplay.character.key_info': PlatformLimit('rplay', '인물 중요 정보', 300, LimitUnit.tokens),
  'rplay.image.description': PlatformLimit('rplay', '이미지 설명', 300, LimitUnit.tokens),
  'rplay.macro.body': PlatformLimit('rplay', '매크로 내용', 300, LimitUnit.tokens),
  'rplay.preset_note.body': PlatformLimit('rplay', '프리셋 노트 내용', 500, LimitUnit.tokens),
  'rplay.update_rule.body': PlatformLimit('rplay', '업데이트 규칙', 400, LimitUnit.tokens),

  // ── 로플챗 간편 모드에서만 다른 값 ──
  'rplay_simple.story.key_info': PlatformLimit('rplay', '스토리 카드 중요 정보(간편)', 5500, LimitUnit.tokens),
};

/// 개수 한도 (글자 수가 아니라 몇 개까지인지)
const platformCountLimits = <String, ({String label, int max})>{
  'rofan.category': (label: '로판 카테고리', max: 3),
  'rofan.command': (label: '로판 커맨드(캐릭터당)', max: 20),
  'rofan.tracker': (label: '로판 트래커(캐릭터당)', max: 5),
  'rofan.asset': (label: '로판 캐릭터 에셋', max: 50),
  'rplay.start_node': (label: '로플 시작 노드(캔버스당)', max: 30),
  'rplay.image.tag': (label: '로플 이미지 태그', max: 7),
  'rplay.macro_per_turn': (label: '로플 한 턴에 들어가는 매크로', max: 5),
  'rplay.preset_note.per_node': (label: '로플 프리셋 노트(노드당)', max: 10),
  'rplay.preset_note.node': (label: '로플 프리셋 노트 노드(스토리당)', max: 10),
  'rplay.variable': (label: '로플 변수(허브 포함)', max: 50),
  'rplay.update_rule': (label: '로플 업데이트 규칙(스토리당)', max: 7),
  'rplay.status_view': (label: '로플 상태창(스토리당)', max: 1),
  'rplay.hub_depth': (label: '로플 허브 단계', max: 3),
  'rplay.achievement.reward_credits': (label: '로플 업적 리워드 크레딧', max: 5000),
};

/// 로판 "글자" 세기 — 띄어쓰기·줄바꿈 포함, 이모지 같은 글자도 한 글자.
int countChars(String text) => text.runes.length;

/// 로플 토큰 근사치 (o200k_base를 흉내 낸 대충 셈). 입력하는 동안 보여 주는 값이라 "≈"를 붙여 보여 준다.
/// 정확한 값은 서버가 o200k_base 사전으로 센다(기획서 결정 2) — 내보내기 전엔 그 값으로 다시 검사.
/// 기준: 한글 음절 0.75 · 영어/숫자 4글자에 1 · 띄어쓰기는 앞 낱말에 붙음 · 그 밖의 기호·한자·이모지는 1.
int estimateTokens(String text) {
  var hangul = 0, latin = 0, other = 0;
  for (final r in text.runes) {
    if (r >= 0xAC00 && r <= 0xD7A3) {
      hangul++;
    } else if ((r >= 0x30 && r <= 0x39) || (r >= 0x41 && r <= 0x5A) || (r >= 0x61 && r <= 0x7A)) {
      latin++;
    } else if (r == 0x20 || r == 0x09) {
      // 띄어쓰기는 대개 다음 낱말 토큰에 붙는다
    } else {
      other++;
    }
  }
  return (hangul * 0.75 + latin / 4 + other).ceil();
}

/// 칸 상태 — 90% 이상이면 주황, 넘으면 빨강 (기획서 4-3)
enum LimitLevel { ok, near, over }

class LimitCheck {
  final int count;
  final PlatformLimit limit;
  final bool isEstimate; // 토큰 근사치면 true
  const LimitCheck(this.count, this.limit, {this.isEstimate = false});

  LimitLevel get level => count > limit.max ? LimitLevel.over : (count * 10 >= limit.max * 9 ? LimitLevel.near : LimitLevel.ok);

  /// 화면 표시: "1,240/6,000자", 토큰이면 "≈ 980/2,000토큰"
  String get display => '${isEstimate ? '≈ ' : ''}${_comma(count)}/${_comma(limit.max)}${limit.unitLabel}';
}

/// [key]의 한도로 [text]를 센다. 토큰 칸은 근사치(서버가 정확히 센 값이 있으면 [exactTokens]로 넘김).
LimitCheck checkLimit(String key, String text, {int? exactTokens}) {
  final limit = platformLimits[key] ?? (throw ArgumentError('없는 한도 이름: $key'));
  if (limit.unit == LimitUnit.chars) return LimitCheck(countChars(text), limit);
  return LimitCheck(exactTokens ?? estimateTokens(text), limit, isEstimate: exactTokens == null);
}

String _comma(int n) => n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
