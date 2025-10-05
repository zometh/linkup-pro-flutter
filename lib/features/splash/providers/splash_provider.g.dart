// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SplashProvider)
const splashProviderProvider = SplashProviderProvider._();

final class SplashProviderProvider
    extends $NotifierProvider<SplashProvider, int> {
  const SplashProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashProviderHash();

  @$internal
  @override
  SplashProvider create() => SplashProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$splashProviderHash() => r'974891c0a3f9c6217f5803f611049c6198045d88';

abstract class _$SplashProvider extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
