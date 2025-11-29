import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/data/mock_offers.dart';
import 'package:linkup_pro/features/offers/domain/entities/job_offer.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/offer_detail_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

class OffersHome extends StatefulWidget {
  const OffersHome({super.key});

  @override
  State<OffersHome> createState() => _OffersHomeState();
}

class _OffersHomeState extends State<OffersHome> {
  String _selectedFilter = 'Tous';
  String _searchQuery = '';
  List<JobOffer> _offers = List.from(mockJobOffers);
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showSavedOnly = false;

  final List<String> _filters = ['Tous', 'Remote', 'Full-time', 'Hybrid'];

  List<JobOffer> get _savedOffers => _offers.where((o) => o.isSaved).toList();

  List<JobOffer> get _recommendedOffers {
    return _filteredOffers.where((o) => o.isRecommended).toList();
  }

  List<JobOffer> get _otherOffers {
    return _filteredOffers.where((o) => !o.isRecommended).toList();
  }

  List<JobOffer> get _filteredOffers {
    final baseList = _showSavedOnly ? _savedOffers : _offers;
    return baseList.where((offer) {
      final matchesFilter =
          _selectedFilter == 'Tous' || offer.type == _selectedFilter;
      final matchesSearch =
          _searchQuery.isEmpty ||
          offer.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          offer.companyName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _toggleSave(String offerId) {
    HapticFeedback.lightImpact();
    final index = _offers.indexWhere((o) => o.id == offerId);
    setState(() {
      _offers[index] = _offers[index].copyWith(
        isSaved: !_offers[index].isSaved,
      );
    });
  }

  void _showOfferDetail(JobOffer offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OfferDetailSheet(
        offer: offer,
        onApply: () {
          Navigator.pop(context);
          _showSuccessSnackbar();
        },
        onSave: () {
          _toggleSave(offer.id);
          Navigator.pop(context);
        },
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
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: bgColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(isDark),
        ],
        body: _filteredOffers.isEmpty
            ? _buildEmptyState(isDark)
            : ListView(
                padding: const EdgeInsets.only(top: 8, bottom: 100),
                children: [
                  // Section Recommandées (horizontal)
                  if (_recommendedOffers.isNotEmpty) ...[
                    _buildSectionHeader('Recommandées pour vous', isDark),
                    SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _recommendedOffers.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return _buildRecommendedCard(
                            _recommendedOffers[index],
                            isDark,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Section Autres offres
                  if (_otherOffers.isNotEmpty) ...[
                    _buildSectionHeader('Toutes les offres', isDark),
                    ..._otherOffers.map((o) => _buildOfferTile(o, isDark)),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 185,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      CustomText(
                        text: 'Offres d\'emploi',
                        fontSize: 24,
                        fontWeight: .w700,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: '${_filteredOffers.length} opportunités',
                        fontSize: 14,
                        color: isDark
                            ? Colors.white54
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildSavedButton(isDark),
                      const SizedBox(width: 8),
                      _buildNotificationButton(isDark),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSearchField(isDark),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Container(
          height: 37,
          alignment: Alignment.centerLeft,
          child: _buildFilterTabs(isDark),
        ),
      ),
    );
  }

  Widget _buildSavedButton(bool isDark) {
    final savedCount = _savedOffers.length;
    return GestureDetector(
      onTap: () => setState(() => _showSavedOnly = !_showSavedOnly),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _showSavedOnly
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _showSavedOnly ? Icons.bookmark : Icons.bookmark_outline,
              color: _showSavedOnly
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppColors.textSecondary),
              size: 18,
            ),
            if (savedCount > 0) ...[
              const SizedBox(width: 4),
              CustomText(
                text: '$savedCount',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _showSavedOnly
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Badge(
        smallSize: 6,
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.notifications_none,
          color: isDark ? Colors.white70 : AppColors.textSecondary,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return Row(
      spacing: 3,
      children: [
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : const Color(0xFFF3F4F6),
              borderRadius: .circular(10),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : AppColors.textTertiary,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white38 : AppColors.textTertiary,
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: Icon(
                          Icons.close,
                          color: isDark
                              ? Colors.white38
                              : AppColors.textTertiary,
                          size: 18,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        Container(
          height: 46,
          width: 46,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            FontAwesomeIcons.filterCircleXmark,
            color: Colors.white,
            size: 17,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(bool isDark) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filters.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final filter = _filters[index];
        final isSelected = _selectedFilter == filter;

        return GestureDetector(
          onTap: () => setState(() => _selectedFilter = filter),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkCard : Colors.white),
              borderRadius: BorderRadius.circular(30),
              border: isSelected
                  ? null
                  : Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                    ),
            ),
            child: CustomText(
              text: filter,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppColors.textSecondary),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          CustomText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          if (title.contains('Recommandées')) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 12, color: AppColors.primary),
                  const SizedBox(width: 4),
                  CustomText(
                    text: 'Pour vous',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendedCard(JobOffer offer, bool isDark) {
    return GestureDetector(
      onTap: () => _showOfferDetail(offer),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkInput
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: offer.companyLogo,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const SizedBox(),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.business,
                        color: isDark ? Colors.white24 : AppColors.textTertiary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: offer.companyName,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white60
                            : AppColors.textSecondary,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 11,
                            color: isDark
                                ? Colors.white38
                                : AppColors.textTertiary,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: CustomText(
                              text: offer.location,
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white38
                                  : AppColors.textTertiary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleSave(offer.id),
                  child: Icon(
                    offer.isSaved ? Icons.bookmark : Icons.bookmark_outline,
                    color: offer.isSaved
                        ? AppColors.primary
                        : (isDark ? Colors.white38 : AppColors.textTertiary),
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomText(
              text: offer.title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomText(
                    text: offer.salary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomText(
                    text: offer.type,
                    fontSize: 10,
                    color: isDark ? Colors.white60 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferTile(JobOffer offer, bool isDark) {
    return GestureDetector(
      onTap: () => _showOfferDetail(offer),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkInput
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: offer.companyLogo,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const SizedBox(),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.business,
                        color: isDark ? Colors.white24 : AppColors.textTertiary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: offer.companyName,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white60
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: isDark
                                ? Colors.white38
                                : AppColors.textTertiary,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: CustomText(
                              text: offer.location,
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white38
                                  : AppColors.textTertiary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleSave(offer.id),
                  child: Icon(
                    offer.isSaved ? Icons.bookmark : Icons.bookmark_outline,
                    color: offer.isSaved
                        ? AppColors.primary
                        : (isDark ? Colors.white38 : AppColors.textTertiary),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomText(
              text: offer.title,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildTag(offer.type, isDark),
                const SizedBox(width: 6),
                _buildTag(offer.salary, isDark, isPrimary: true),
                const Spacer(),
                CustomText(
                  text: timeago.format(offer.postedAt, locale: 'fr_short'),
                  fontSize: 11,
                  color: isDark ? Colors.white38 : AppColors.textTertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, bool isDark, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primary.withValues(alpha: 0.1)
            : (isDark ? Colors.white10 : const Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomText(
        text: text,
        fontSize: 11,
        fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
        color: isPrimary
            ? AppColors.primary
            : (isDark ? Colors.white60 : AppColors.textSecondary),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off_outlined,
              size: 56,
              color: isDark ? Colors.white24 : AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            CustomText(
              text: 'Aucune offre trouvée',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: 'Modifiez vos filtres ou votre recherche',
              fontSize: 13,
              color: isDark ? Colors.white38 : AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'Tous';
                  _searchQuery = '';
                  _searchController.clear();
                  _showSavedOnly = false;
                });
              },
              child: const Text('Réinitialiser'),
            ),
          ],
        ),
      ),
    );
  }
}
