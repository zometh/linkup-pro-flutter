// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_post.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LikePost)
const likePostProvider = LikePostProvider._();

final class LikePostProvider extends $NotifierProvider<LikePost, void> {
  const LikePostProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likePostProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likePostHash();

  @$internal
  @override
  LikePost create() => LikePost();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$likePostHash() => r'2033c477889e13115f775b2f6c9f3927e36e0c1b';

abstract class _$LikePost extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
