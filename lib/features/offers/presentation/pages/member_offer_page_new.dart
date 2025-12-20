import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:linkup_pro/features/offers/presentation/providers/job_application_provider.dart';
import 'package:linkup_pro/features/offers/presentation/providers/job_offer_provider.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/member_application_card.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/member_offer_appbar.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/offer_common_widgets.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/offer_search_filter.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/offer_tile_widget.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/recommended_offer_card.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/offer_detail_sheet_new.dart';

class MemberOfferPageNew extends ConsumerStatefulWidget {
  const MemberOfferPageNew({super.key});

  @override
  ConsumerState<MemberOfferPageNew> createState() => _MemberOfferPageNewState();
}

class _MemberOfferPageNewState extends ConsumerState<MemberOfferPageNew>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _applicationsScrollController = ScrollController();
  final _socketService = GetIt.I<SocketService>();
  late TabController _tabController;

  String _selectedFilter = 'Tous';
  String _searchQuery = '';
  bool _showSavedOnly = false;
  bool _isSearchMode = false;
  String _selectedApplicationFilter = 'Tous';

  final List<String> _filters = ['Tous', 'Remote', 'CDI', 'CDD', 'Stage'];
  final List<String> _applicationFilters = [
    'Tous',
    'En attente',
    'Acceptée',
    'En examen',
    'Refusée',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _fetchOffers();
    _setupWebSocket();
    _scrollController.addListener(_onScroll);
    _applicationsScrollController.addListener(_onApplicationsScroll);
  }

  void _onTabChanged() {
    if (_tabController.index == 1) {
      // Fetch applications when switching to applications tab
      ref.read(memberApplicationsProvider.notifier).fetchApplications();
    }
  }

  void _onApplicationsScroll() {
    if (_applicationsScrollController.position.pixels >=
        _applicationsScrollController.position.maxScrollExtent - 200) {
      final state = ref.read(memberApplicationsProvider);
      if (!state.isLoading && state.hasMore) {
        ref.read(memberApplicationsProvider.notifier).loadMore();
      }
    }
  }

  void _fetchOffers() {
    Future.microtask(() {
      ref.read(targetedJobOffersProvider.notifier).fetchOffers();
    });
  }

  void _performSearch(String query) {
    if (query.trim().length >= 2) {
      setState(() => _isSearchMode = true);
      ref.read(searchJobOffersProvider.notifier).search(query: query);
    } else if (query.isEmpty) {
      setState(() => _isSearchMode = false);
      ref.read(searchJobOffersProvider.notifier).clear();
    }
  }

  void _setupWebSocket() {
    _socketService.on('newJobOffer', (data) {
      if (data != null) {
        final offer = JobOfferEntity.fromJson(data as Map<String, dynamic>);
        ref.read(targetedJobOffersProvider.notifier).addOffer(offer);
      }
    });

    _socketService.on('jobOfferUpdated', (data) {
      if (data != null) {
        final offer = JobOfferEntity.fromJson(data as Map<String, dynamic>);
        ref.read(targetedJobOffersProvider.notifier).updateOffer(offer);
      }
    });

    _socketService.on('jobOfferDeleted', (data) {
      if (data != null && data['jobOfferId'] != null) {
        ref
            .read(targetedJobOffersProvider.notifier)
            .removeOffer(data['jobOfferId'] as String);
      }
    });

    // Listen for application status updates
    _socketService.on('applicationStatusUpdated', (data) {
      if (data != null) {
        final application = JobApplicationEntity.fromJson(
          data as Map<String, dynamic>,
        );
        ref
            .read(memberApplicationsProvider.notifier)
            .updateApplicationStatus(application);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_isSearchMode) {
        final searchState = ref.read(searchJobOffersProvider);
        if (!searchState.isLoading && searchState.hasMore) {
          ref.read(searchJobOffersProvider.notifier).loadMore();
        }
      } else {
        final state = ref.read(targetedJobOffersProvider);
        if (!state.isLoading && state.hasMore) {
          ref.read(targetedJobOffersProvider.notifier).loadMore();
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _applicationsScrollController.dispose();
    _tabController.dispose();
    _socketService.off('newJobOffer');
    _socketService.off('jobOfferUpdated');
    _socketService.off('jobOfferDeleted');
    _socketService.off('applicationStatusUpdated');
    super.dispose();
  }

  List<JobOfferEntity> _filterOffers(List<JobOfferEntity> offers) {
    var filtered = offers;
    if (_showSavedOnly) {
      filtered = filtered.where((o) => o.isSaved).toList();
    }
    if (_selectedFilter != 'Tous') {
      filtered = filtered
          .where(
            (o) => o.employmentTypeName.toLowerCase().contains(
              _selectedFilter.toLowerCase(),
            ),
          )
          .toList();
    }
    return filtered;
  }

  void _toggleSave(String offerId) {
    HapticFeedback.lightImpact();
    ref.read(targetedJobOffersProvider.notifier).toggleSaved(offerId);
  }

  void _showOfferDetail(JobOfferEntity offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OfferDetailSheetNew(
        offer: offer,
        onApply: () {
          Navigator.pop(context);
          _showSuccessSnackbar();
        },
        onSave: () => _toggleSave(offer.id),
      ),
    );
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            const Text(
              'Candidature envoyée avec succès',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFFAFAFA);

    // Get appropriate state based on search mode
    final offersState = ref.watch(targetedJobOffersProvider);
    final searchState = ref.watch(searchJobOffersProvider);
    final applicationsState = ref.watch(memberApplicationsProvider);

    // Use search results or targeted offers
    final currentOffers = _isSearchMode
        ? searchState.offers
        : offersState.offers;
    final filteredOffers = _filterOffers(currentOffers);
    final recommendedOffers = _isSearchMode
        ? <JobOfferEntity>[]
        : filteredOffers.where((o) => o.isRecommended).toList();
    final otherOffers = _isSearchMode
        ? filteredOffers
        : filteredOffers.where((o) => !o.isRecommended).toList();

    final isLoading = _isSearchMode
        ? searchState.isLoading
        : offersState.isLoading;
    final error = _isSearchMode ? searchState.error : offersState.error;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _buildHeader(
            isDark,
            filteredOffers.length,
            applicationsState.applications.length,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [

                _buildOffersTab(
                  isDark,
                  isLoading,
                  error,
                  currentOffers.isEmpty,
                  filteredOffers,
                  recommendedOffers,
                  otherOffers,
                ),

                _buildApplicationsTab(isDark, applicationsState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, int offersCount, int applicationsCount) {
    final savedCount = ref
        .watch(targetedJobOffersProvider)
        .offers
        .where((o) => o.isSaved)
        .length;

    return Container(
      color: isDark ? AppColors.darkBackground : Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: MemberOffersHeader(
                offersCount: offersCount,
                isDark: isDark,
                trailing: SavedOffersButton(
                  savedCount: savedCount,
                  showSavedOnly: _showSavedOnly,
                  onTap: () => setState(() => _showSavedOnly = !_showSavedOnly),
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildTabBar(isDark, applicationsCount),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(bool isDark, int applicationsCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? Colors.white60 : AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.all(4),
        tabs: [
          const Tab(text: 'Offres'),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Mes candidatures'),
                if (applicationsCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _tabController.index == 1
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$applicationsCount',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _tabController.index == 1
                            ? Colors.white
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersTab(
    bool isDark,
    bool isLoading,
    String? error,
    bool isEmpty,
    List<JobOfferEntity> filtered,
    List<JobOfferEntity> recommended,
    List<JobOfferEntity> others,
  ) {
    return Column(
      children: [
        // Search and filters
        Container(
          color: isDark ? AppColors.darkBackground : Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            children: [
              OfferSearchField(
                controller: _searchController,
                searchQuery: _searchQuery,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                  _performSearch(value);
                },
                onClear: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _isSearchMode = false;
                  });
                  ref.read(searchJobOffersProvider.notifier).clear();
                },
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: OfferFilterTabs(
                  filters: _filters,
                  selectedFilter: _selectedFilter,
                  onFilterSelected: (filter) =>
                      setState(() => _selectedFilter = filter),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
        // Offers list
        Expanded(
          child: _buildOffersBody(
            isDark,
            isLoading,
            error,
            isEmpty,
            filtered,
            recommended,
            others,
          ),
        ),
      ],
    );
  }

  Widget _buildOffersBody(
    bool isDark,
    bool isLoading,
    String? error,
    bool isEmpty,
    List<JobOfferEntity> filtered,
    List<JobOfferEntity> recommended,
    List<JobOfferEntity> others,
  ) {
    if (isLoading && isEmpty) {
      return const OffersLoadingIndicator();
    }

    if (error != null && isEmpty) {
      return OffersErrorWidget(
        message: error,
        onRetry: _isSearchMode
            ? () => _performSearch(_searchQuery)
            : _fetchOffers,
        isDark: isDark,
      );
    }

    if (filtered.isEmpty) {
      return OffersEmptyState(
        isDark: isDark,
        title: _isSearchMode ? 'Aucun résultat' : 'Aucune offre trouvée',
        subtitle: _isSearchMode
            ? 'Aucune offre ne correspond à "$_searchQuery"'
            : 'Modifiez vos filtres ou votre recherche',
        onReset: () {
          setState(() {
            _selectedFilter = 'Tous';
            _searchQuery = '';
            _searchController.clear();
            _showSavedOnly = false;
            _isSearchMode = false;
          });
          ref.read(searchJobOffersProvider.notifier).clear();
          _fetchOffers();
        },
      );
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      children: [
        // Show search results header when in search mode
        if (_isSearchMode) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${ref.watch(searchJobOffersProvider).total} résultat(s) pour "$_searchQuery"',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ),
        ],
        if (recommended.isNotEmpty && !_isSearchMode) ...[
          OfferSectionHeader(
            title: 'Recommandées pour vous',
            isDark: isDark,
            showBadge: true,
            badgeText: 'Pour vous',
            badgeIcon: Icons.auto_awesome,
          ),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recommended.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => RecommendedOfferCard(
                offer: recommended[index],
                isDark: isDark,
                onTap: () => _showOfferDetail(recommended[index]),
                onSave: () => _toggleSave(recommended[index].id),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (others.isNotEmpty) ...[
          if (!_isSearchMode)
            OfferSectionHeader(title: 'Toutes les offres', isDark: isDark),
          ...others.map(
            (o) => OfferTileWidget(
              offer: o,
              isDark: isDark,
              onTap: () => _showOfferDetail(o),
              onSave: () => _toggleSave(o.id),
            ),
          ),
        ],
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildApplicationsTab(bool isDark, JobApplicationsState state) {
    return Column(
      children: [

        Container(
          color: isDark ? AppColors.darkBackground : Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _applicationFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _applicationFilters[index];
                final isSelected = _selectedApplicationFilter == filter;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedApplicationFilter = filter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                                ? AppColors.darkCard
                                : const Color(0xFFF5F5F5)),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: isDark
                                  ? Colors.white10
                                  : const Color(0xFFEEEEEE),
                            ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? Colors.white70
                                  : AppColors.textSecondary),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Applications list
        Expanded(child: _buildApplicationsList(isDark, state)),
      ],
    );
  }

  List<JobApplicationEntity> _filterApplications(
    List<JobApplicationEntity> applications,
  ) {
    if (_selectedApplicationFilter == 'Tous') return applications;

    return applications.where((app) {
      switch (_selectedApplicationFilter) {
        case 'En attente':
          return app.status == ApplicationStatus.pending;
        case 'Acceptée':
          return app.status == ApplicationStatus.accepted;
        case 'En examen':
          return app.status == ApplicationStatus.inReview;
        case 'Refusée':
          return app.status == ApplicationStatus.refused;
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildApplicationsList(bool isDark, JobApplicationsState state) {
    if (state.isLoading && state.applications.isEmpty) {
      return const OffersLoadingIndicator();
    }

    if (state.error != null && state.applications.isEmpty) {
      return OffersErrorWidget(
        message: state.error!,
        onRetry: () =>
            ref.read(memberApplicationsProvider.notifier).fetchApplications(),
        isDark: isDark,
      );
    }

    final filteredApplications = _filterApplications(state.applications);

    if (filteredApplications.isEmpty) {
      return _buildEmptyApplicationsState(isDark);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(memberApplicationsProvider.notifier).fetchApplications();
      },
      child: ListView.builder(
        controller: _applicationsScrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: filteredApplications.length + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == filteredApplications.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final application = filteredApplications[index];
          return MemberApplicationCard(
            application: application,
            isDark: isDark,
            onTap: () => _showApplicationDetail(application),
            onCancel: application.canCancel
                ? () => _cancelApplication(application)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildEmptyApplicationsState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCard
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work_outline,
                size: 48,
                color: isDark ? Colors.white38 : AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            CustomText(
              text: _selectedApplicationFilter == 'Tous'
                  ? 'Aucune candidature'
                  : 'Aucune candidature $_selectedApplicationFilter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: _selectedApplicationFilter == 'Tous'
                  ? 'Vous n\'avez pas encore postulé à une offre.\nDécouvrez les offres disponibles !'
                  : 'Modifiez vos filtres pour voir d\'autres candidatures.',
              fontSize: 14,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_selectedApplicationFilter == 'Tous')
              ElevatedButton.icon(
                onPressed: () => _tabController.animateTo(0),
                icon: const Icon(Icons.search, size: 20),
                label: const Text('Explorer les offres'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            else
              TextButton(
                onPressed: () =>
                    setState(() => _selectedApplicationFilter = 'Tous'),
                child: const Text('Voir toutes les candidatures'),
              ),
          ],
        ),
      ),
    );
  }

  void _showApplicationDetail(JobApplicationEntity application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ApplicationDetailSheet(
        application: application,
        onCancel: application.canCancel
            ? () {
                Navigator.pop(context);
                _cancelApplication(application);
              }
            : null,
      ),
    );
  }

  Future<void> _cancelApplication(JobApplicationEntity application) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la candidature'),
        content: Text(
          'Voulez-vous vraiment annuler votre candidature pour "${application.jobOffer?.title ?? 'ce poste'}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(memberApplicationsProvider.notifier)
          .deleteApplication(application.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Candidature annulée' : 'Erreur lors de l\'annulation',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}

/// Bottom sheet to show application details
class _ApplicationDetailSheet extends StatelessWidget {
  final JobApplicationEntity application;
  final VoidCallback? onCancel;

  const _ApplicationDetailSheet({required this.application, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final jobOffer = application.jobOffer;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Status badge
                _buildStatusSection(isDark),
                const SizedBox(height: 20),

                // Job info
                if (jobOffer != null) ...[
                  _buildJobSection(isDark, jobOffer),
                  const SizedBox(height: 20),
                ],

                // Application date
                _buildDateSection(isDark),
                const SizedBox(height: 20),

                // Cover letter
                if (application.coverLetter != null &&
                    application.coverLetter!.isNotEmpty) ...[
                  _buildCoverLetterSection(isDark),
                  const SizedBox(height: 20),
                ],

                // Response message
                if (application.responseMessage != null &&
                    application.responseMessage!.isNotEmpty) ...[
                  _buildResponseSection(isDark),
                  const SizedBox(height: 20),
                ],

                // Actions
                if (onCancel != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text('Annuler ma candidature'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusSection(bool isDark) {
    Color statusColor;
    IconData statusIcon;

    switch (application.status) {
      case ApplicationStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
      case ApplicationStatus.accepted:
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle;
        break;
      case ApplicationStatus.refused:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case ApplicationStatus.inReview:
        statusColor = Colors.blue;
        statusIcon = Icons.visibility;
        break;
      case ApplicationStatus.canceled:
        statusColor = Colors.grey;
        statusIcon = Icons.block;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Statut de la candidature',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: application.status.displayName,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobSection(bool isDark, JobOfferEntity jobOffer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.business,
                  color: isDark ? Colors.white38 : AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: jobOffer.title,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                    CustomText(
                      text: jobOffer.company.name,
                      fontSize: 14,
                      color: isDark ? Colors.white60 : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.location_on_outlined,
            jobOffer.company.location ?? 'Non spécifié',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.work_outline,
            jobOffer.employmentTypeName,
            isDark,
          ),
          if (jobOffer.salary != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.payments_outlined,
              '${jobOffer.salary!.toStringAsFixed(0)} FCFA',
              isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white54 : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomText(
            text: text,
            fontSize: 14,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection(bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 18,
          color: isDark ? Colors.white54 : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        CustomText(
          text:
              'Candidature envoyée le ${_formatDate(application.applicationDate)}',
          fontSize: 14,
          color: isDark ? Colors.white70 : AppColors.textPrimary,
        ),
      ],
    );
  }

  Widget _buildCoverLetterSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: 18,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            CustomText(
              text: 'Lettre de motivation',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkInput : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomText(
            text: application.coverLetter!,
            fontSize: 14,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildResponseSection(bool isDark) {
    Color responseColor;
    String responseTitle;

    if (application.status == ApplicationStatus.accepted) {
      responseColor = const Color(0xFF10B981);
      responseTitle = 'Réponse de l\'entreprise';
    } else if (application.status == ApplicationStatus.refused) {
      responseColor = Colors.red;
      responseTitle = 'Réponse de l\'entreprise';
    } else {
      responseColor = Colors.blue;
      responseTitle = 'Message de l\'entreprise';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: responseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: responseColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.message_outlined, size: 18, color: responseColor),
              const SizedBox(width: 8),
              CustomText(
                text: responseTitle,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: responseColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomText(
            text: application.responseMessage!,
            fontSize: 14,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
          if (application.responseDate != null) ...[
            const SizedBox(height: 8),
            CustomText(
              text: 'Reçu le ${_formatDate(application.responseDate!)}',
              fontSize: 12,
              color: isDark ? Colors.white38 : AppColors.textTertiary,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
