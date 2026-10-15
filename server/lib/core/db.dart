// DB 연결 — SQLite 파일 하나 (data/loreshelf.db). 테이블 구조는 migrations/*.sql 이 만든다.
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

typedef Row = Map<String, Object?>;

class Db {
  final Database raw;

  Db._(this.raw) {
    raw.execute('PRAGMA foreign_keys = ON');
    raw.execute('PRAGMA busy_timeout = 5000');
  }

  factory Db.open(String path) {
    Directory(p.dirname(path)).createSync(recursive: true);
    final db = Db._(sqlite3.open(path));
    db.raw.execute('PRAGMA journal_mode = WAL');
    return db;
  }

  factory Db.memory() => Db._(sqlite3.openInMemory());

  /// 여러 줄 조회.
  List<Row> rows(String sql, [List<Object?> args = const []]) =>
      raw.select(sql, args).map((r) => Map<String, Object?>.from(r)).toList();

  /// 한 줄 조회 (없으면 null).
  Row? one(String sql, [List<Object?> args = const []]) {
    final rs = raw.select(sql, args);
    return rs.isEmpty ? null : Map<String, Object?>.from(rs.first);
  }

  /// 값 하나 조회 (첫 줄 첫 칸).
  Object? scalar(String sql, [List<Object?> args = const []]) {
    final rs = raw.select(sql, args);
    return rs.isEmpty ? null : rs.first.values.first;
  }

  /// INSERT/UPDATE/DELETE — 바뀐 줄 수를 돌려준다.
  int exec(String sql, [List<Object?> args = const []]) {
    raw.execute(sql, args);
    return raw.updatedRows;
  }

  /// INSERT 후 새 id.
  int insert(String sql, [List<Object?> args = const []]) {
    raw.execute(sql, args);
    return raw.lastInsertRowId;
  }

  /// 여러 문장을 한 번에 (실패하면 전부 취소). 안에서 또 부르면 바깥 하나로 묶인다.
  T tx<T>(T Function() fn) {
    if (!raw.autocommit) return fn();
    raw.execute('BEGIN');
    try {
      final r = fn();
      raw.execute('COMMIT');
      return r;
    } catch (_) {
      raw.execute('ROLLBACK');
      rethrow;
    }
  }

  void close() => raw.close();
}

/// 지금 시각 — DB의 _at 칸 형식 ('2026-10-15T09:30:00Z', UTC).
String nowAt() => '${DateTime.now().toUtc().toIso8601String().substring(0, 19)}Z';
