// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_post_comments.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FetchPostComments)
const fetchPostCommentsProvider = FetchPostCommentsProvider._();

final class FetchPostCommentsProvider
    extends $NotifierProvider<FetchPostComments, bool> {
  const FetchPostCommentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchPostCommentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchPostCommentsHash();

  @$internal
  @override
  FetchPostComments create() => FetchPostComments();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$fetchPostCommentsHash() => r'89506a7f84ea4ba786995b8e43423ed61ca41098';

abstract class _$FetchPostComments extends $Notifier<bool> {
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
