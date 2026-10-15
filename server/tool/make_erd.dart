// ERD 그림 만들기 — 마이그레이션을 전부 실행한 DB를 읽어서 docs/erd.html 을 새로 쓴다.
// 실행: server 폴더에서 `dart run tool/make_erd.dart`  (DB 구조를 바꿀 때마다 다시 실행)
import 'dart:io';

import 'package:server/core/db.dart';
import 'package:server/core/migrations.dart';

/// 묶음 이름, 색, 테이블들. 새 테이블을 만들면 여기에도 넣는다 (빠지면 실행할 때 알려 줌).
const _groups = [
  ('계정 · 설정', '#6b7280', ['users', 'sessions', 'settings']),
  ('파일 · 태그', '#0f8b8d', ['assets', 'tags']),
  ('세계관 · 프로젝트', '#d9822b', ['worlds', 'projects', 'project_characters']),
  ('캐릭터', '#3f5bd8', ['characters', 'character_templates', 'character_fields', 'character_traits', 'character_quotes', 'character_relations', 'character_assets', 'character_tags']),
  ('문서 · 메모 · 연표 · 기록', '#2f9e6b', ['docs', 'memos', 'memo_tags', 'timeline_events', 'timeline_event_characters', 'revisions']),
  ('챗봇 (chatbot_)', '#d6487a', ['chatbot_versions', 'chatbot_greetings', 'chatbot_lore_entries', 'chatbot_test_messages']),
  ('이미지 생성 (gen_)', '#7c5cd6', ['gen_presets', 'gen_preset_loras', 'gen_records', 'gen_record_loras', 'gen_platforms', 'gen_models', 'gen_loras', 'gen_tag_rules']),
  ('게임 (game_) · 보드 (board_)', '#b5651d', ['game_stats', 'game_stat_values', 'game_skills', 'game_quests', 'board_columns', 'board_cards', 'board_card_tags']),
];

String _esc(String s) => s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

void main() {
  final migrations = loadMigrations('migrations');
  final db = Db.memory();
  runMigrations(db, migrations);

  // CREATE TABLE 바로 위 주석의 마지막 줄 = 테이블 설명
  final allSql = migrations.map((m) => m.sql).join('\n');
  final desc = <String, String>{
    for (final m in RegExp(r'((?:--[^\n]*\n)+)CREATE TABLE (\w+)').allMatches(allSql))
      m.group(2)!: m.group(1)!.trim().split('\n').last.replaceFirst(RegExp(r'^-+\s*'), ''),
  };

  final colorOf = {for (final g in _groups) for (final t in g.$3) t: g.$2};
  final tables = db.rows("SELECT name FROM sqlite_master WHERE type = 'table'").map((r) => r['name'] as String).toSet();
  final missing = tables.difference(colorOf.keys.toSet()), extra = colorOf.keys.toSet().difference(tables);
  if (missing.isNotEmpty || extra.isNotEmpty) {
    stderr.writeln('tool/make_erd.dart 의 묶음 목록을 고쳐 주세요. 빠진 테이블: $missing, 없는 테이블: $extra');
    exit(1);
  }

  String card(String t) {
    final fks = {for (final r in db.rows('PRAGMA foreign_key_list($t)')) r['from'] as String: r['table'] as String};
    final cols = db.rows('PRAGMA table_info($t)');
    final rows = StringBuffer();
    for (final c in cols) {
      final n = c['name'] as String;
      if (n.endsWith('_at') && ['created_at', 'updated_at', 'deleted_at'].contains(n)) continue;
      final mark = c['pk'] == 1 ? '<b class="pk">PK</b>' : fks.containsKey(n) ? '<b class="fk">FK</b>' : '';
      final ref = fks.containsKey(n) ? '<span class="ref" style="color:${colorOf[fks[n]]}">→ ${fks[n]}</span>' : '';
      rows.write('<tr><td>$mark</td><td class="n${c['notnull'] == 1 ? ' nn' : ''}">$n</td><td class="t">${(c['type'] as String).toLowerCase()}</td><td>$ref</td></tr>');
    }
    final names = cols.map((c) => c['name']).toSet();
    final ts = ['created', 'updated', 'deleted'].where((x) => names.contains('${x}_at')).join(' ');
    return '<div class="tb" style="--c:${colorOf[t]}"><h4>$t</h4><p>${_esc(desc[t] ?? '')}</p><table>$rows</table>'
        '${ts.isEmpty ? '' : '<div class="ts">+ $ts</div>'}</div>';
  }

  final body = _groups.map((g) => '<section><h3 style="--c:${g.$2}"><i></i>${g.$1} <small>${g.$3.length}</small></h3>'
      '<div class="cards">${g.$3.map(card).join()}</div></section>').join();

  File('../docs/erd.html').writeAsStringSync('''<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>LoreShelf ERD</title><style>
body{margin:0;padding:28px 32px;background:#f4f5f7;font-family:'Malgun Gothic',sans-serif;color:#1c2028}
h1{margin:0 0 4px;font-size:24px} .sub{color:#6b7280;font-size:13px;margin-bottom:18px}
section{margin-top:18px} h3{font-size:15px;margin:0 0 10px;display:flex;align-items:center;gap:8px} h3 i{width:12px;height:12px;border-radius:3px;background:var(--c)} h3 small{color:#9aa1ad;font-weight:400}
.cards{display:flex;flex-wrap:wrap;gap:12px;align-items:flex-start}
.tb{background:#fff;border:1px solid #e2e5ea;border-top:4px solid var(--c);border-radius:10px;padding:10px 12px;width:330px}
.tb h4{margin:0;font-size:14px;font-family:Consolas,monospace;color:var(--c)} .tb p{margin:2px 0 6px;font-size:11px;color:#6b7280}
table{border-collapse:collapse;width:100%;font-size:11.5px} td{padding:2px 4px 2px 0;border-top:1px solid #f0f2f5;white-space:nowrap}
td.n{font-family:Consolas,monospace} td.nn{font-weight:700} td.t{color:#9aa1ad;font-size:10.5px} .ref{font-size:10.5px;font-family:Consolas,monospace}
b.pk,b.fk{font-size:9px;padding:0 4px;border-radius:4px;color:#fff} b.pk{background:#1c2028} b.fk{background:#9aa1ad}
.ts{font-size:10.5px;color:#9aa1ad;margin-top:4px;font-family:Consolas,monospace}
</style></head><body><h1>LoreShelf ERD</h1>
<div class="sub">server/migrations 에서 자동 생성 (DB 버전 ${migrations.length}) · 테이블 ${tables.length}개 · 굵은 칸 = NOT NULL · → 참조하는 테이블 · PK 기본키 · FK 참조</div>
$body</body></html>''');
  print('docs/erd.html 을 새로 썼어요 (테이블 ${tables.length}개)');
}
