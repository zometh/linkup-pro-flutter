enum SearchType {
  all,
  people,
  companies,
  posts,
  jobs,
}

extension SearchTypeExtension on SearchType {
  String get value {
    switch (this) {
      case SearchType.all:
        return 'all';
      case SearchType.people:
        return 'people';
      case SearchType.companies:
        return 'companies';
      case SearchType.posts:
        return 'posts';
      case SearchType.jobs:
        return 'jobs';
    }
  }

  String get label {
    switch (this) {
      case SearchType.all:
        return 'Tout';
      case SearchType.people:
        return 'Personnes';
      case SearchType.companies:
        return 'Entreprises';
      case SearchType.posts:
        return 'Publications';
      case SearchType.jobs:
        return 'Emplois';
    }
  }
}

class SearchResult {
  final String type;
  final String id;
  final Map<String, dynamic> data;
  final double relevanceScore;

  SearchResult({
    required this.type,
    required this.id,
    required this.data,
    required this.relevanceScore,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    // Normaliser : plusieurs APIs peuvent renvoyer différentes structures.
    String type = (json['type'] ?? '').toString();
    String id = (json['id'] ?? json['_id'] ?? json['uid'] ?? '').toString();
    dynamic rawData = json['data'] ?? json['source'] ?? json['doc'] ?? json['_source'] ?? json;

    // Si rawData contient id/type, enlever pour éviter duplication
    if (rawData is Map) {
      rawData = Map<String, dynamic>.from(rawData);
      rawData.remove('id');
      rawData.remove('_id');
      rawData.remove('type');
    }

    // Inférer type si absent en regardant quelques champs communs
    if (type.isEmpty && rawData is Map) {
      if (rawData.containsKey('firstName') || rawData.containsKey('lastName') || rawData.containsKey('username')) {
        type = 'people';
      } else if (rawData.containsKey('companies') || rawData.containsKey('logo') || (rawData.containsKey('name') && rawData.containsKey('isCompany'))) {
        type = 'company';
      } else if (rawData.containsKey('content') || rawData.containsKey('publicationDate')) {
        type = 'post';
      } else if (rawData.containsKey('title') || rawData.containsKey('employmentType')) {
        type = 'job';
      }
    }

    final relevanceScore = ((json['relevanceScore'] ?? json['_score'] ?? 0) as num).toDouble();

    return SearchResult(
      type: type,
      id: id,
      data: rawData is Map ? Map<String, dynamic>.from(rawData) : {'value': rawData},
      relevanceScore: relevanceScore,
    );
  }
}

class SearchPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  SearchPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory SearchPagination.fromJson(Map<String, dynamic> json) {
    return SearchPagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class SearchCategories {
  final int people;
  final int companies;
  final int posts;
  final int jobs;

  SearchCategories({
    required this.people,
    required this.companies,
    required this.posts,
    required this.jobs,
  });

  factory SearchCategories.fromJson(Map<String, dynamic> json) {
    return SearchCategories(
      people: json['people'] ?? 0,
      companies: json['companies'] ?? 0,
      posts: json['posts'] ?? 0,
      jobs: json['jobs'] ?? 0,
    );
  }

  int get total => people + companies + posts + jobs;
}

class SearchResponse {
  final List<SearchResult> results;
  final SearchPagination pagination;
  final SearchCategories categories;

  SearchResponse({
    required this.results,
    required this.pagination,
    required this.categories,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    // Supporter plusieurs enveloppes : { data: { results: [...] } } ou directement { results: [...] }
    Map<String, dynamic> payload = Map<String, dynamic>.from(json);
    if (payload.containsKey('data') && payload['data'] is Map) {
      payload = Map<String, dynamic>.from(payload['data']);
    }

    // Trouver la clé de la liste de résultats
    List<dynamic>? rawResults;
    for (final k in ['results', 'items', 'hits', 'data']) {
      if (payload.containsKey(k) && payload[k] is List) {
        rawResults = payload[k] as List<dynamic>?;
        break;
      }
    }
    rawResults ??= [];

    final results = rawResults.map((e) {
      if (e is Map<String, dynamic>) return SearchResult.fromJson(e);
      if (e is Map) return SearchResult.fromJson(Map<String, dynamic>.from(e));
      // si élément non map, emballer
      return SearchResult.fromJson({'data': e});
    }).toList();

    // Construire pagination & categories (utilisés éventuellement pour le fallback / merged)
    final pagination = SearchPagination.fromJson(payload['pagination'] ?? payload['meta'] ?? {});
    final categories = SearchCategories.fromJson(payload['categories'] ?? payload['facets'] ?? {});

    // Si pas de résultats trouvés dans les clés habituelles, l'API peut renvoyer des listes par catégorie
    if (results.isEmpty) {
      final categoryKeys = <String, String>{
        'people': 'people',
        'companies': 'company',
        'posts': 'post',
        'jobs': 'job',
      };
      final List<SearchResult> merged = [];
      for (final entry in categoryKeys.entries) {
        final key = entry.key;
        final inferredType = entry.value;
        if (payload.containsKey(key) && payload[key] is List) {
          final list = payload[key] as List<dynamic>;
          for (final item in list) {
            if (item is Map<String, dynamic>) {
              // Ensure type and id propagate into SearchResult.fromJson
              final map = Map<String, dynamic>.from(item);
              if (map['type'] == null || (map['type'] as String).isEmpty) map['type'] = inferredType;
              if (map['id'] == null && map['userId'] != null) map['id'] = map['userId'];
              merged.add(SearchResult.fromJson(map));
            } else if (item is Map) {
              final map = Map<String, dynamic>.from(item);
              if (map['type'] == null || (map['type'] as String).isEmpty) map['type'] = inferredType;
              if (map['id'] == null && map['userId'] != null) map['id'] = map['userId'];
              merged.add(SearchResult.fromJson(map));
            } else {
              merged.add(SearchResult.fromJson({'data': item, 'type': inferredType}));
            }
          }
        }
      }
      if (merged.isNotEmpty) {
        // remplacer results par la fusion
        return SearchResponse(
          results: merged,
          pagination: pagination,
          categories: categories,
        );
      }

      // Aucun résultat, mais s'il y a des compteurs (>0) on logge pour debug
      if ((pagination.total > 0) || (categories.total > 0)) {
        try {
          print('[SearchResponse] warning: pagination.total=${pagination.total}, categories.total=${categories.total} but no results and no per-category lists provided.');
        } catch (e) {}
      }
    }

    return SearchResponse(
      results: results,
      pagination: pagination,
      categories: categories,
    );
  }
}

class SearchSuggestion {
  final String type;
  final String id;
  final String text;
  final String? subtitle;
  final String? photo;

  SearchSuggestion({
    required this.type,
    required this.id,
    required this.text,
    this.subtitle,
    this.photo,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      type: json['type'] ?? '',
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      subtitle: json['subtitle'],
      photo: json['photo'],
    );
  }
}
