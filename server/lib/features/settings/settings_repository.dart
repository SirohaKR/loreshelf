// 사용자 설정 DB (settings).
import '../../core/db.dart';

class SettingsRepository {
  final Db db;
  SettingsRepository(this.db);

  Map<String, Object?> all(int userId) {
    final rows = db.rows('SELECT name, value FROM settings WHERE user_id = ?', [userId]);
    return {for (final r in rows) r['name'] as String: r['value']};
  }

  /// 설정 하나 (없으면 null)
  String? one(int userId, String name) =>
      db.scalar('SELECT value FROM settings WHERE user_id = ? AND name = ?', [userId, name]) as String?;

  void put(int userId, String name, String? value) => db.exec('''
      INSERT INTO settings (user_id, name, value) VALUES (?, ?, ?)
      ON CONFLICT (user_id, name) DO UPDATE SET value = excluded.value, updated_at = ?''', [userId, name, value, nowAt()]);
}
