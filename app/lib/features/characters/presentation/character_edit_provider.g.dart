// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(characterEditInitial)
final characterEditInitialProvider = CharacterEditInitialFamily._();

final class CharacterEditInitialProvider
    extends
        $FunctionalProvider<
          AsyncValue<CharacterDraft>,
          CharacterDraft,
          FutureOr<CharacterDraft>
        >
    with $FutureModifier<CharacterDraft>, $FutureProvider<CharacterDraft> {
  CharacterEditInitialProvider._({
    required CharacterEditInitialFamily super.from,
    required (int?, int?) super.argument,
  }) : super(
         retry: null,
         name: r'characterEditInitialProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$characterEditInitialHash();

  @override
  String toString() {
    return r'characterEditInitialProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CharacterDraft> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CharacterDraft> create(Ref ref) {
    final argument = this.argument as (int?, int?);
    return characterEditInitial(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CharacterEditInitialProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$characterEditInitialHash() =>
    r'8e92cf8f7327ca96faa24d5af8ec0a819c30d7ad';

final class CharacterEditInitialFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CharacterDraft>, (int?, int?)> {
  CharacterEditInitialFamily._()
    : super(
        retry: null,
        name: r'characterEditInitialProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CharacterEditInitialProvider call(int? id, int? projectId) =>
      CharacterEditInitialProvider._(argument: (id, projectId), from: this);

  @override
  String toString() => r'characterEditInitialProvider';
}

/// AsyncNotifier로 저장하기: build()는 "아직 아무것도 안 함"(null),
/// save()가 state를 AsyncLoading → AsyncData(저장된 캐릭터) 또는 AsyncError로 바꾼다.
/// 화면은 state.isLoading으로 버튼을 막고, state.error로 오류 문구를 보여 준다.

@ProviderFor(CharacterSaver)
final characterSaverProvider = CharacterSaverProvider._();

/// AsyncNotifier로 저장하기: build()는 "아직 아무것도 안 함"(null),
/// save()가 state를 AsyncLoading → AsyncData(저장된 캐릭터) 또는 AsyncError로 바꾼다.
/// 화면은 state.isLoading으로 버튼을 막고, state.error로 오류 문구를 보여 준다.
final class CharacterSaverProvider
    extends $AsyncNotifierProvider<CharacterSaver, CharacterDetail?> {
  /// AsyncNotifier로 저장하기: build()는 "아직 아무것도 안 함"(null),
  /// save()가 state를 AsyncLoading → AsyncData(저장된 캐릭터) 또는 AsyncError로 바꾼다.
  /// 화면은 state.isLoading으로 버튼을 막고, state.error로 오류 문구를 보여 준다.
  CharacterSaverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'characterSaverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$characterSaverHash();

  @$internal
  @override
  CharacterSaver create() => CharacterSaver();
}

String _$characterSaverHash() => r'4abfeb21f3473830511a87a13427a88ad894b9a9';

/// AsyncNotifier로 저장하기: build()는 "아직 아무것도 안 함"(null),
/// save()가 state를 AsyncLoading → AsyncData(저장된 캐릭터) 또는 AsyncError로 바꾼다.
/// 화면은 state.isLoading으로 버튼을 막고, state.error로 오류 문구를 보여 준다.

abstract class _$CharacterSaver extends $AsyncNotifier<CharacterDetail?> {
  FutureOr<CharacterDetail?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CharacterDetail?>, CharacterDetail?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CharacterDetail?>, CharacterDetail?>,
              AsyncValue<CharacterDetail?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(characterActions)
final characterActionsProvider = CharacterActionsProvider._();

final class CharacterActionsProvider
    extends
        $FunctionalProvider<
          CharacterActions,
          CharacterActions,
          CharacterActions
        >
    with $Provider<CharacterActions> {
  CharacterActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'characterActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$characterActionsHash();

  @$internal
  @override
  $ProviderElement<CharacterActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CharacterActions create(Ref ref) {
    return characterActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CharacterActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CharacterActions>(value),
    );
  }
}

String _$characterActionsHash() => r'6f65e11de20e1c6467f140e3ec92684a49feba6e';
