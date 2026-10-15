// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(projectDetail)
final projectDetailProvider = ProjectDetailFamily._();

final class ProjectDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProjectDetail>,
          ProjectDetail,
          FutureOr<ProjectDetail>
        >
    with $FutureModifier<ProjectDetail>, $FutureProvider<ProjectDetail> {
  ProjectDetailProvider._({
    required ProjectDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'projectDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectDetailHash();

  @override
  String toString() {
    return r'projectDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProjectDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProjectDetail> create(Ref ref) {
    final argument = this.argument as int;
    return projectDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectDetailHash() => r'726f6d469434bdd99aeb271fc325fc27fafdd66c';

final class ProjectDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProjectDetail>, int> {
  ProjectDetailFamily._()
    : super(
        retry: null,
        name: r'projectDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectDetailProvider call(int id) =>
      ProjectDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'projectDetailProvider';
}
