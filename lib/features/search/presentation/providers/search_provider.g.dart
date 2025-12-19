// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider principal de recherche

@ProviderFor(Search)
const searchProvider = SearchProvider._();

/// Provider principal de recherche
final class SearchProvider extends $NotifierProvider<Search, SearchState> {
  /// Provider principal de recherche
  const SearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchHash();

  @$internal
  @override
  Search create() => Search();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchState>(value),
    );
  }
}

String _$searchHash() => r'e5d283efb7e55914befbab24a76ab5e2b4819ac8';

/// Provider principal de recherche

abstract class _$Search extends $Notifier<SearchState> {
  SearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SearchState, SearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchState, SearchState>,
              SearchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider pour les suggestions

@ProviderFor(SearchSuggestions)
const searchSuggestionsProvider = SearchSuggestionsProvider._();

/// Provider pour les suggestions
final class SearchSuggestionsProvider
    extends $NotifierProvider<SearchSuggestions, List<SearchSuggestion>> {
  /// Provider pour les suggestions
  const SearchSuggestionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchSuggestionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchSuggestionsHash();

  @$internal
  @override
  SearchSuggestions create() => SearchSuggestions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SearchSuggestion> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SearchSuggestion>>(value),
    );
  }
}

String _$searchSuggestionsHash() => r'2dc26de45dab971bbdeef6f6dc4a5f6572a01625';

/// Provider pour les suggestions

abstract class _$SearchSuggestions extends $Notifier<List<SearchSuggestion>> {
  List<SearchSuggestion> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<SearchSuggestion>, List<SearchSuggestion>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SearchSuggestion>, List<SearchSuggestion>>,
              List<SearchSuggestion>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
