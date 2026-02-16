// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_application_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for member's job applications

@ProviderFor(MemberApplications)
const memberApplicationsProvider = MemberApplicationsProvider._();

/// Provider for member's job applications
final class MemberApplicationsProvider
    extends $NotifierProvider<MemberApplications, JobApplicationsState> {
  /// Provider for member's job applications
  const MemberApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberApplicationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberApplicationsHash();

  @$internal
  @override
  MemberApplications create() => MemberApplications();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobApplicationsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobApplicationsState>(value),
    );
  }
}

String _$memberApplicationsHash() =>
    r'3a1bf732a41b56b3f9aa9158e8b610b458a9a2ac';

/// Provider for member's job applications

abstract class _$MemberApplications extends $Notifier<JobApplicationsState> {
  JobApplicationsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<JobApplicationsState, JobApplicationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JobApplicationsState, JobApplicationsState>,
              JobApplicationsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for company's received applications

@ProviderFor(CompanyApplications)
const companyApplicationsProvider = CompanyApplicationsProvider._();

/// Provider for company's received applications
final class CompanyApplicationsProvider
    extends $NotifierProvider<CompanyApplications, JobApplicationsState> {
  /// Provider for company's received applications
  const CompanyApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companyApplicationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companyApplicationsHash();

  @$internal
  @override
  CompanyApplications create() => CompanyApplications();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobApplicationsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobApplicationsState>(value),
    );
  }
}

String _$companyApplicationsHash() =>
    r'd76ee75c2bedc62445b5c0cf377d1543b4693282';

/// Provider for company's received applications

abstract class _$CompanyApplications extends $Notifier<JobApplicationsState> {
  JobApplicationsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<JobApplicationsState, JobApplicationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JobApplicationsState, JobApplicationsState>,
              JobApplicationsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for applying to a job (handles loading state)

@ProviderFor(ApplyToJobNotifier)
const applyToJobProvider = ApplyToJobNotifierProvider._();

/// Provider for applying to a job (handles loading state)
final class ApplyToJobNotifierProvider
    extends $NotifierProvider<ApplyToJobNotifier, bool> {
  /// Provider for applying to a job (handles loading state)
  const ApplyToJobNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applyToJobProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applyToJobNotifierHash();

  @$internal
  @override
  ApplyToJobNotifier create() => ApplyToJobNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$applyToJobNotifierHash() =>
    r'2d51d6ae2173567090a2dc403c37b0ee0467e858';

/// Provider for applying to a job (handles loading state)

abstract class _$ApplyToJobNotifier extends $Notifier<bool> {
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
