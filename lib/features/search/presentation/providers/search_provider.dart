import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/search/data/repositories/search_repository.dart';
import 'package:linkup_pro/features/search/domain/entities/search_entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

/// État de la recherche
class SearchState {
  final String query;
  final SearchType type;
  final List<SearchResult> results;
  final SearchPagination? pagination;
  final SearchCategories? categories;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const SearchState({
    this.query = '',
    this.type = SearchType.all,
    this.results = const [],
    this.pagination,
    this.categories,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    SearchType? type,
    List<SearchResult>? results,
    SearchPagination? pagination,
    SearchCategories? categories,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      type: type ?? this.type,
      results: results ?? this.results,
      pagination: pagination ?? this.pagination,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }

  bool get hasMore =>
      pagination != null && pagination!.page < pagination!.totalPages;
}

/// Provider principal de recherche
@Riverpod(keepAlive: true)
class Search extends _$Search {
  final _repository = GetIt.I<SearchRepository>();
  Timer? _debounceTimer;

  @override
  SearchState build() {
    return const SearchState();
  }

  /// Recherche avec debounce
  void searchWithDebounce(String query, {Duration delay = const Duration(milliseconds: 300)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {
      search(query);
    });
  }

  /// Effectuer une recherche
  Future<void> search(String query, {SearchType? type}) async {
    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    final searchType = type ?? state.type;
    state = state.copyWith(
      query: query,
      type: searchType,
      isLoading: true,
      error: null,
    );

    final result = await _repository.search(
      query: query,
      type: searchType,
      page: 1,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure,
      ),
      (response) => state = state.copyWith(
        results: response.results,
        pagination: response.pagination,
        categories: response.categories,
        isLoading: false,
      ),
    );
  }

  /// Changer le type de recherche
  Future<void> changeType(SearchType type) async {
    if (state.query.isNotEmpty) {
      await search(state.query, type: type);
    } else {
      state = state.copyWith(type: type);
    }
  }

  /// Charger plus de résultats
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.query.isEmpty) return;

    state = state.copyWith(isLoadingMore: true);

    final nextPage = (state.pagination?.page ?? 0) + 1;
    final result = await _repository.search(
      query: state.query,
      type: state.type,
      page: nextPage,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        error: failure,
      ),
      (response) => state = state.copyWith(
        results: [...state.results, ...response.results],
        pagination: response.pagination,
        isLoadingMore: false,
      ),
    );
  }

  /// Réinitialiser la recherche
  void clear() {
    _debounceTimer?.cancel();
    state = const SearchState();
  }
}

/// Provider pour les suggestions
@riverpod
class SearchSuggestions extends _$SearchSuggestions {
  final _repository = GetIt.I<SearchRepository>();
  Timer? _debounceTimer;

  @override
  List<SearchSuggestion> build() {
    return [];
  }

  /// Récupérer les suggestions avec debounce
  void getSuggestions(String query) {
    _debounceTimer?.cancel();

    if (query.trim().length < 2) {
      state = [];
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 200), () async {
      final result = await _repository.getSuggestions(query: query);
      result.fold(
        (failure) => state = [],
        (suggestions) => state = suggestions,
      );
    });
  }

  void clear() {
    _debounceTimer?.cancel();
    state = [];
  }
}

