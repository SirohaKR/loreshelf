// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_gen_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 고정 프롬프트는 이 중에서만 LoRA를 고를 수 있다 (서버가 모르는 이름은 저장 때 빠짐)

@ProviderFor(genLoraList)
final genLoraListProvider = GenLoraListProvider._();

/// 고정 프롬프트는 이 중에서만 LoRA를 고를 수 있다 (서버가 모르는 이름은 저장 때 빠짐)

final class GenLoraListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GenLora>>,
          List<GenLora>,
          FutureOr<List<GenLora>>
        >
    with $FutureModifier<List<GenLora>>, $FutureProvider<List<GenLora>> {
  /// 고정 프롬프트는 이 중에서만 LoRA를 고를 수 있다 (서버가 모르는 이름은 저장 때 빠짐)
  GenLoraListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genLoraListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genLoraListHash();

  @$internal
  @override
  $FutureProviderElement<List<GenLora>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GenLora>> create(Ref ref) {
    return genLoraList(ref);
  }
}

String _$genLoraListHash() => r'a778349365260fb57da3b6687ca2863fc71560b8';

/// 내가 가르친 태그 → 카테고리 (붙여넣기 분류 때 기본 규칙보다 먼저 봄)

@ProviderFor(genLearnedDictionary)
final genLearnedDictionaryProvider = GenLearnedDictionaryProvider._();

/// 내가 가르친 태그 → 카테고리 (붙여넣기 분류 때 기본 규칙보다 먼저 봄)

final class GenLearnedDictionaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, String>>,
          Map<String, String>,
          FutureOr<Map<String, String>>
        >
    with
        $FutureModifier<Map<String, String>>,
        $FutureProvider<Map<String, String>> {
  /// 내가 가르친 태그 → 카테고리 (붙여넣기 분류 때 기본 규칙보다 먼저 봄)
  GenLearnedDictionaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genLearnedDictionaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genLearnedDictionaryHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, String>> create(Ref ref) {
    return genLearnedDictionary(ref);
  }
}

String _$genLearnedDictionaryHash() =>
    r'439828ff7ef585dd41f10766348eda9ff14b16db';

@ProviderFor(GenPresetSaver)
final genPresetSaverProvider = GenPresetSaverProvider._();

final class GenPresetSaverProvider
    extends $AsyncNotifierProvider<GenPresetSaver, GenPreset?> {
  GenPresetSaverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genPresetSaverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genPresetSaverHash();

  @$internal
  @override
  GenPresetSaver create() => GenPresetSaver();
}

String _$genPresetSaverHash() => r'3dc369aa398295319a7aefa923e316f11d9cf3d7';

abstract class _$GenPresetSaver extends $AsyncNotifier<GenPreset?> {
  FutureOr<GenPreset?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GenPreset?>, GenPreset?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GenPreset?>, GenPreset?>,
              AsyncValue<GenPreset?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(GenRecordSaver)
final genRecordSaverProvider = GenRecordSaverProvider._();

final class GenRecordSaverProvider
    extends $AsyncNotifierProvider<GenRecordSaver, GenRecord?> {
  GenRecordSaverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genRecordSaverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genRecordSaverHash();

  @$internal
  @override
  GenRecordSaver create() => GenRecordSaver();
}

String _$genRecordSaverHash() => r'2fe90215a02537ea9ae4931ef306daf3a425af77';

abstract class _$GenRecordSaver extends $AsyncNotifier<GenRecord?> {
  FutureOr<GenRecord?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GenRecord?>, GenRecord?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GenRecord?>, GenRecord?>,
              AsyncValue<GenRecord?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(genActions)
final genActionsProvider = GenActionsProvider._();

final class GenActionsProvider
    extends $FunctionalProvider<GenActions, GenActions, GenActions>
    with $Provider<GenActions> {
  GenActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genActionsHash();

  @$internal
  @override
  $ProviderElement<GenActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GenActions create(Ref ref) {
    return genActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenActions>(value),
    );
  }
}

String _$genActionsHash() => r'0abe12949e5a00ce6faea0c57976b6709d1de076';
