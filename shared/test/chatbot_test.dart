import 'package:loreshelf_shared/loreshelf_shared.dart';
import 'package:test/test.dart';

void main() {
  group('카드 내용 모양', () {
    test('13종 모두 빈 내용을 만들 수 있다', () {
      expect(chatbotNodeKinds, hasLength(13));
      for (final k in chatbotNodeKinds) {
        expect(chatbotNodeKindLabels[k], isNotNull, reason: k);
        expect(emptyNodeContent(k), isA<Map<String, Object?>>(), reason: k);
      }
      expect(emptyNodeContent('macro'), {'mode': 'always', 'keywords': <String>[], 'body': '', 'priority': 0, 'duration_turns': 1});
    });

    test('빠진 칸은 기본값, 모르는 키는 버림, 목록 안 공백 정리', () {
      final c = normalizeNodeContent('story', {
        'key_info': '{{char}}는 편의점 알바생',
        'start_messages': [
          {'name': '기본', 'body': '어서 오세요', 'extra': 1},
        ],
        'old_field': 'x',
      });
      expect(c.containsKey('old_field'), isFalse);
      expect(c['full_story'], '');
      expect(c['is_start'], isTrue);
      expect(c['start_messages'], [
        {'name': '기본', 'body': '어서 오세요'},
      ]);
      expect(normalizeNodeContent('image', {'tags': [' 웃음 ', '', '울음']})['tags'], ['웃음', '울음']);
    });

    test('기타 인물: 목록 + 즉흥 등장 규칙', () {
      final c = normalizeNodeContent('extra_cast', {
        'people': [
          {'name': '편의점 사장', 'role': '50대, 폐기 도시락 챙김', 'speech': '사투리', 'character_id': '12'},
        ],
        'allow_improvised': false,
      });
      expect((c['people'] as List).single, {'name': '편의점 사장', 'role': '50대, 폐기 도시락 챙김', 'speech': '사투리', 'first_scene': '', 'character_id': 12});
      expect(c['allow_improvised'], isFalse);
    });

    test('틀린 값은 한국어 오류', () {
      expect(() => normalizeNodeContent('nope', {}), throwsA(isA<ChatbotContentError>()));
      expect(() => normalizeNodeContent('macro', {'mode': 'sometimes'}), throwsA(isA<ChatbotContentError>()));
      expect(() => normalizeNodeContent('macro', {'duration_turns': 6}), throwsA(isA<ChatbotContentError>()));
      expect(() => normalizeNodeContent('story', {'key_info': 3}), throwsA(isA<ChatbotContentError>()));
      expect(() => normalizeNodeContent('story', 'text'), throwsA(isA<ChatbotContentError>()));
      expect(() => normalizeNodeContent('achievement', {'reward_credits': 5001}), throwsA(isA<ChatbotContentError>()));
      expect(() => normalizeNodeContent('variable', {'name': '호{감}도'}), throwsA(isA<ChatbotContentError>()));
      expect(() => normalizeNodeContent('trigger', {'conditions': [{'operator': '=='}]}), throwsA(isA<ChatbotContentError>()));
    });

    test('변수 이름 검사', () {
      expect(validateVariableName('호감도'), isNull);
      expect(validateVariableName('호 감도'), isNotNull);
      expect(validateVariableName(''), isNotNull);
    });
  });

  group('글자 수 한도', () {
    test('기준일과 주요 숫자', () {
      expect(platformLimitsCheckedOn, '2026-10-16');
      expect(platformLimits['rofan.detail']!.max, 6000);
      expect(platformLimits['rplay.story.key_info']!.max, 2000);
      expect(platformLimits['rplay_simple.story.key_info']!.max, 5500);
      expect(platformLimits['rplay.story.creator_notice']!.unit, LimitUnit.chars);
    });

    test('로판은 글자(이모지도 한 글자), 로플은 토큰 근사치', () {
      expect(countChars('안녕 😀'), 4);
      expect(estimateTokens(''), 0);
      expect(estimateTokens('hello world'), lessThan(countChars('hello world')));
      expect(estimateTokens('가' * 100), greaterThan(estimateTokens('가' * 50)));
    });

    test('90% 주황, 넘으면 빨강, 표시 글', () {
      expect(checkLimit('rofan.character.name', '가' * 10).level, LimitLevel.ok);
      expect(checkLimit('rofan.character.name', '가' * 14).level, LimitLevel.near);
      expect(checkLimit('rofan.character.name', '가' * 16).level, LimitLevel.over);
      expect(checkLimit('rofan.detail', '가' * 1240).display, '1,240/6,000자');
      expect(checkLimit('rplay.story.key_info', 'x', exactTokens: 980).display, '980/2,000토큰');
      expect(checkLimit('rplay.story.key_info', 'abcd').display, startsWith('≈ '));
      expect(() => checkLimit('nope', ''), throwsArgumentError);
    });
  });

  group('표기', () {
    test('바른 표기와 잘못된 표기 찾기', () {
      final found = findNotations('{{char}}가 {{user}}에게 {{var_호감도}} · {{Char}} {user} <char> {{캐릭터}} {{ var_기분 }} {{장소}}');
      expect(found.map((m) => m.kind), [
        NotationKind.char, NotationKind.user, NotationKind.variable,
        NotationKind.invalid, NotationKind.invalid, NotationKind.invalid, NotationKind.invalid, NotationKind.invalid,
      ]);
      expect(found[2].name, '호감도');
      expect(found.skip(3).map((m) => m.suggestion), ['{{char}}', '{{user}}', '{{char}}', '{{char}}', '{{var_기분}}']);
    });

    test('모두 고치기', () {
      expect(fixNotations('{{USER}}와 <Char>, {{유저}}'), '{{user}}와 {{char}}, {{user}}');
    });

    test('플랫폼별 변환 (기획서 4-2)', () {
      const t = '{{char}}는 {{user}}를 본다. {{var_호감도}}';
      expect(convertNotation(t, ChatbotPlatform.rofan, charName: '세린'), '{{char}}는 {{user}}를 본다. 호감도');
      expect(convertNotation(t, ChatbotPlatform.rofan, charName: '세린', inTracker: true), '{{char}}는 {{user}}를 본다. {{호감도}}');
      expect(convertNotation(t, ChatbotPlatform.rplay, charName: '세린'), '세린는 {{user}}를 본다. {{var_호감도}}');
      expect(convertNotation(t, ChatbotPlatform.card, charName: '세린'), '{{char}}는 {{user}}를 본다. 호감도');
      expect(convertNotation('{{Char}}', ChatbotPlatform.rplay, charName: '세린'), '{{Char}}'); // 잘못된 건 그대로(경고로)
    });

    test('미리보기 치환', () {
      expect(
        renderPreview('{{char}}: 어서 와, {{user}}. 호감 {{var_호감도}} · {{장소}} · {{없음}}',
            charName: '세린', userName: '시로', values: {'호감도': '♥♥♡', '장소': '편의점'}),
        '세린: 어서 와, 시로. 호감 ♥♥♡ · 편의점 · {{없음}}',
      );
      expect(variablesIn('{{var_a}} {{var_b}} {{var_a}}'), ['a', 'b']);
    });
  });
}
