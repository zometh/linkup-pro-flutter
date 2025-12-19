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
    return SearchResult(
      type: json['type'] ?? '',
      id: json['id'] ?? '',
      data: json['data'] ?? {},
      relevanceScore: (json['relevanceScore'] ?? 0).toDouble(),
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
    return SearchResponse(
      results: (json['results'] as List?)
              ?.map((e) => SearchResult.fromJson(e))
              .toList() ??
          [],
      pagination: SearchPagination.fromJson(json['pagination'] ?? {}),
      categories: SearchCategories.fromJson(json['categories'] ?? {}),
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

