// 계정·세션 DB (users, sessions).
import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../core/db.dart';
import '../../core/passwords.dart';

const sessionDays = 30;

String _hashToken(String token) => sha256.convert(utf8.encode(token)).toString();

class AuthRepository {
  final Db db;
  AuthRepository(this.db);

  int countUsers() => db.scalar('SELECT COUNT(*) FROM users') as int;

  Row? findByLogin(String loginName) => db.one('SELECT * FROM users WHERE login_name = ?', [loginName]);

  Row? findUser(int id) => db.one('SELECT * FROM users WHERE id = ?', [id]);

  /// 화면에 보낼 내 정보 (비밀번호 해시는 빼고).
  Map<String, Object?> me(int id) {
    final u = findUser(id)!;
    return {'id': u['id'], 'login_name': u['login_name'], 'display_name': u['display_name']};
  }

  int createUser(String loginName, String passwordHash, String displayName) => db.insert(
      'INSERT INTO users (login_name, password_hash, display_name) VALUES (?, ?, ?)', [loginName, passwordHash, displayName]);

  void setPassword(int id, String passwordHash) =>
      db.exec('UPDATE users SET password_hash = ?, updated_at = ? WHERE id = ?', [passwordHash, nowAt(), id]);

  void setDisplayName(int id, String name) =>
      db.exec('UPDATE users SET display_name = ?, updated_at = ? WHERE id = ?', [name, nowAt(), id]);

  /// 새 세션 → 쿠키에 넣을 토큰 (DB에는 해시만 저장).
  String createSession(int userId) {
    final token = randomToken(32);
    final expires = DateTime.now().toUtc().add(const Duration(days: sessionDays));
    db.exec('DELETE FROM sessions WHERE expires_at < ?', [nowAt()]); // 지난 세션 정리
    db.insert('INSERT INTO sessions (user_id, token_hash, expires_at) VALUES (?, ?, ?)',
        [userId, _hashToken(token), '${expires.toIso8601String().substring(0, 19)}Z']);
    return token;
  }

  int? userForToken(String token) =>
      db.scalar('SELECT user_id FROM sessions WHERE token_hash = ? AND expires_at > ?', [_hashToken(token), nowAt()]) as int?;

  void deleteSession(String token) => db.exec('DELETE FROM sessions WHERE token_hash = ?', [_hashToken(token)]);

  void deleteOtherSessions(int userId, String keepToken) =>
      db.exec('DELETE FROM sessions WHERE user_id = ? AND token_hash <> ?', [userId, _hashToken(keepToken)]);
}
