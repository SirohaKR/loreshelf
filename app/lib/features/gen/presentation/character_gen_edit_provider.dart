// 이미지·프롬프트 고치기 쪽 provider 넷:
//   genLoraListProvider · genLearnedDictionaryProvider — 편집 폼이 쓰는 참고 자료(LoRA 사전·내 분류 사전)
//   genPresetSaverProvider · genRecordSaverProvider — AsyncNotifier로 저장 중/실패/성공을 들고 있다 (character_edit_provider.dart와 같은 짜임)
//   genActionsProvider — 지우기·★대표로·이미지 올리기처럼 "누르면 바로" 하는 일들
// 무엇이든 바뀌면 characterGenProvider를 다시 받게 한다.
import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart' show FutureProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/gen_repository_impl.dart';
import '../domain/gen.dart';
import '../domain/gen_draft.dart';
import '../domain/gen_repository.dart';
import 'character_gen_provider.dart';

part 'character_gen_edit_provider.g.dart';

/// 고정 프롬프트는 이 중에서만 LoRA를 고를 수 있다 (서버가 모르는 이름은 저장 때 빠짐)
@riverpod
Future<List<GenLora>> genLoraList(Ref ref) => ref.watch(genRepositoryProvider).fetchLoras();

/// 내가 가르친 태그 → 카테고리 (붙여넣기 분류 때 기본 규칙보다 먼저 봄)
@riverpod
Future<Map<String, String>> genLearnedDictionary(Ref ref) => ref.watch(genRepositoryProvider).fetchLearnedDictionary();

// 아래 둘은 코드 생성 없이 직접 쓴 provider (2026-10-16, 이 PC에서 build_runner가 중간에 멈춰서). 하는 일은 @riverpod와 같다.

/// 모든 캐릭터 공통 기본값 — 붙여 넣을 때 겹치는 건 빼고, 복사할 때 합친다
final genDefaultsProvider = FutureProvider<GenDefaults>((ref) => ref.watch(genRepositoryProvider).fetchDefaults());

/// 공통 기본값 칸에서 눌러 넣는 네거티브 세트 (기본 + 내가 만든 것)
final genNegativeSetsProvider = FutureProvider<List<GenNegativeSet>>((ref) => ref.watch(genRepositoryProvider).fetchNegativeSets());

@riverpod
class GenPresetSaver extends _$GenPresetSaver {
  @override
  FutureOr<GenPreset?> build() => null;

  Future<GenPreset?> save(int characterId, int? id, GenPresetDraft draft) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => ref.read(genRepositoryProvider).savePreset(characterId, id, draft));
    if (!ref.mounted) return null;
    state = result;
    if (result.value != null) ref.invalidate(characterGenProvider(characterId));
    return result.value;
  }
}

@riverpod
class GenRecordSaver extends _$GenRecordSaver {
  @override
  FutureOr<GenRecord?> build() => null;

  Future<GenRecord?> save(int characterId, int? id, GenRecordDraft draft) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => ref.read(genRepositoryProvider).saveRecord(characterId, id, draft));
    if (!ref.mounted) return null;
    state = result;
    if (result.value != null) ref.invalidate(characterGenProvider(characterId));
    return result.value;
  }
}

@Riverpod(keepAlive: true)
GenActions genActions(Ref ref) => GenActions(ref);

class GenActions {
  GenActions(this._ref);
  final Ref _ref;

  GenRepository get _repo => _ref.read(genRepositoryProvider);

  Future<T> _run<T>(int characterId, Future<T> Function() work) async {
    final result = await work();
    _ref.invalidate(characterGenProvider(characterId));
    return result;
  }

  /// 파일을 올리기만 하고 번호를 돌려준다 (PNG 가져오기·대표 이미지 고르기)
  Future<int> upload(Uint8List bytes, String fileName) => _repo.uploadImage(bytes, fileName);

  Future<void> deletePreset(int characterId, int id) => _run(characterId, () => _repo.deletePreset(id));

  Future<void> deleteRecord(int characterId, int id) => _run(characterId, () => _repo.deleteRecord(id));

  Future<GenRecord> setCover(int characterId, int id) => _run(characterId, () => _repo.setCover(id));

  Future<GenDefaults> saveDefaults({List<String>? quality, List<String>? negative}) async {
    final out = await _repo.saveDefaults(quality: quality, negative: negative);
    _ref.invalidate(genDefaultsProvider);
    return out;
  }

  /// 칩 ✕처럼 누르면 바로 저장하는 고치기
  Future<GenPreset> savePreset(int characterId, int? id, GenPresetDraft draft) => _run(characterId, () => _repo.savePreset(characterId, id, draft));

  Future<GenRecord> saveRecord(int characterId, int id, GenRecordDraft draft) => _run(characterId, () => _repo.saveRecord(characterId, id, draft));
}
