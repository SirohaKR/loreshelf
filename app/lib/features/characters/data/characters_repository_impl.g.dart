// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characters_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(charactersRepository)
final charactersRepositoryProvider = CharactersRepositoryProvider._();

final class CharactersRepositoryProvider
    extends
        $FunctionalProvider<
          CharactersRepository,
          CharactersRepository,
          CharactersRepository
        >
    with $Provider<CharactersRepository> {
  CharactersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'charactersRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$charactersRepositoryHash();

  @$internal
  @override
  $ProviderElement<CharactersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CharactersRepository create(Ref ref) {
    return charactersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CharactersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CharactersRepository>(value),
    );
  }
}

String _$charactersRepositoryHash() =>
    r'2e57519918b393b4f7e908557094f9788bdfcff2';
