// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_comment.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateComment)
const createCommentProvider = CreateCommentProvider._();

final class CreateCommentProvider
    extends $NotifierProvider<CreateComment, bool> {
  const CreateCommentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCommentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCommentHash();

  @$internal
  @override
  CreateComment create() => CreateComment();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$createCommentHash() => r'cfa1bc3cb591a80f4cec3da5828139c675900be7';

abstract class _$CreateComment extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
