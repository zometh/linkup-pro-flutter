import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ApplicationDetailSheet extends StatelessWidget {
  final JobApplicationEntity application;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onReview;

  const ApplicationDetailSheet({
    super.key,
    required this.application,
    required this.onAccept,
    required this.onReject,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHandle(isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isDark),
                  const SizedBox(height: 24),
                  _buildApplicantInfo(isDark, context),
                  const SizedBox(height: 24),
                  if (application.jobOffer != null) ...[
                    _buildJobOfferInfo(isDark),
                    const SizedBox(height: 24),
                  ],
                  if (application.resumeUrl != null &&
                      application.resumeUrl!.isNotEmpty) ...[
                    _buildResumeSection(context, isDark),
                    const SizedBox(height: 24),
                  ],
                  if (application.coverLetter != null &&
                      application.coverLetter!.isNotEmpty) ...[
                    _buildCoverLetterSection(isDark),
                    const SizedBox(height: 24),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (application.isPending) _buildBottomBar(context, isDark),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? Colors.white24 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Détails de la candidature',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
              const SizedBox(height: 4),
              CustomText(
                text: 'Reçue ${timeago.format(application.applicationDate, locale: 'fr')}',
                fontSize: 13,
                color: isDark ? Colors.white54 : AppColors.textTertiary,
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildStatusBadge(isDark),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => GoRouter.of(context).pop(),
              icon: Icon(
                Icons.close,
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isDark) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomText(
        text: application.status.displayName,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: statusColor,
      ),
    );
  }

  Widget _buildApplicantInfo(bool isDark, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go("/user/${application.applicant?.id}");
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _buildAvatar(isDark),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: application.applicant?.fullName ?? 'Candidat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  if (application.applicant?.title != null) ...[
                    const SizedBox(height: 4),
                    CustomText(
                      text: application.applicant!.title!,
                      fontSize: 13,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ],
                  if (application.applicant?.email != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: isDark ? Colors.white54 : AppColors.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: CustomText(
                            text: application.applicant!.email!,
                            fontSize: 12,
                            color: isDark ? Colors.white54 : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isDark) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: application.applicant?.profilePicture != null
            ? CachedNetworkImage(
                imageUrl: application.applicant!.profilePicture!,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(),
                errorWidget: (_, __, ___) => _buildDefaultAvatar(isDark),
              )
            : _buildDefaultAvatar(isDark),
      ),
    );
  }

  Widget _buildDefaultAvatar(bool isDark) {
    return Icon(
      Icons.person,
      color: isDark ? Colors.white24 : AppColors.textTertiary,
      size: 30,
    );
  }

  Widget _buildJobOfferInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Poste concerné',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : AppColors.textSecondary,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.work_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: application.jobOffer!.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                    if (application.jobOffer!.company.name.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      CustomText(
                        text: application.jobOffer!.company.name,
                        fontSize: 12,
                        color: isDark ? Colors.white54 : AppColors.textTertiary,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResumeSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'CV / Curriculum Vitae',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : AppColors.textSecondary,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _openResume(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'CV du candidat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        text: 'Appuyez pour ouvrir',
                        fontSize: 12,
                        color: isDark ? Colors.white54 : AppColors.textTertiary,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  color: isDark ? Colors.white54 : AppColors.textTertiary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openResume(BuildContext context) async {
    if (application.resumeUrl == null) return;

    final uri = Uri.parse(application.resumeUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir le CV'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCoverLetterSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_outlined,
              size: 18,
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            CustomText(
              text: 'Lettre de motivation',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
            ),
          ),
          child: CustomText(
            text: application.coverLetter!,
            fontSize: 14,
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Reject button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                GoRouter.of(context).pop();
                onReject();
              },
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Refuser'),
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
          const SizedBox(width: 10),
          // Review button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                GoRouter.of(context).pop();
                onReview();
              },
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('Examiner'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Accept button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                GoRouter.of(context).pop();
                onAccept();
              },
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Accepter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

