// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trash_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(trash)
final trashProvider = TrashProvider._();

final class TrashProvider
    extends
        $FunctionalProvider<
          AsyncValue<TrashLists>,
          TrashLists,
          FutureOr<TrashLists>
        >
    with $FutureModifier<TrashLists>, $FutureProvider<TrashLists> {
  TrashProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trashProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trashHash();

  @$internal
  @override
  $FutureProviderElement<TrashLists> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TrashLists> create(Ref ref) {
    return trash(ref);
  }
}

String _$trashHash() => r'cb9bc5922558e3048e33fe1bfd3123f2b266226c';

@ProviderFor(trashActions)
final trashActionsProvider = TrashActionsProvider._();

final class TrashActionsProvider
    extends $FunctionalProvider<TrashActions, TrashActions, TrashActions>
    with $Provider<TrashActions> {
  TrashActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trashActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trashActionsHash();

  @$internal
  @override
  $ProviderElement<TrashActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TrashActions create(Ref ref) {
    return trashActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrashActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrashActions>(value),
    );
  }
}

String _$trashActionsHash() => r'aa0fb8158486b87b725ec601509991ca40e38e28';
