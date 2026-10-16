import 'package:loreshelf_shared/loreshelf_shared.dart';
import 'package:test/test.dart';

List<String> names(Map<String, List<PromptTag>> m, String k) => [for (final t in m[k] ?? const <PromptTag>[]) t.tag];

void main() {
  final p = parsePrompt('masterpiece, 1boy, black hair, shy, black vest, bouquet, smile, portrait, white background');

  test('기본: 인물·성격·의상·화풍·품질은 고정, 나머지는 이번만', () {
    final s = splitPromptTags(p.categories);
    expect(s.fixed.keys.toSet(), {'quality', 'character', 'personality', 'outfit'});
    expect(s.scene.keys.toSet(), {'props', 'expression', 'pose', 'background'});
  });

  test('칸마다 바꿀 수 있다', () {
    final s = splitPromptTags(p.categories, targets: {'outfit': 'scene', 'pose': 'fixed'});
    expect(s.fixed.containsKey('outfit'), isFalse);
    expect(names(s.fixed, 'pose'), ['portrait']);
  });

  test('이미 고정에 있는 태그는 다시 넣지 않는다 (대소문자·밑줄·칸 무시)', () {
    final base = {
      'character': [const PromptTag('Black_Hair', 1)],
      'etc': [const PromptTag('1boy', 1)],
    };
    final add = splitPromptTags(p.categories).fixed;
    expect(names(newPromptTags(base, add), 'character'), isEmpty);
    final merged = mergePromptTags(base, add);
    expect(names(merged, 'character'), ['Black_Hair']);
    expect(names(merged, 'personality'), ['shy']);
    expect(merged.keys.toList(), ['character', 'personality', 'outfit', 'quality', 'etc']);
  });

  test('네거티브 세트: 기본 5개, 겹치는 태그는 한 번만', () {
    expect(defaultNegativeSets.map((s) => s.name), ['품질', '손·해부학', '글자·워터마크', '얼굴', '기타']);
    expect(addNegativeTags(['LowRes', 'text'], ['lowres', 'worst quality', 'text', ' ']), ['LowRes', 'text', 'worst quality']);
  });
}
