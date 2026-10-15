/// '3일 전' 같은 상대 시각 (웹 ui.js 의 ago()와 같은 규칙)
String timeAgo(String? at, {DateTime? now}) {
  final t = at == null ? null : DateTime.tryParse(at);
  if (t == null) return '';
  final s = (now ?? DateTime.now()).difference(t).inSeconds;
  if (s < 60) return '방금';
  if (s < 3600) return '${s ~/ 60}분 전';
  if (s < 86400) return '${s ~/ 3600}시간 전';
  if (s < 86400 * 30) return '${s ~/ 86400}일 전';
  final l = t.toLocal();
  return '${l.year}. ${l.month}. ${l.day}.';
}
