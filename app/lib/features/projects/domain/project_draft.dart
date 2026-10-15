// 엔티티: 프로젝트 편집 중인 값 — 웹 projects.js renderEdit의 payload와 같은 모양 (POST/PUT /api/projects)
import 'package:freezed_annotation/freezed_annotation.dart';

import 'genre.dart';
import 'project.dart';

part 'project_draft.freezed.dart';

@freezed
abstract class ProjectDraft with _$ProjectDraft {
  const ProjectDraft._();

  const factory ProjectDraft({
    @Default('') String name,
    @Default('game') String kind,
    @Default('private') String visibility,
    @Default('') String summary,
    @Default(0) int progressPercent,
    @Default('') String bodyMd,
    int? coverAssetId,
    int? worldId,
    @Default(0) int sortOrder,
    @Default([]) List<Genre> genres,
  }) = _ProjectDraft;

  factory ProjectDraft.fromDetail(ProjectDetail p) => ProjectDraft(
        name: p.name,
        kind: p.kind,
        visibility: p.visibility,
        summary: p.summary ?? '',
        progressPercent: p.progressPercent,
        bodyMd: p.bodyMd ?? '',
        coverAssetId: p.coverAssetId,
        worldId: p.worldId,
        sortOrder: p.sortOrder,
        genres: p.genres,
      );

  String? get problem => name.trim().isEmpty ? '이름을 입력해 주세요' : null;

  Map<String, Object?> toPayload() => {
        'name': name.trim(),
        'kind': kind,
        'world_id': worldId,
        'genre_ids': [for (final g in genres) g.id],
        'visibility': visibility,
        'summary': summary,
        'progress_percent': progressPercent,
        'body_md': bodyMd,
        'cover_asset_id': coverAssetId,
        'sort_order': sortOrder,
      };
}
