import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/search/domain/entities/search_entities.dart';
import 'package:linkup_pro/features/search/presentation/providers/search_provider.dart';
import 'package:linkup_pro/features/search/presentation/widgets/search_bar_widget.dart';
import 'package:linkup_pro/features/search/presentation/widgets/search_result_cards.dart';
import 'package:linkup_pro/features/search/presentation/widgets/search_states.dart';
import 'package:linkup_pro/features/search/presentation/widgets/search_suggestions_overlay.dart';
import 'package:linkup_pro/features/search/presentation/widgets/search_type_filters.dart';

class SearchHome extends ConsumerStatefulWidget {
  const SearchHome({super.key});

  @override
  ConsumerState<SearchHome> createState() => _SearchHomeState();
}

class _SearchHomeState extends ConsumerState<SearchHome> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && _searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(searchSuggestionsProvider.notifier).getSuggestions(value);
    setState(() {
      _showSuggestions = value.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _focusNode.unfocus();
      setState(() => _showSuggestions = false);
      ref.read(searchProvider.notifier).search(query);
    }
  }

  void _onSuggestionTap(SearchSuggestion suggestion) {
    _focusNode.unfocus();
    setState(() => _showSuggestions = false);

    switch (suggestion.type) {
      case 'people':
      case 'company':
        context.push('/user/${suggestion.id}');
        break;
      case 'job':
        context.push('/job/${suggestion.id}');
        break;
      default:
        _searchController.text = suggestion.text;
        _performSearch();
    }
  }

  void _onClear() {
    _searchController.clear();
    ref.read(searchProvider.notifier).clear();
    ref.read(searchSuggestionsProvider.notifier).clear();
    setState(() => _showSuggestions = false);
  }

  void _onCancel() {
    _focusNode.unfocus();
    setState(() => _showSuggestions = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchState = ref.watch(searchProvider);
    final suggestions = ref.watch(searchSuggestionsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Barre de recherche
            SearchBarWidget(
              controller: _searchController,
              focusNode: _focusNode,
              isDark: isDark,
              onChanged: _onSearchChanged,
              onSubmitted: _performSearch,
              onClear: _onClear,
              onCancel: _onCancel,
            ),

            // Filtres par type
            if (searchState.query.isNotEmpty && !_showSuggestions)
              SearchTypeFilters(
                searchState: searchState,
                isDark: isDark,
                onTypeSelected: (type) {
                  ref.read(searchProvider.notifier).changeType(type);
                },
              ),

            // Contenu principal
            Expanded(
              child: Stack(
                children: [
                  _buildContent(isDark, searchState),

                  // Suggestions overlay
                  if (_showSuggestions && suggestions.isNotEmpty)
                    SearchSuggestionsOverlay(
                      suggestions: suggestions,
                      isDark: isDark,
                      onSuggestionTap: _onSuggestionTap,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark, SearchState searchState) {
    if (searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.error != null) {
      return SearchErrorState(
        isDark: isDark,
        error: searchState.error!,
        onRetry: _performSearch,
      );
    }

    if (searchState.query.isEmpty) {
      return SearchEmptyState(isDark: isDark);
    }

    if (searchState.results.isEmpty) {
      return SearchNoResultsState(isDark: isDark, query: searchState.query);
    }

    return _buildResultsList(isDark, searchState);
  }

  Widget _buildResultsList(bool isDark, SearchState searchState) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200) {
          ref.read(searchProvider.notifier).loadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: searchState.results.length + (searchState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == searchState.results.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final result = searchState.results[index];
          return _buildResultCard(isDark, result);
        },
      ),
    );
  }

  Widget _buildResultCard(bool isDark, SearchResult result) {
    switch (result.type) {
      case 'people':
        return InkWell(
          onTap: () {
            context.push('/user/${result.id}');
          },
          child: SearchPersonCard(result: result, isDark: isDark),
        );
      case 'company':
        return SearchCompanyCard(result: result, isDark: isDark);
      case 'post':
        return SearchPostCard(result: result, isDark: isDark);
      case 'job':
        return SearchJobCard(result: result, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }
}
