// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterProfile)
const registerProfileProvider = RegisterProfileProvider._();

final class RegisterProfileProvider
    extends $NotifierProvider<RegisterProfile, bool> {
  const RegisterProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerProfileHash();

  @$internal
  @override
  RegisterProfile create() => RegisterProfile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$registerProfileHash() => r'882b1eed53abac29e18f72503315e9e1ec4dedb5';

abstract class _$RegisterProfile extends $Notifier<bool> {
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
