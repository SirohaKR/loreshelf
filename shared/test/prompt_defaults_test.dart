import 'package:loreshelf_shared/loreshelf_shared.dart';
import 'package:test/test.dart';

void main() {
  final p = parsePrompt('masterpiece, Best_Quality, anime style, 1boy, black hair\nNegative prompt: lowres, bad hands, extra ears');

  test('붙여 넣을 때 공통 기본값과 겹치는 태그는 뺀다 (대소문자·밑줄 무시)', () {
    final s = stripPromptDefaults(p.categories, p.negative, quality: initialDefaultQuality, defaultNegative: initialDefaultNegative);
    expect(s.tags.containsKey('quality'), isFalse);
    expect([for (final t in s.tags['style']!) t.tag], ['anime style']); // 화풍은 캐릭터 쪽에 그대로
    expect(s.negative, ['extra ears']);
    expect(s.removedQuality, ['masterpiece', 'Best_Quality']);
    expect(s.removedNegative, ['lowres', 'bad hands']);
  });

  test('복사할 때는 기본값을 앞에 합친다', () {
    final w = withPromptDefaults(
      {'character': [const PromptTag('1boy', 1)], 'quality': [const PromptTag('absurdres', 1), const PromptTag('masterpiece', 1)]},
      ['extra ears', 'lowres'],
      quality: ['masterpiece', 'best quality'],
      defaultNegative: ['lowres', 'bad hands'],
    );
    expect(formatPrompt(w.tags, negative: w.negative), '1boy, masterpiece, best quality, absurdres\nNegative prompt: lowres, bad hands, extra ears');
  });

  test('처음 기본값: 네거티브는 기타 세트를 뺀 기본 세트', () {
    expect(initialDefaultNegative, containsAll(['lowres', 'bad hands', 'deformed eyes', 'watermark']));
    expect(initialDefaultNegative, isNot(contains('blurry')));
  });
}
