// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 화면 쪽에서는 이 provider로 인터페이스(AuthRepository)를 받는다. 구현이 무엇인지는 여기서만 정한다.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// 화면 쪽에서는 이 provider로 인터페이스(AuthRepository)를 받는다. 구현이 무엇인지는 여기서만 정한다.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// 화면 쪽에서는 이 provider로 인터페이스(AuthRepository)를 받는다. 구현이 무엇인지는 여기서만 정한다.
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'383beaaa22bbb4475f99eaaf5807ef39dcb5c9d2';
