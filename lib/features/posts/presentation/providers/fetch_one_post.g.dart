// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_one_post.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FetchOnePost)
const fetchOnePostProvider = FetchOnePostProvider._();

final class FetchOnePostProvider extends $NotifierProvider<FetchOnePost, bool> {
  const FetchOnePostProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchOnePostProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchOnePostHash();

  @$internal
  @override
  FetchOnePost create() => FetchOnePost();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$fetchOnePostHash() => r'c747a54e0417f94249d13bee97947bdbe7376de3';

abstract class _$FetchOnePost extends $Notifier<bool> {
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
