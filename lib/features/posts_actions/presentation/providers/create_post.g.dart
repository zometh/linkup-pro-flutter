// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreatePostProvider)
const createPostProviderProvider = CreatePostProviderProvider._();

final class CreatePostProviderProvider
    extends $NotifierProvider<CreatePostProvider, bool> {
  const CreatePostProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createPostProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createPostProviderHash();

  @$internal
  @override
  CreatePostProvider create() => CreatePostProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$createPostProviderHash() =>
    r'44f72d892f0ec31ccc8b58d65a76f220316525ea';

abstract class _$CreatePostProvider extends $Notifier<bool> {
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
