// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_post.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FetchPost)
const fetchPostProvider = FetchPostProvider._();

final class FetchPostProvider extends $NotifierProvider<FetchPost, bool> {
  const FetchPostProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchPostProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchPostHash();

  @$internal
  @override
  FetchPost create() => FetchPost();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$fetchPostHash() => r'901e5774be3af1be5c640ac2a13d3bb715ac4b72';

abstract class _$FetchPost extends $Notifier<bool> {
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
