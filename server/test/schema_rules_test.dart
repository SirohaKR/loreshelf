// DB 이름 규칙 검사 — docs/DB-설계.md 의 규칙을 사람이 기억하지 않아도 되게 테스트로.
// 마이그레이션을 전부 실행한 DB를 보고 검사한다. 예외는 아래 목록과 문서의 "예외 목록"에만.
import 'package:server/core/db.dart';
import 'package:server/core/migrations.dart';
import 'package:test/test.dart';

/// 문서 "예외 목록"에 적힌 것만.
const _idButNotForeignKey = {'revisions.target_id', 'gen_loras.civitai_version_id'};
final _snake = RegExp(r'^[a-z][a-z0-9]*(_[a-z0-9]+)*$');
final _abbreviation = RegExp(r'(^|_)(char|desc|cnt|num|img|pic|msg|qty|amt|addr|tmp|info|dt|ts|no|flg|yn)(_|$)');
const _forbiddenNames = {'type', 'sort', 'order', 'desc', 'image', 'date'};

String _singular(String t) => t.endsWith('ies') ? '${t.substring(0, t.length - 3)}y' : t.substring(0, t.length - 1);

void main() {
  late Db db;
  late List<String> tables;

  setUpAll(() {
    db = Db.memory();
    runMigrations(db, loadMigrations('migrations'));
    tables = db.rows("SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name").map((r) => r['name'] as String).toList();
  });

  test('마이그레이션 번호가 DB 버전과 같다', () {
    expect(db.scalar('PRAGMA user_version'), loadMigrations('migrations').length);
  });

  test('테이블 이름: snake_case, 복수형, 줄임말 없음', () {
    for (final t in tables) {
      expect(_snake.hasMatch(t), isTrue, reason: '$t: snake_case 아님');
      expect(t.endsWith('s'), isTrue, reason: '$t: 복수형 아님');
      expect(_abbreviation.hasMatch(t), isFalse, reason: '$t: 줄임말');
    }
  });

  test('칸 이름·자료형 규칙', () {
    final problems = <String>[];
    for (final t in tables) {
      final cols = db.rows('PRAGMA table_info($t)');
      final ddl = db.scalar('SELECT sql FROM sqlite_master WHERE name = ?', [t]) as String;
      final fks = {for (final r in db.rows('PRAGMA foreign_key_list($t)')) r['from'] as String: r['table'] as String};
      final names = cols.map((c) => c['name'] as String).toList();

      if (names.first != 'id' || cols.first['type'] != 'INTEGER' || cols.first['pk'] != 1) problems.add('$t: 첫 칸이 id INTEGER PK 아님');
      if (names.contains('updated_at') && !names.contains('created_at')) problems.add('$t: updated_at만 있음');

      for (final c in cols) {
        final n = c['name'] as String, type = c['type'] as String, w = '$t.$n';
        if (!_snake.hasMatch(n)) problems.add('$w: snake_case 아님');
        if (_abbreviation.hasMatch(n)) problems.add('$w: 줄임말');
        if (_forbiddenNames.contains(n)) problems.add('$w: 쓰지 않기로 한 이름');
        if (n.endsWith('_id') && !_idButNotForeignKey.contains(w)) {
          if (!fks.containsKey(n)) {
            problems.add('$w: _id인데 참조 없음');
          } else if (!n.endsWith('${_singular(fks[n]!)}_id')) {
            problems.add('$w: 참조 테이블 ${fks[n]} 와 이름이 안 맞음');
          }
        }
        if (fks.containsKey(n) && !n.endsWith('_id')) problems.add('$w: 참조인데 _id로 안 끝남');
        if (n.startsWith('is_') && (type != 'INTEGER' || c['notnull'] != 1 || !ddl.contains('$n IN (0, 1)'))) problems.add('$w: is_ 규칙 위반');
        if (n.endsWith('_at') && type != 'TEXT') problems.add('$w: _at은 TEXT');
        if (n.endsWith('_json') && !ddl.contains('json_valid($n)')) problems.add('$w: json_valid 검사 없음');
      }
    }
    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('인덱스 이름: idx_/uq_ + 테이블 이름', () {
    final rows = db.rows("SELECT name, tbl_name FROM sqlite_master WHERE type = 'index' AND sql IS NOT NULL");
    for (final r in rows) {
      expect(RegExp('^(idx|uq)_${r['tbl_name']}_').hasMatch(r['name'] as String), isTrue, reason: '${r['name']}');
    }
  });
}
