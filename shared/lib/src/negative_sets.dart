// 기본 네거티브 세트 — AI 없이 눌러서 넣는 묶음. 사용자가 만든 세트는 DB gen_negative_sets에 따로.

class NegativeSet {
  final String key;
  final String name;
  final List<String> tags;
  const NegativeSet(this.key, this.name, this.tags);

  Map<String, Object?> toJson() => {'key': key, 'name': name, 'negative': tags, 'builtin': true};
}

const defaultNegativeSets = [
  NegativeSet('quality', '품질', ['lowres', 'worst quality', 'low quality', 'normal quality', 'jpeg artifacts', 'bad quality', 'displeasing', 'very displeasing']),
  NegativeSet('anatomy', '손·해부학', ['bad hands', 'extra fingers', 'missing fingers', 'fewer digits', 'extra digits', 'fused fingers', 'bad anatomy', 'extra arms', 'extra legs', 'malformed limbs', 'bad proportions']),
  NegativeSet('text', '글자·워터마크', ['text', 'watermark', 'signature', 'logo', 'username', 'artist name', 'copyright', 'speech bubble']),
  NegativeSet('face', '얼굴', ['bad face', 'deformed face', 'deformed eyes', 'asymmetrical eyes', 'cross-eyed', 'ugly', 'disfigured']),
  NegativeSet('etc', '기타', ['blurry', 'cropped', 'out of frame', 'duplicate', 'error', 'mutation', 'multiple views']),
];

/// 네거티브 목록에 세트를 더한다 — 이미 있는 태그(대소문자·밑줄 무시)는 건너뛰고 순서는 유지
List<String> addNegativeTags(List<String> current, Iterable<String> add) {
  String norm(String s) => s.toLowerCase().replaceAll('_', ' ').trim();
  final seen = {for (final t in current) norm(t)};
  return [
    ...current,
    for (final t in add)
      if (t.trim().isNotEmpty && seen.add(norm(t))) t.trim(),
  ];
}
