// 리포지토리 인터페이스: 캐릭터의 고정 프롬프트·생성 기록 (보기 전용)
import 'gen.dart';

abstract interface class GenRepository {
  Future<List<GenPreset>> fetchPresets(int characterId);

  /// ★대표가 먼저, 그다음 최근 것부터
  Future<List<GenRecord>> fetchRecords(int characterId);
}
