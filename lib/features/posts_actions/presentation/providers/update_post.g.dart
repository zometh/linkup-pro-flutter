// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_post.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UpdatePostProvider)
const updatePostProviderProvider = UpdatePostProviderProvider._();

final class UpdatePostProviderProvider
    extends $NotifierProvider<UpdatePostProvider, bool> {
  const UpdatePostProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updatePostProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updatePostProviderHash();

  @$internal
  @override
  UpdatePostProvider create() => UpdatePostProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$updatePostProviderHash() =>
    r'3eb00646b5cc4d188285fd9ab5acc7a8d4e6f519';

abstract class _$UpdatePostProvider extends $Notifier<bool> {
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
