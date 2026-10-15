// 엔티티: 캐릭터 편집 중인 값 (만들기·고치기 화면의 폼 상태)
// 화면은 이 값 하나를 useState로 들고 있다가, 저장할 때 toPayload()로 서버 JSON을 만든다.
// 웹 character_edit.js의 payload와 같은 모양 — POST/PUT /api/characters
import 'package:freezed_annotation/freezed_annotation.dart';

import 'character.dart';

part 'character_draft.freezed.dart';

/// 새 캐릭터를 만들 때 미리 넣어 두는 기본 정보 칸 (웹과 같음)
const defaultFieldLabels = ['나이', '생일', '키', '소속'];

/// 테마색 고르기에 보이는 색들
const themeColorChoices = ['#C9573F', '#D98E32', '#B89A2E', '#5E9E6E', '#3E8FA8', '#4D6FC9', '#8A5CC2', '#C2588F', '#6E6A64'];

var _rowSeq = 0;

/// 줄마다 붙이는 화면용 번호 — 줄을 지워도 다른 줄의 입력칸이 섞이지 않게 위젯 key로 쓴다
int nextRowKey() => ++_rowSeq;

@freezed
abstract class FieldDraft with _$FieldDraft {
  const factory FieldDraft({required int key, @Default('') String label, @Default('') String value, @Default(false) bool isSecret}) =
      _FieldDraft;
}

/// 오른쪽(rightLabel)을 비우면 한쪽짜리 성격 (강도 %)
@freezed
abstract class TraitDraft with _$TraitDraft {
  const factory TraitDraft({required int key, @Default('') String leftLabel, @Default('') String rightLabel, @Default(50) int valuePercent}) =
      _TraitDraft;
}

@freezed
abstract class QuoteDraft with _$QuoteDraft {
  const factory QuoteDraft({required int key, @Default('') String body, @Default('') String situation, @Default(false) bool isSecret}) =
      _QuoteDraft;
}

@freezed
abstract class CharacterDraft with _$CharacterDraft {
  const CharacterDraft._();

  const factory CharacterDraft({
    @Default('') String name,
    @Default('') String nameEn,
    @Default('') String tagline,
    @Default('') String quote,
    /// null = 공용 서재
    int? projectId,
    int? worldId,
    @Default('private') String visibility,
    /// null = 색 안 씀
    String? themeColor,
    int? portraitAssetId,
    @Default(false) bool isFavorite,
    @Default(false) bool isCardDownloadable,
    @Default(0) int sortOrder,
    @Default([]) List<FieldDraft> fields,
    @Default([]) List<TraitDraft> traits,
    @Default([]) List<QuoteDraft> quotes,
    @Default([]) List<String> tags,
    @Default('') String bodyMd,
  }) = _CharacterDraft;

  /// 새 캐릭터 — [projectId]가 있으면 그 프로젝트 전용으로
  factory CharacterDraft.empty({int? projectId}) => CharacterDraft(
        projectId: projectId,
        fields: [for (final l in defaultFieldLabels) FieldDraft(key: nextRowKey(), label: l)],
      );

  factory CharacterDraft.fromDetail(CharacterDetail c) => CharacterDraft(
        name: c.name,
        nameEn: c.nameEn ?? '',
        tagline: c.tagline ?? '',
        quote: c.quote ?? '',
        projectId: c.projectId,
        worldId: c.worldId,
        visibility: c.visibility,
        themeColor: c.themeColor,
        portraitAssetId: c.portraitAssetId,
        isFavorite: c.isFavorite,
        isCardDownloadable: c.isCardDownloadable,
        sortOrder: c.sortOrder,
        fields: [for (final f in c.fields) FieldDraft(key: nextRowKey(), label: f.label, value: f.value, isSecret: f.isSecret)],
        traits: [
          for (final t in c.traits)
            TraitDraft(key: nextRowKey(), leftLabel: t.leftLabel, rightLabel: t.rightLabel ?? '', valuePercent: t.valuePercent),
        ],
        quotes: [for (final q in c.quotes) QuoteDraft(key: nextRowKey(), body: q.body, situation: q.situation ?? '', isSecret: q.isSecret)],
        tags: c.tags,
        bodyMd: c.bodyMd ?? '',
      );

  /// 저장 전에 화면에서 먼저 막을 문제 (서버도 다시 검사한다). 없으면 null
  String? get problem => name.trim().isEmpty ? '이름을 입력해 주세요' : null;

  /// '#은발, 복선' 같은 글을 태그로 나눠 더한다 (# 떼기, 중복 빼기, 30개까지)
  CharacterDraft withTagsFrom(String text) {
    final next = [...tags];
    for (final t in text.split(RegExp(r'[,\s]+')).map((s) => s.replaceFirst(RegExp('^#+'), '').trim())) {
      if (t.isNotEmpty && !next.contains(t) && next.length < 30) next.add(t);
    }
    return copyWith(tags: next);
  }

  Map<String, Object?> toPayload() => {
        'name': name.trim(),
        'name_en': nameEn,
        'tagline': tagline,
        'quote': quote,
        'project_id': projectId,
        'world_id': worldId,
        'visibility': visibility,
        'theme_color': themeColor,
        'portrait_asset_id': portraitAssetId,
        'is_favorite': isFavorite,
        'is_card_downloadable': isCardDownloadable,
        'sort_order': sortOrder,
        'fields': [for (final f in fields) {'label': f.label, 'value': f.value, 'is_secret': f.isSecret}],
        'traits': [
          for (final t in traits) {'left_label': t.leftLabel, 'right_label': t.rightLabel, 'value_percent': t.valuePercent},
        ],
        'quotes': [for (final q in quotes) {'body': q.body, 'situation': q.situation, 'is_secret': q.isSecret}],
        'tags': tags,
        'body_md': bodyMd,
      };
}
