// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_gen_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(characterGen)
final characterGenProvider = CharacterGenFamily._();

final class CharacterGenProvider
    extends
        $FunctionalProvider<
          AsyncValue<CharacterGen>,
          CharacterGen,
          FutureOr<CharacterGen>
        >
    with $FutureModifier<CharacterGen>, $FutureProvider<CharacterGen> {
  CharacterGenProvider._({
    required CharacterGenFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'characterGenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$characterGenHash();

  @override
  String toString() {
    return r'characterGenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CharacterGen> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CharacterGen> create(Ref ref) {
    final argument = this.argument as int;
    return characterGen(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CharacterGenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$characterGenHash() => r'a3c8ce626beb651acea292660a97e6e808e2522e';

final class CharacterGenFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CharacterGen>, int> {
  CharacterGenFamily._()
    : super(
        retry: null,
        name: r'characterGenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CharacterGenProvider call(int characterId) =>
      CharacterGenProvider._(argument: characterId, from: this);

  @override
  String toString() => r'characterGenProvider';
}
