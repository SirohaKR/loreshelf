// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(genRepository)
final genRepositoryProvider = GenRepositoryProvider._();

final class GenRepositoryProvider
    extends $FunctionalProvider<GenRepository, GenRepository, GenRepository>
    with $Provider<GenRepository> {
  GenRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genRepositoryHash();

  @$internal
  @override
  $ProviderElement<GenRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GenRepository create(Ref ref) {
    return genRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenRepository>(value),
    );
  }
}

String _$genRepositoryHash() => r'75e93fcf13d82f0092e41fe8fb7e6f39f77d798d';
