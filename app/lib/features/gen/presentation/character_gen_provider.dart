// 캐릭터의 이미지·프롬프트 탭 데이터 — family: characterGenProvider(캐릭터 id)
// 고정 프롬프트와 생성 기록을 동시에 불러온다 (Dart 레코드로 묶어서).
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/gen_repository_impl.dart';
import '../domain/gen.dart';

part 'character_gen_provider.g.dart';

typedef CharacterGen = ({List<GenPreset> presets, List<GenRecord> records});

@riverpod
Future<CharacterGen> characterGen(Ref ref, int characterId) async {
  final repo = ref.watch(genRepositoryProvider);
  final (presets, records) = await (repo.fetchPresets(characterId), repo.fetchRecords(characterId)).wait;
  return (presets: presets, records: records);
}
