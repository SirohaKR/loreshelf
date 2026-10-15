// core/utils 테스트 — 초상화 색 계산, 상대 시각
import 'package:flutter_test/flutter_test.dart';
import 'package:loreshelf_app/core/utils/color_utils.dart';
import 'package:loreshelf_app/core/utils/time_ago.dart';

void main() {
  test('파스텔 색은 이름마다 항상 같고, 테마색은 반투명(0x55)', () {
    expect(pastel('미르'), pastel('미르'));
    expect(themeColorOf('#C9573F')!.toARGB32(), 0x55C9573F);
    expect(themeColorOf('빨강'), isNull);
  });

  test('상대 시각', () {
    final now = DateTime.utc(2026, 10, 15, 12);
    expect(timeAgo('2026-10-15T11:59:30Z', now: now), '방금');
    expect(timeAgo('2026-10-15T09:00:00Z', now: now), '3시간 전');
    expect(timeAgo('2026-10-12T12:00:00Z', now: now), '3일 전');
    expect(timeAgo(null), '');
  });
}
