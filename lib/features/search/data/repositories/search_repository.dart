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
      // Debug: log the raw response to help diagnose empty results vs categories present
      // TODO: remove or guard this log in production
      try {
        print('[SearchRepository] raw response: ' + response.toString());
      } catch (e) {}

      final parsed = SearchResponse.fromJson(response);

      // Fallback: si la recherche "all" renvoie counts mais aucun item, appeler endpoint users/search
      if (parsed.results.isEmpty && parsed.categories.total > 0 && type == SearchType.all && parsed.categories.people > 0) {
        try {
          final usersResp = await _apiClient.getOne('/users/search', queryParams: {'q': query, 'limit': limit.toString()});
          // usersResp attendu: { results: [...], count: N }
          final List<dynamic> usersList = (usersResp['results'] is List) ? usersResp['results'] as List<dynamic> : [];
          final mappedResults = usersList.map((u) {
            final map = u is Map<String, dynamic> ? Map<String, dynamic>.from(u) : {};
            return SearchResult.fromJson({
              'type': 'people',
              'id': map['id'] ?? map['userId'] ?? '',
              'data': map,
            });
          }).toList();

          final fallbackResponse = SearchResponse(
            results: mappedResults.cast<SearchResult>(),
            pagination: parsed.pagination,
            categories: parsed.categories,
          );
          return Right(fallbackResponse);
        } catch (e) {
          // si fallback échoue, retourner la réponse originale (vide)
          return Right(parsed);
        }
      }

      return Right(parsed);
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
