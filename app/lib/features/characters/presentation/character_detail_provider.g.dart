// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(characterDetail)
final characterDetailProvider = CharacterDetailFamily._();

final class CharacterDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<CharacterDetail>,
          CharacterDetail,
          FutureOr<CharacterDetail>
        >
    with $FutureModifier<CharacterDetail>, $FutureProvider<CharacterDetail> {
  CharacterDetailProvider._({
    required CharacterDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'characterDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$characterDetailHash();

  @override
  String toString() {
    return r'characterDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CharacterDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CharacterDetail> create(Ref ref) {
    final argument = this.argument as int;
    return characterDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CharacterDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$characterDetailHash() => r'9720e32540989d4f0deaddff50994fde0f1b33b5';

final class CharacterDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CharacterDetail>, int> {
  CharacterDetailFamily._()
    : super(
        retry: null,
        name: r'characterDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CharacterDetailProvider call(int id) =>
      CharacterDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'characterDetailProvider';
}
