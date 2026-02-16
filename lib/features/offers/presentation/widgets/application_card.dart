import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Application card for company view
class ApplicationCard extends StatelessWidget {
  final JobApplicationEntity application;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onReview;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.isDark,
    required this.onTap,
    required this.onAccept,
    required this.onReject,
    required this.onReview,
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildJobInfo(),
            if (application.coverLetter != null &&
                application.coverLetter!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildCoverLetterPreview(),
            ],
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 12),
        Expanded(child: _buildApplicantInfo()),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: application.applicant?.profilePicture != null
            ? CachedNetworkImage(
                imageUrl: application.applicant!.profilePicture!,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(),
                errorWidget: (_, __, ___) => _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      Icons.person,
      color: isDark ? Colors.white24 : AppColors.textTertiary,
      size: 24,
    );
  }

  Widget _buildApplicantInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: application.applicant?.fullName ?? 'Candidat',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        if (application.applicant?.title != null)
          CustomText(
            text: application.applicant!.title!,
            fontSize: 12,
            color: isDark ? Colors.white54 : AppColors.textSecondary,
          ),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 12,
              color: isDark ? Colors.white38 : AppColors.textTertiary,
            ),
            const SizedBox(width: 4),
            CustomText(
              text: timeago.format(application.applicationDate, locale: 'fr'),
              fontSize: 11,
              color: isDark ? Colors.white38 : AppColors.textTertiary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    switch (application.status) {
      case ApplicationStatus.pending:
        statusColor = Colors.orange;
        break;
      case ApplicationStatus.accepted:
        statusColor = const Color(0xFF10B981);
        break;
      case ApplicationStatus.refused:
        statusColor = Colors.red;
        break;
      case ApplicationStatus.inReview:
        statusColor = Colors.blue;
        break;
      case ApplicationStatus.canceled:
        statusColor = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomText(
        text: application.status.displayName,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: statusColor,
      ),
    );
  }

  Widget _buildJobInfo() {
    if (application.jobOffer == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.work_outline,
            size: 16,
            color: isDark ? Colors.white54 : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(
              text: application.jobOffer!.title,
              fontSize: 13,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverLetterPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.article_outlined,
                size: 14,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              CustomText(
                text: 'Lettre de motivation',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            text: application.coverLetter!,
            fontSize: 13,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (application.status != ApplicationStatus.pending &&
        application.status != ApplicationStatus.inReview) {
      return const SizedBox();
    }

    return Row(
      children: [
        if (application.status == ApplicationStatus.pending) ...[
          Expanded(
            child: _buildActionButton(
              'En examen',
              Icons.visibility,
              Colors.blue,
              onReview,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: _buildActionButton(
            'Accepter',
            Icons.check,
            const Color(0xFF10B981),
            onAccept,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            'Refuser',
            Icons.close,
            Colors.red,
            onReject,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            CustomText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
