import 'package:dartz/dartz.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/network/api/network_exception.dart';
import 'package:linkup_pro/features/search/domain/entities/search_entities.dart';

class SearchRepository {
  final ApiClient _apiClient;

  SearchRepository(this._apiClient);

  /// Recherche globale
  Future<Either<String, SearchResponse>> search({
    required String query,
    SearchType type = SearchType.all,
    int page = 1,
    int limit = 10,
    String? sectorId,
    String? employmentTypeId,
  }) async {
    try {
      final queryParams = {
        'query': query,
        'type': type.value,
        'page': page.toString(),
        'limit': limit.toString(),
        if (sectorId != null) 'sectorId': sectorId,
        if (employmentTypeId != null) 'employmentTypeId': employmentTypeId,
      };

      // Utiliser getOne car la réponse est un objet avec pagination
      final response = await _apiClient.getOne(
        '/search',
        queryParams: queryParams,
      );

      return Right(SearchResponse.fromJson(response));
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Suggestions de recherche
  Future<Either<String, List<SearchSuggestion>>> getSuggestions({
    required String query,
    int limit = 5,
  }) async {
    try {
      // Utiliser get car la réponse est une liste
      final response = await _apiClient.get(
        '/search/suggestions',
        queryParams: {
          'query': query,
          'limit': limit.toString(),
        },
      );

      final suggestions = response
          .map((e) => SearchSuggestion.fromJson(e))
          .toList();
      return Right(suggestions);
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Recherches récentes
  Future<Either<String, List<String>>> getRecentSearches() async {
    try {
      final response = await _apiClient.get('/search/recent');
      final searches = response.map((e) => e.toString()).toList();
      return Right(searches);
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

