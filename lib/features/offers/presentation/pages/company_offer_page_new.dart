import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:linkup_pro/features/offers/domain/entities/job_offer_company.dart';
import 'package:linkup_pro/features/offers/presentation/providers/job_application_provider.dart';
import 'package:linkup_pro/features/offers/presentation/providers/job_offer_provider.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/application_card.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/application_detail_sheet.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/company_offer_card.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/company_offer_detail_sheet.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/company_offer_header.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/create_offer_sheet.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/edit_offer_sheet.dart';
import 'package:linkup_pro/features/offers/presentation/widgets/offer_common_widgets.dart';

class CompanyOfferPageNew extends ConsumerStatefulWidget {
  const CompanyOfferPageNew({super.key});

  @override
  ConsumerState<CompanyOfferPageNew> createState() =>
      _CompanyOfferPageNewState();
}

class _CompanyOfferPageNewState extends ConsumerState<CompanyOfferPageNew> {
  final _socketService = GetIt.I<SocketService>();
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _setupWebSocket();
  }

  void _fetchData() {
    Future.microtask(() {
      ref.read(companyJobOffersProvider.notifier).fetchOffers();
      ref.read(companyApplicationsProvider.notifier).fetchApplications();
    });
  }

  void _setupWebSocket() {
    _socketService.on('newJobApplication', (data) {
      if (data != null) {
        final application = JobApplicationEntity.fromJson(
          data as Map<String, dynamic>,
        );
        ref
            .read(companyApplicationsProvider.notifier)
            .addApplication(application);

        final currentOffer = ref
            .read(companyJobOffersProvider)
            .offers
            .where((o) => o.id == application.jobOfferId)
            .firstOrNull;

        if (currentOffer != null) {
          ref
              .read(companyJobOffersProvider.notifier)
              .updateApplicationsCount(
                application.jobOfferId,
                currentOffer.applicationsCount + 1,
              );
        }
      }
    });

    _socketService.on('applicationDeleted', (data) {
      if (data != null && data['applicationId'] != null) {
        ref
            .read(companyApplicationsProvider.notifier)
            .removeApplication(data['applicationId'] as String);
      }
    });

    _socketService.on('applicationCountUpdated', (data) {
      if (data != null) {
        ref
            .read(companyJobOffersProvider.notifier)
            .updateApplicationsCount(
              data['jobOfferId'] as String,
              data['applicationsCount'] as int,
            );
      }
    });
  }

  @override
  void dispose() {
    _socketService.off('newJobApplication');
    _socketService.off('applicationDeleted');
    _socketService.off('applicationCountUpdated');
    super.dispose();
  }

  void _showCreateOfferSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateOfferSheet(
        onCreated: () {
          GoRouter.of(context).pop();
          _showSuccessSnackbar('Offre créée avec succès');
        },
      ),
    );
  }

  void _showOfferDetail(JobOfferCompany offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CompanyOfferDetailSheet(
        offer: offer,
        onEdit: () => _showEditOfferSheet(offer),
        onDelete: () => _handleDeleteOffer(offer.id),
        onToggleActive: () => _handleToggleActive(offer),
      ),
    );
  }

  void _showEditOfferSheet(JobOfferCompany offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditOfferSheet(
        offer: offer,
        onUpdated: () {
          GoRouter.of(context).pop();
          _showSuccessSnackbar('Offre modifiée avec succès');
        },
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
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
            Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleDeleteOffer(String offerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'offre'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette offre ?'),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => GoRouter.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(companyJobOffersProvider.notifier)
          .deleteOffer(offerId);
      if (success && mounted) {
        _showSuccessSnackbar('Offre supprimée');
      }
    }
  }

  Future<void> _handleToggleActive(JobOfferCompany offer) async {
    await ref
        .read(companyJobOffersProvider.notifier)
        .updateOffer(id: offer.id, isActive: !offer.isActive);
  }

  Future<void> _handleUpdateApplicationStatus(
    String applicationId,
    String statusId,
  ) async {
    final success = await ref
        .read(companyApplicationsProvider.notifier)
        .updateStatus(applicationId: applicationId, statusId: statusId);
    
    if (success && mounted) {
      final statusLabel = switch (statusId) {
        'ACCEPTED' => 'acceptée',
        'REFUSED' => 'refusée',
        'IN_REVIEW' => 'mise en examen',
        _ => 'mise à jour',
      };
      _showSuccessSnackbar('Candidature $statusLabel');
    }
  }

  void _showApplicationDetail(JobApplicationEntity application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApplicationDetailSheet(
        application: application,
        onAccept: () => _handleUpdateApplicationStatus(application.id, 'ACCEPTED'),
        onReject: () => _handleUpdateApplicationStatus(application.id, 'REFUSED'),
        onReview: () => _handleUpdateApplicationStatus(application.id, 'IN_REVIEW'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFFAFAFA);
    final offersState = ref.watch(companyJobOffersProvider);
    final applicationsState = ref.watch(companyApplicationsProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark, offersState, applicationsState),
            const SizedBox(height: 16),
            CompanyTabSelector(
              selectedIndex: _selectedTab,
              onTabSelected: (index) => setState(() => _selectedTab = index),
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedTab == 0
                  ? _buildOffersTab(isDark, offersState)
                  : _buildApplicationsTab(isDark, applicationsState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    bool isDark,
    CompanyOffersState offersState,
    JobApplicationsState applicationsState,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: CompanyOffersHeader(
        offersCount: offersState.offers.length,

        isDark: isDark,
        onCreateOffer: _showCreateOfferSheet,
      ),
    );
  }

  Widget _buildOffersTab(bool isDark, CompanyOffersState state) {
    if (state.isLoading && state.offers.isEmpty) {
      return const OffersLoadingIndicator();
    }

    if (state.error != null && state.offers.isEmpty) {
      return OffersErrorWidget(
        message: state.error!,
        onRetry: () =>
            ref.read(companyJobOffersProvider.notifier).fetchOffers(),
        isDark: isDark,
      );
    }

    if (state.offers.isEmpty) {
      return OffersEmptyState(
        isDark: isDark,
        title: 'Aucune offre créée',
        subtitle: 'Créez votre première offre d\'emploi',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: state.offers.length,
      itemBuilder: (context, index) {
        final offer = state.offers[index];
        return CompanyOfferCard(
          offer: offer,
          isDark: isDark,
          onTap: () => _showOfferDetail(offer),
          onEdit: () => _showEditOfferSheet(offer),
          onDelete: () => _handleDeleteOffer(offer.id),
          onToggleActive: () => _handleToggleActive(offer),
        );
      },
    );
  }

  Widget _buildApplicationsTab(bool isDark, JobApplicationsState state) {
    if (state.isLoading && state.applications.isEmpty) {
      return const OffersLoadingIndicator();
    }

    if (state.error != null && state.applications.isEmpty) {
      return OffersErrorWidget(
        message: state.error!,
        onRetry: () =>
            ref.read(companyApplicationsProvider.notifier).fetchApplications(),
        isDark: isDark,
      );
    }

    if (state.applications.isEmpty) {
      return OffersEmptyState(
        isDark: isDark,
        title: 'Aucune candidature',
        subtitle: 'Les candidatures apparaîtront ici',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: state.applications.length,
      itemBuilder: (context, index) {
        final application = state.applications[index];
        return ApplicationCard(
          application: application,
          isDark: isDark,
          onTap: () => _showApplicationDetail(application),
          onAccept: () => _handleUpdateApplicationStatus(
            application.id,
            'ACCEPTED', 
          ),
          onReject: () => _handleUpdateApplicationStatus(
            application.id,
            'REFUSED', 
          ),
          onReview: () => _handleUpdateApplicationStatus(
            application.id,
            'IN_REVIEW',
          ),
        );
      },
    );
  }
}
