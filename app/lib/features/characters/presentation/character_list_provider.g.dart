// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CharacterListFilter)
final characterListFilterProvider = CharacterListFilterProvider._();

final class CharacterListFilterProvider
    extends $NotifierProvider<CharacterListFilter, CharacterListState> {
  CharacterListFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'characterListFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$characterListFilterHash();

  @$internal
  @override
  CharacterListFilter create() => CharacterListFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CharacterListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CharacterListState>(value),
    );
  }
}

String _$characterListFilterHash() =>
    r'05a8f2ad5f724c6a6810f6e6a7b04a8d8c67a431';

abstract class _$CharacterListFilter extends $Notifier<CharacterListState> {
  CharacterListState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CharacterListState, CharacterListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CharacterListState, CharacterListState>,
              CharacterListState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(characterList)
final characterListProvider = CharacterListProvider._();

final class CharacterListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CharacterSummary>>,
          List<CharacterSummary>,
          FutureOr<List<CharacterSummary>>
        >
    with
        $FutureModifier<List<CharacterSummary>>,
        $FutureProvider<List<CharacterSummary>> {
  CharacterListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'characterListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$characterListHash();

  @$internal
  @override
  $FutureProviderElement<List<CharacterSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CharacterSummary>> create(Ref ref) {
    return characterList(ref);
  }
}

String _$characterListHash() => r'd253e8e5401e45f197b335e6627ccb50ce2cc82e';
