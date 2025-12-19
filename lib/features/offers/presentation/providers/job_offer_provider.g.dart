// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_offer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for targeted job offers (member view)

@ProviderFor(TargetedJobOffers)
const targetedJobOffersProvider = TargetedJobOffersProvider._();

/// Provider for targeted job offers (member view)
final class TargetedJobOffersProvider
    extends $NotifierProvider<TargetedJobOffers, TargetedOffersState> {
  /// Provider for targeted job offers (member view)
  const TargetedJobOffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'targetedJobOffersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$targetedJobOffersHash();

  @$internal
  @override
  TargetedJobOffers create() => TargetedJobOffers();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TargetedOffersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TargetedOffersState>(value),
    );
  }
}

String _$targetedJobOffersHash() => r'6a576a9c41388829eb5b3a770ba14d612bf5afd4';

/// Provider for targeted job offers (member view)

abstract class _$TargetedJobOffers extends $Notifier<TargetedOffersState> {
  TargetedOffersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TargetedOffersState, TargetedOffersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TargetedOffersState, TargetedOffersState>,
              TargetedOffersState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for company's job offers

@ProviderFor(CompanyJobOffers)
const companyJobOffersProvider = CompanyJobOffersProvider._();

/// Provider for company's job offers
final class CompanyJobOffersProvider
    extends $NotifierProvider<CompanyJobOffers, CompanyOffersState> {
  /// Provider for company's job offers
  const CompanyJobOffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companyJobOffersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companyJobOffersHash();

  @$internal
  @override
  CompanyJobOffers create() => CompanyJobOffers();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompanyOffersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompanyOffersState>(value),
    );
  }
}

String _$companyJobOffersHash() => r'cbc02dc3d52d96efd241991513a9d9bf87af75ee';

/// Provider for company's job offers

abstract class _$CompanyJobOffers extends $Notifier<CompanyOffersState> {
  CompanyOffersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CompanyOffersState, CompanyOffersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CompanyOffersState, CompanyOffersState>,
              CompanyOffersState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for searching job offers

@ProviderFor(SearchJobOffers)
const searchJobOffersProvider = SearchJobOffersProvider._();

/// Provider for searching job offers
final class SearchJobOffersProvider
    extends $NotifierProvider<SearchJobOffers, SearchOffersState> {
  /// Provider for searching job offers
  const SearchJobOffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchJobOffersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchJobOffersHash();

  @$internal
  @override
  SearchJobOffers create() => SearchJobOffers();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchOffersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchOffersState>(value),
    );
  }
}

String _$searchJobOffersHash() => r'38a8eae4fccd545fc4233e0d0454c4d38205fa9c';

/// Provider for searching job offers

abstract class _$SearchJobOffers extends $Notifier<SearchOffersState> {
  SearchOffersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SearchOffersState, SearchOffersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchOffersState, SearchOffersState>,
              SearchOffersState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for fetching a single job offer

@ProviderFor(jobOfferDetail)
const jobOfferDetailProvider = JobOfferDetailFamily._();

/// Provider for fetching a single job offer

final class JobOfferDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<JobOfferEntity?>,
          JobOfferEntity?,
          FutureOr<JobOfferEntity?>
        >
    with $FutureModifier<JobOfferEntity?>, $FutureProvider<JobOfferEntity?> {
  /// Provider for fetching a single job offer
  const JobOfferDetailProvider._({
    required JobOfferDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'jobOfferDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jobOfferDetailHash();

  @override
  String toString() {
    return r'jobOfferDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<JobOfferEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<JobOfferEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return jobOfferDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is JobOfferDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jobOfferDetailHash() => r'9a69ccce219c01fe05e2774a510718b17b862efd';

/// Provider for fetching a single job offer

final class JobOfferDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<JobOfferEntity?>, String> {
  const JobOfferDetailFamily._()
    : super(
        retry: null,
        name: r'jobOfferDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for fetching a single job offer

  JobOfferDetailProvider call(String offerId) =>
      JobOfferDetailProvider._(argument: offerId, from: this);

  @override
  String toString() => r'jobOfferDetailProvider';
}
