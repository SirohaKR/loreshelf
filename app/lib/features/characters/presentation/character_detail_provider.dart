// 캐릭터 상세 — family: characterDetailProvider(id)
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/characters_repository_impl.dart';
import '../domain/character.dart';

part 'character_detail_provider.g.dart';

@riverpod
Future<CharacterDetail> characterDetail(Ref ref, int id) => ref.watch(charactersRepositoryProvider).fetchDetail(id);
