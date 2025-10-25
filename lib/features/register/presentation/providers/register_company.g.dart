// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_company.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterCompany)
const registerCompanyProvider = RegisterCompanyProvider._();

final class RegisterCompanyProvider
    extends $NotifierProvider<RegisterCompany, bool> {
  const RegisterCompanyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerCompanyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerCompanyHash();

  @$internal
  @override
  RegisterCompany create() => RegisterCompany();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$registerCompanyHash() => r'e7161f7a003ceb209fc57f7e7b16e93e454610dc';

abstract class _$RegisterCompany extends $Notifier<bool> {
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
