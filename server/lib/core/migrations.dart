// DB 마이그레이션 — migrations/ 폴더의 0001_….sql, 0002_….sql 을 번호 순서대로 한 번씩만 실행한다.
// 어디까지 했는지는 DB 안의 PRAGMA user_version 에 번호로 남는다.
// 규칙: 이미 적용된 파일은 절대 고치지 않는다. 바꿀 게 생기면 다음 번호 파일을 새로 만든다.
import 'dart:io';

import 'package:path/path.dart' as p;

import 'db.dart';

class Migration {
  final int number;
  final String name;
  final String sql;
  Migration(this.number, this.name, this.sql);
}

final _fileName = RegExp(r'^(\d{4})_([a-z0-9_]+)\.sql$');

/// 폴더에서 마이그레이션 파일 읽기 (이름 형식이 틀리거나 번호가 겹치면 바로 알려 준다).
List<Migration> loadMigrations(String dir) {
  final list = <Migration>[];
  for (final f in Directory(dir).listSync().whereType<File>()) {
    final name = p.basename(f.path);
    if (!name.endsWith('.sql')) continue;
    final m = _fileName.firstMatch(name) ?? (throw StateError('마이그레이션 파일 이름은 0001_무엇을_했는지.sql 형식이어야 해요: $name'));
    list.add(Migration(int.parse(m.group(1)!), name, f.readAsStringSync()));
  }
  list.sort((a, b) => a.number.compareTo(b.number));
  for (var i = 0; i < list.length; i++) {
    if (list[i].number != i + 1) throw StateError('마이그레이션 번호가 비거나 겹쳐요: ${list[i].name} (기대한 번호 ${i + 1})');
  }
  return list;
}

/// 아직 안 한 마이그레이션 실행. 실행한 파일 이름들을 돌려준다.
List<String> runMigrations(Db db, List<Migration> migrations) {
  final current = db.scalar('PRAGMA user_version') as int;
  if (current > migrations.length) {
    throw StateError('DB가 이 서버보다 새 버전이에요 (DB $current, 서버 ${migrations.length}). 서버를 업데이트해 주세요');
  }
  final done = <String>[];
  for (final m in migrations.where((m) => m.number > current)) {
    db.tx(() {
      db.raw.execute(m.sql);
      db.raw.execute('PRAGMA user_version = ${m.number}');
    });
    done.add(m.name);
  }
  return done;
}
