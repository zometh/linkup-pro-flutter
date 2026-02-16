import 'package:linkup_pro/features/offers/domain/entities/job_offer_entity.dart';

/// Résultat de recherche d'offres d'emploi avec pagination
class SearchOffersResult {
  final List<JobOfferEntity> offers;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const SearchOffersResult({
    required this.offers,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  SearchOffersResult copyWith({
    List<JobOfferEntity>? offers,
    int? total,
    int? page,
    int? limit,
    int? totalPages,
  }) {
    return SearchOffersResult(
      offers: offers ?? this.offers,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
