import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/offers/data/repositories/job_offer_repository_impl.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:linkup_pro/features/offers/domain/entities/job_offer_company.dart';
import 'package:linkup_pro/features/offers/domain/entities/search_offers_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_offer_provider.g.dart';

/// State class for targeted job offers (member view)
class TargetedOffersState {
  final List<JobOfferEntity> offers;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;

  const TargetedOffersState({
    this.offers = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
  });

  TargetedOffersState copyWith({
    List<JobOfferEntity>? offers,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return TargetedOffersState(
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  List<JobOfferEntity> get recommendedOffers =>
      offers.where((o) => o.isRecommended).toList();

  List<JobOfferEntity> get otherOffers =>
      offers.where((o) => !o.isRecommended).toList();
}

/// State class for search results
class SearchOffersState {
  final List<JobOfferEntity> offers;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;
  final int total;
  final String query;

  const SearchOffersState({
    this.offers = const [],
    this.isLoading = false,
    this.hasMore = false,
    this.error,
    this.currentPage = 1,
    this.total = 0,
    this.query = '',
  });

  SearchOffersState copyWith({
    List<JobOfferEntity>? offers,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
    int? total,
    String? query,
  }) {
    return SearchOffersState(
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
      query: query ?? this.query,
    );
  }
}

/// State class for company's job offers
class CompanyOffersState {
  final List<JobOfferCompany> offers;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;

  const CompanyOffersState({
    this.offers = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
  });

  CompanyOffersState copyWith({
    List<JobOfferCompany>? offers,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return CompanyOffersState(
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Provider for targeted job offers (member view)
@Riverpod(keepAlive: true)
class TargetedJobOffers extends _$TargetedJobOffers {
  final _repository = GetIt.I<JobOfferRepositoryImpl>();

  @override
  TargetedOffersState build() {
    return const TargetedOffersState();
  }

  Future<void> fetchOffers({String? employmentTypeId}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getTargetedOffers(
      page: 1,
      limit: 20,
      employmentTypeId: employmentTypeId,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (offers) => state = state.copyWith(
        offers: offers,
        isLoading: false,
        currentPage: 1,
        hasMore: offers.length >= 20,
      ),
    );
  }

  /// Load more offers (pagination)
  Future<void> loadMore({String? employmentTypeId}) async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final nextPage = state.currentPage + 1;
    final result = await _repository.getTargetedOffers(
      page: nextPage,
      limit: 20,
      employmentTypeId: employmentTypeId,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (newOffers) => state = state.copyWith(
        offers: [...state.offers, ...newOffers],
        isLoading: false,
        currentPage: nextPage,
        hasMore: newOffers.length >= 20,
      ),
    );
  }

  /// Add a new offer (from WebSocket)
  void addOffer(JobOfferEntity offer) {
    state = state.copyWith(offers: [offer, ...state.offers]);
  }

  /// Update an offer
  void updateOffer(JobOfferEntity updatedOffer) {
    final index = state.offers.indexWhere((o) => o.id == updatedOffer.id);
    if (index != -1) {
      final newOffers = List<JobOfferEntity>.from(state.offers);
      newOffers[index] = updatedOffer;
      state = state.copyWith(offers: newOffers);
    }
  }

  /// Remove an offer
  void removeOffer(String offerId) {
    state = state.copyWith(
      offers: state.offers.where((o) => o.id != offerId).toList(),
    );
  }

  /// Mark offer as applied
  void markAsApplied(String offerId) {
    final index = state.offers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      final newOffers = List<JobOfferEntity>.from(state.offers);
      newOffers[index] = newOffers[index].copyWith(hasApplied: true);
      state = state.copyWith(offers: newOffers);
    }
  }

  /// Toggle saved status
  void toggleSaved(String offerId) {
    final index = state.offers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      final newOffers = List<JobOfferEntity>.from(state.offers);
      newOffers[index] = newOffers[index].copyWith(
        isSaved: !newOffers[index].isSaved,
      );
      state = state.copyWith(offers: newOffers);
    }
  }

  /// Clear all offers
  void clear() {
    state = const TargetedOffersState();
  }
}

/// Provider for company's job offers
@Riverpod(keepAlive: true)
class CompanyJobOffers extends _$CompanyJobOffers {
  final _repository = GetIt.I<JobOfferRepositoryImpl>();

  @override
  CompanyOffersState build() {
    return const CompanyOffersState();
  }

  Future<void> fetchOffers() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getCompanyOffers(page: 1, limit: 20);

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (offers) => state = state.copyWith(
        offers: offers,
        isLoading: false,
        currentPage: 1,
        hasMore: offers.length >= 20,
      ),
    );
  }

  /// Load more offers
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final nextPage = state.currentPage + 1;
    final result = await _repository.getCompanyOffers(
      page: nextPage,
      limit: 20,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (newOffers) => state = state.copyWith(
        offers: [...state.offers, ...newOffers],
        isLoading: false,
        currentPage: nextPage,
        hasMore: newOffers.length >= 20,
      ),
    );
  }

  /// Create a new offer
  Future<bool> createOffer({
    required String title,
    required String description,
    double? salary,
    required String employmentTypeId,
    DateTime? expiryDate,
    List<Map<String, dynamic>>? requiredSkills,
  }) async {
    final result = await _repository.createJobOffer(
      title: title,
      description: description,
      salary: salary,
      employmentTypeId: employmentTypeId,
      expiryDate: expiryDate,
      requiredSkills: requiredSkills,
    );

    return result.fold((failure) => false, (offer) {
      state = state.copyWith(offers: [offer, ...state.offers]);
      return true;
    });
  }

  /// Update an offer
  Future<bool> updateOffer({
    required String id,
    String? title,
    String? description,
    double? salary,
    String? employmentTypeId,
    DateTime? expiryDate,
    bool? isActive,
    List<Map<String, dynamic>>? requiredSkills,
  }) async {
    final result = await _repository.updateJobOffer(
      id: id,
      title: title,
      description: description,
      salary: salary,
      employmentTypeId: employmentTypeId,
      expiryDate: expiryDate,
      isActive: isActive,
      requiredSkills: requiredSkills,
    );

    return result.fold((failure) => false, (updatedOffer) {
      final index = state.offers.indexWhere((o) => o.id == id);
      if (index != -1) {
        final newOffers = List<JobOfferCompany>.from(state.offers);
        newOffers[index] = updatedOffer;
        state = state.copyWith(offers: newOffers);
      }
      return true;
    });
  }

  /// Delete an offer
  Future<bool> deleteOffer(String id) async {
    final result = await _repository.deleteJobOffer(id);

    return result.fold((failure) => false, (_) {
      state = state.copyWith(
        offers: state.offers.where((o) => o.id != id).toList(),
      );
      return true;
    });
  }

  /// Update applications count from WebSocket
  void updateApplicationsCount(String offerId, int count) {
    final index = state.offers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      final newOffers = List<JobOfferCompany>.from(state.offers);
      newOffers[index] = newOffers[index].copyWith(applicationsCount: count);
      state = state.copyWith(offers: newOffers);
    }
  }

  void clear() {
    state = const CompanyOffersState();
  }
}

/// Provider for searching job offers
@Riverpod(keepAlive: true)
class SearchJobOffers extends _$SearchJobOffers {
  final _repository = GetIt.I<JobOfferRepositoryImpl>();

  @override
  SearchOffersState build() {
    return const SearchOffersState();
  }

  /// Search offers
  Future<void> search({required String query, String? employmentTypeId}) async {
    if (query.trim().length < 2) {
      state = const SearchOffersState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null, query: query);

    final result = await _repository.searchOffers(
      query: query,
      employmentTypeId: employmentTypeId,
      page: 1,
      limit: 20,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (searchResult) => state = state.copyWith(
        offers: searchResult.offers,
        isLoading: false,
        currentPage: 1,
        total: searchResult.total,
        hasMore: searchResult.hasMore,
      ),
    );
  }

  /// Load more search results
  Future<void> loadMore({String? employmentTypeId}) async {
    if (state.isLoading || !state.hasMore || state.query.isEmpty) return;

    state = state.copyWith(isLoading: true);

    final nextPage = state.currentPage + 1;
    final result = await _repository.searchOffers(
      query: state.query,
      employmentTypeId: employmentTypeId,
      page: nextPage,
      limit: 20,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (searchResult) => state = state.copyWith(
        offers: [...state.offers, ...searchResult.offers],
        isLoading: false,
        currentPage: nextPage,
        hasMore: searchResult.hasMore,
      ),
    );
  }

  /// Clear search
  void clear() {
    state = const SearchOffersState();
  }
}

/// Provider for fetching a single job offer
@riverpod
Future<JobOfferEntity?> jobOfferDetail(Ref ref, String offerId) async {
  final repository = GetIt.I<JobOfferRepositoryImpl>();
  final result = await repository.getJobOfferById(offerId);

  return result.fold((failure) => null, (offer) => offer);
}
