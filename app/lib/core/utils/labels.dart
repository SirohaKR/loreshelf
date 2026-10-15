// 화면에 보이는 한글 이름표 — 웹 작업실 ui.js / parts.js 의 KIND, GENRE_CATEGORY 등과 같은 값
import '../theme/app_colors.dart';

const kindLabel = {'game': '게임', 'chatbot': '챗봇', 'etc': '기타'};
const kindIcon = {'game': '⚔', 'chatbot': '✉', 'etc': '✦'};
const kindTone = {'game': Tone.warn, 'chatbot': Tone.rose, 'etc': Tone.ok};

/// 장르 태그 분류 (보여 줄 순서대로)
const genreCategoryLabel = {
  'genre': '장르',
  'setting': '배경·무대',
  'mood': '분위기·관계',
  'trope': '소재·설정',
  'game': '게임·형식',
  'custom': '직접 추가',
};

/// 공개 범위 → (글자, 색)
(String, Tone) visibilityBadge(String v) => switch (v) {
      'public' => ('공개', Tone.ok),
      'unlisted' => ('링크 공개', Tone.accent),
      _ => ('🔒 비공개', Tone.plain),
    };
