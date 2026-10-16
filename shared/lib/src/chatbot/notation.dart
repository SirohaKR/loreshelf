// 챗봇 글 속 표기 — {{char}}(캐릭터) · {{user}}(이용자) · {{var_이름}}(변수).
// 찾기(칩 색칠·잘못된 표기 제안), 플랫폼별 변환(내보내기), 미리보기 치환을 한 곳에서.
// 규칙: docs/planning/챗봇-설정-기획서.md 2-1(입력) · 2-2(미리보기) · 4-2(표기 변환)

/// 글 속 표기 종류. invalid = 고칠 표기(`{{Char}}`, `{user}`, `<char>`, `{{캐릭터}}` …)
enum NotationKind { char, user, variable, invalid }

class NotationMatch {
  final int start, end; // 글 속 위치 [start, end)
  final NotationKind kind;
  final String text; // 글에 적힌 그대로
  final String? name; // 변수 이름 (variable일 때)
  final String? suggestion; // 바꿀 표기 (invalid일 때) 예: '{{char}}'
  const NotationMatch(this.start, this.end, this.kind, this.text, {this.name, this.suggestion});
}

/// 내보낼 곳.
enum ChatbotPlatform { rofan, rplay, card }

// {{ … }} 한 덩어리, {char}/{user} 한 겹, <char>/<user>
final _pattern = RegExp(r'\{\{([^{}]*)\}\}|(?<!\{)\{\s*(char|user)\s*\}(?!\})|<\s*(char|user)\s*>', caseSensitive: false);
final _varName = RegExp(r'^var_([^{}\s]+)$');

/// 한국어로 잘못 적기 쉬운 이름 → 맞는 표기
const _aliases = {
  'char': '{{char}}', '캐릭터': '{{char}}', '캐릭': '{{char}}', '봇': '{{char}}',
  'user': '{{user}}', '유저': '{{user}}', '사용자': '{{user}}', '이용자': '{{user}}',
};

/// 글 속의 표기를 앞에서부터 찾는다. 상태창 `{{항목}}` 같은 다른 {{…}} 는 결과에 넣지 않는다.
List<NotationMatch> findNotations(String text) {
  final out = <NotationMatch>[];
  for (final m in _pattern.allMatches(text)) {
    final raw = m.group(0)!;
    final inner = m.group(1);
    if (inner == null) {
      // 한 겹 중괄호나 꺾쇠 — 항상 고칠 표기
      final word = (m.group(2) ?? m.group(3))!.toLowerCase();
      out.add(NotationMatch(m.start, m.end, NotationKind.invalid, raw, suggestion: '{{$word}}'));
      continue;
    }
    if (inner == 'char') {
      out.add(NotationMatch(m.start, m.end, NotationKind.char, raw));
    } else if (inner == 'user') {
      out.add(NotationMatch(m.start, m.end, NotationKind.user, raw));
    } else if (_varName.firstMatch(inner) case final v?) {
      out.add(NotationMatch(m.start, m.end, NotationKind.variable, raw, name: v.group(1)));
    } else {
      final trimmed = inner.trim();
      final alias = _aliases[trimmed.toLowerCase()];
      if (alias != null) {
        out.add(NotationMatch(m.start, m.end, NotationKind.invalid, raw, suggestion: alias));
      } else if (trimmed.toLowerCase().startsWith('var_') && trimmed.length > 4) {
        // {{ var_호감도 }}, {{VAR_호감도}}, {{var_호 감도}} → 공백 빼고 소문자 var_
        out.add(NotationMatch(m.start, m.end, NotationKind.invalid, raw,
            suggestion: '{{var_${trimmed.substring(4).replaceAll(RegExp(r'\s'), '')}}}'));
      }
    }
  }
  return out;
}

/// 잘못된 표기를 전부 제안대로 고친다 ("모두 고치기" 버튼).
String fixNotations(String text) => _replace(text, (m) => m.kind == NotationKind.invalid ? m.suggestion : null);

/// 글에 쓰인 변수 이름들 (겹치는 건 한 번, 나온 순서대로).
List<String> variablesIn(String text) =>
    {for (final m in findNotations(text)) if (m.kind == NotationKind.variable) m.name!}.toList();

/// 플랫폼에 붙여 넣을 모양으로 바꾼다 (기획서 4-2).
/// - 로판AI: {{char}}·{{user}} 그대로, 변수는 글 안에선 낱말("호감도"), 트래커 안([inTracker])에선 {{호감도}}
/// - 로플챗: {{char}} → [charName] (로플 문서에 {{char}}가 없음), {{user}}·{{var_…}} 그대로
/// - 카드 V2/V3: {{char}}·{{user}} 그대로, 변수는 낱말
/// 잘못된 표기는 손대지 않는다(내보내기 화면이 경고로 보여 줌).
String convertNotation(String text, ChatbotPlatform platform, {required String charName, bool inTracker = false}) =>
    _replace(text, (m) {
      switch (m.kind) {
        case NotationKind.char:
          return platform == ChatbotPlatform.rplay ? charName : null;
        case NotationKind.variable:
          if (platform == ChatbotPlatform.rplay) return null;
          return platform == ChatbotPlatform.rofan && inTracker ? '{{${m.name}}}' : m.name;
        case NotationKind.user:
        case NotationKind.invalid:
          return null;
      }
    });

/// 저장 후 미리보기: {{char}} → 캐릭터 이름, {{user}} → 대화용 별명, {{var_x}} → 예시 값(없으면 이름),
/// 상태창 {{항목}} → [values]에 있으면 그 예시 값 (기획서 2-2).
String renderPreview(String text, {required String charName, required String userName, Map<String, String> values = const {}}) {
  final withNotations = _replace(text, (m) => switch (m.kind) {
        NotationKind.char => charName,
        NotationKind.user => userName,
        NotationKind.variable => values[m.name] ?? m.name,
        NotationKind.invalid => null,
      });
  if (values.isEmpty) return withNotations;
  return withNotations.replaceAllMapped(RegExp(r'\{\{([^{}]+)\}\}'), (m) => values[m.group(1)!] ?? m.group(0)!);
}

/// 찾은 표기를 [pick]이 돌려준 글로 바꾼다 (null이면 그대로).
String _replace(String text, String? Function(NotationMatch m) pick) {
  final sb = StringBuffer();
  var at = 0;
  for (final m in findNotations(text)) {
    final to = pick(m);
    if (to == null) continue;
    sb
      ..write(text.substring(at, m.start))
      ..write(to);
    at = m.end;
  }
  sb.write(text.substring(at));
  return sb.toString();
}
