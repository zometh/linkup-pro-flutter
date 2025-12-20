import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:timeago/timeago.dart' as timeago;

class MemberApplicationCard extends StatelessWidget {
  final JobApplicationEntity application;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onCancel;

  const MemberApplicationCard({
    super.key,
    required this.application,
    required this.isDark,
    required this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildJobDetails(),
            const SizedBox(height: 12),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildCompanyLogo(),
        const SizedBox(width: 12),
        Expanded(child: _buildJobInfo()),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildCompanyLogo() {
    final company = application.jobOffer?.company;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: company?.logo != null
            ? CachedNetworkImage(
                imageUrl: company!.logo!,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(),
                errorWidget: (_, __, ___) => _buildDefaultLogo(),
              )
            : _buildDefaultLogo(),
      ),
    );
  }

  Widget _buildDefaultLogo() {
    return Icon(
      Icons.business,
      color: isDark ? Colors.white24 : AppColors.textTertiary,
      size: 24,
    );
  }

  Widget _buildJobInfo() {
    final jobOffer = application.jobOffer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: jobOffer?.title ?? 'Poste',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        CustomText(
          text: jobOffer?.company.name ?? 'Entreprise',
          fontSize: 13,
          color: isDark ? Colors.white60 : AppColors.textSecondary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: statusColor),
          const SizedBox(width: 4),
          CustomText(
            text: application.status.displayName,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetails() {
    final jobOffer = application.jobOffer;
    if (jobOffer == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            Icons.location_on_outlined,
            jobOffer.company.location ?? 'Non spécifié',
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            Icons.work_outline,
            jobOffer.employmentTypeName.toLowerCase().tr(),
          ),
          if (jobOffer.salary != null) ...[
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.payments_outlined,
              '${jobOffer.salary!.toStringAsFixed(0)} FCFA',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? Colors.white54 : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomText(
            text: text,
            fontSize: 13,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: isDark ? Colors.white38 : AppColors.textTertiary,
        ),
        const SizedBox(width: 4),
        CustomText(
          text:
              'Postulé ${timeago.format(application.applicationDate, locale: 'fr', allowFromNow: false)}',
          fontSize: 12,
          color: isDark ? Colors.white38 : AppColors.textTertiary,
        ),
        const Spacer(),
        if (application.canCancel && onCancel != null)
          GestureDetector(
            onTap: onCancel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.close, size: 14, color: Colors.red),
                  const SizedBox(width: 4),
                  CustomText(
                    text: 'Annuler',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        if (application.responseMessage != null &&
            application.responseMessage!.isNotEmpty)
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.message_outlined,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  CustomText(
                    text: 'Voir réponse',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
