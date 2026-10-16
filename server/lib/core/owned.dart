// "이 번호가 내 것인가" 확인 — 화면에서 온 world_id, project_id 등을 저장하기 전에 쓴다.
import 'db.dart';
import 'http.dart';

/// user_id·deleted_at 칸이 있는 맨 위 단위 테이블만 (주소·요청 값으로 테이블 이름을 받지 않는다).
const _ownedTables = {'worlds', 'projects', 'characters', 'assets', 'chatbot_stories', 'chatbot_status_views'};

/// id가 비었으면 null, 내 것이 아니거나 휴지통에 있으면 오류, 내 것이면 그 id.
int? ownedIdOrNull(Db db, String table, int userId, Object? id, String label) {
  assert(_ownedTables.contains(table));
  final n = toIntOrNull(id);
  if (n == null) return null;
  final found = db.scalar('SELECT 1 FROM $table WHERE id = ? AND user_id = ? AND deleted_at IS NULL', [n, userId]);
  if (found == null) throw ApiError('$label을(를) 찾을 수 없어요', 404);
  return n;
}

/// 꼭 내 것이어야 하는 id.
int ownedId(Db db, String table, int userId, Object? id, String label) =>
    ownedIdOrNull(db, table, userId, id, label) ?? (throw ApiError('$label을(를) 찾을 수 없어요', 404));
