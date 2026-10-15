// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(projectEditInitial)
final projectEditInitialProvider = ProjectEditInitialFamily._();

final class ProjectEditInitialProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProjectDraft>,
          ProjectDraft,
          FutureOr<ProjectDraft>
        >
    with $FutureModifier<ProjectDraft>, $FutureProvider<ProjectDraft> {
  ProjectEditInitialProvider._({
    required ProjectEditInitialFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'projectEditInitialProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectEditInitialHash();

  @override
  String toString() {
    return r'projectEditInitialProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProjectDraft> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProjectDraft> create(Ref ref) {
    final argument = this.argument as int?;
    return projectEditInitial(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectEditInitialProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectEditInitialHash() =>
    r'74d7dcd182f15d4c9eee5f0bfff13a568955ec4a';

final class ProjectEditInitialFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProjectDraft>, int?> {
  ProjectEditInitialFamily._()
    : super(
        retry: null,
        name: r'projectEditInitialProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectEditInitialProvider call(int? id) =>
      ProjectEditInitialProvider._(argument: id, from: this);

  @override
  String toString() => r'projectEditInitialProvider';
}

/// 서재에서 연결 창이 보여줄 공용 서재 캐릭터 목록

@ProviderFor(libraryCharactersForLinking)
final libraryCharactersForLinkingProvider =
    LibraryCharactersForLinkingProvider._();

/// 서재에서 연결 창이 보여줄 공용 서재 캐릭터 목록

final class LibraryCharactersForLinkingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CharacterSummary>>,
          List<CharacterSummary>,
          FutureOr<List<CharacterSummary>>
        >
    with
        $FutureModifier<List<CharacterSummary>>,
        $FutureProvider<List<CharacterSummary>> {
  /// 서재에서 연결 창이 보여줄 공용 서재 캐릭터 목록
  LibraryCharactersForLinkingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryCharactersForLinkingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryCharactersForLinkingHash();

  @$internal
  @override
  $FutureProviderElement<List<CharacterSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CharacterSummary>> create(Ref ref) {
    return libraryCharactersForLinking(ref);
  }
}

String _$libraryCharactersForLinkingHash() =>
    r'ff96dae493c9e5c40e47082faf8a280cb52bf54a';

/// 장르·세계관 태그 전체 — 태그 고르기 창이 쓴다

@ProviderFor(genreList)
final genreListProvider = GenreListProvider._();

/// 장르·세계관 태그 전체 — 태그 고르기 창이 쓴다

final class GenreListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Genre>>,
          List<Genre>,
          FutureOr<List<Genre>>
        >
    with $FutureModifier<List<Genre>>, $FutureProvider<List<Genre>> {
  /// 장르·세계관 태그 전체 — 태그 고르기 창이 쓴다
  GenreListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genreListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genreListHash();

  @$internal
  @override
  $FutureProviderElement<List<Genre>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Genre>> create(Ref ref) {
    return genreList(ref);
  }
}

String _$genreListHash() => r'67cd370bfad9315eadfc6e24b6444962c7778e46';

@ProviderFor(ProjectSaver)
final projectSaverProvider = ProjectSaverProvider._();

final class ProjectSaverProvider
    extends $AsyncNotifierProvider<ProjectSaver, ProjectDetail?> {
  ProjectSaverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectSaverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectSaverHash();

  @$internal
  @override
  ProjectSaver create() => ProjectSaver();
}

String _$projectSaverHash() => r'b6c47e04482935657d35ae11aa47ed3c60e8045b';

abstract class _$ProjectSaver extends $AsyncNotifier<ProjectDetail?> {
  FutureOr<ProjectDetail?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ProjectDetail?>, ProjectDetail?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProjectDetail?>, ProjectDetail?>,
              AsyncValue<ProjectDetail?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 서재 캐릭터 연결/끊기 — 누르면 바로 하는 일 (CharacterActions와 같은 짜임)

@ProviderFor(projectActions)
final projectActionsProvider = ProjectActionsProvider._();

/// 서재 캐릭터 연결/끊기 — 누르면 바로 하는 일 (CharacterActions와 같은 짜임)

final class ProjectActionsProvider
    extends $FunctionalProvider<ProjectActions, ProjectActions, ProjectActions>
    with $Provider<ProjectActions> {
  /// 서재 캐릭터 연결/끊기 — 누르면 바로 하는 일 (CharacterActions와 같은 짜임)
  ProjectActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectActionsHash();

  @$internal
  @override
  $ProviderElement<ProjectActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProjectActions create(Ref ref) {
    return projectActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectActions>(value),
    );
  }
}

String _$projectActionsHash() => r'c00c1ac031e2b995070e453638e1c81132395d7f';
