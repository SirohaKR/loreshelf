// 리포지토리 인터페이스: 캐릭터의 고정 프롬프트·생성 기록 + 만들기·고치기에 필요한 것들
import 'dart:typed_data';

import 'gen.dart';
import 'gen_draft.dart';

abstract interface class GenRepository {
  Future<List<GenPreset>> fetchPresets(int characterId);

  /// ★대표가 먼저, 그다음 최근 것부터
  Future<List<GenRecord>> fetchRecords(int characterId);

  /// 고정 프롬프트 사전에 등록된 LoRA — 고정 프롬프트는 이 중에서만 고를 수 있다
  Future<List<GenLora>> fetchLoras();

  /// 내가 가르친 태그 → 카테고리 (붙여넣은 프롬프트를 분류할 때 기본 규칙보다 먼저 봄)
  Future<Map<String, String>> fetchLearnedDictionary();

  /// 모든 캐릭터 공통 기본값 (품질·네거티브)
  Future<GenDefaults> fetchDefaults();

  /// 보낸 쪽만 바꾼다
  Future<GenDefaults> saveDefaults({List<String>? quality, List<String>? negative});

  /// 네거티브 세트: 기본 세트 + 내가 만든 세트
  Future<List<GenNegativeSet>> fetchNegativeSets();

  /// [id]가 null이면 새로 만들고, 있으면 고친다
  Future<GenPreset> savePreset(int characterId, int? id, GenPresetDraft draft);

  Future<void> deletePreset(int id);

  /// [id]가 null이면 새로 만들고, 있으면 고친다
  Future<GenRecord> saveRecord(int characterId, int? id, GenRecordDraft draft);

  Future<void> deleteRecord(int id);

  /// ★대표로 (다른 기록의 대표는 서버가 자동으로 풀어 준다)
  Future<GenRecord> setCover(int id);

  /// 이미지 파일을 올리고 번호(asset id)를 돌려준다 — PNG 가져오기·수동 기록 둘 다 씀
  Future<int> uploadImage(Uint8List bytes, String fileName);
}
