// 엔티티: 휴지통 한 줄 — 캐릭터·세계관·프로젝트가 모양이 거의 같아서 하나로 쓴다.
// projectName은 캐릭터 줄에서만, ownCharacterCount는 프로젝트 줄에서만 온다.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trash_entry.freezed.dart';
part 'trash_entry.g.dart';

@freezed
abstract class TrashEntry with _$TrashEntry {
  const factory TrashEntry({
    required int id,
    required String name,
    required String deletedAt,
    String? projectName,
    @Default(0) int ownCharacterCount,
  }) = _TrashEntry;

  factory TrashEntry.fromJson(Map<String, Object?> json) => _$TrashEntryFromJson(json);
}

/// 서버 주소의 종류 이름. purge·restore에 그대로 쓴다
enum TrashKind { characters, worlds, projects }

extension TrashKindX on TrashKind {
  String get path => name;
  String get label => switch (this) { TrashKind.characters => '캐릭터', TrashKind.worlds => '세계관', TrashKind.projects => '프로젝트' };
}

/// GET /api/trash 전체
@freezed
abstract class TrashLists with _$TrashLists {
  const factory TrashLists({
    @Default([]) List<TrashEntry> characters,
    @Default([]) List<TrashEntry> worlds,
    @Default([]) List<TrashEntry> projects,
  }) = _TrashLists;

  const TrashLists._();

  List<TrashEntry> of(TrashKind kind) => switch (kind) {
        TrashKind.characters => characters,
        TrashKind.worlds => worlds,
        TrashKind.projects => projects,
      };

  int get total => characters.length + worlds.length + projects.length;
}
