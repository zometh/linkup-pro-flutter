import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/domain/entities/job_offer.dart';
import 'package:timeago/timeago.dart' as timeago;

class OfferCard extends StatelessWidget {
  final JobOffer offer;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const OfferCard({
    super.key,
    required this.offer,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Logo
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDark
                          ? AppColors.darkInput
                          : AppColors.lightBackground,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: offer.companyLogo,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.business,
                            color: AppColors.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.business,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and Company
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: offer.title,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: offer.companyName,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  // Save Button
                  GestureDetector(
                    onTap: onSave,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: offer.isSaved
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : (isDark
                                  ? AppColors.darkInput
                                  : AppColors.lightBackground),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        offer.isSaved ? Icons.bookmark : Icons.bookmark_outline,
                        color: offer.isSaved
                            ? AppColors.primary
                            : (isDark
                                  ? Colors.white54
                                  : AppColors.textTertiary),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Location and Type Row
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.location_on_outlined,
                    text: offer.location,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    icon: Icons.work_outline,
                    text: offer.type,
                    isDark: isDark,
                    isHighlighted: offer.type == 'Remote',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Salary
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomText(
                  text: offer.salary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: offer.tags
                    .take(4)
                    .map((tag) => _buildTag(tag, isDark))
                    .toList(),
              ),
              const SizedBox(height: 14),
              // Posted time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isDark ? Colors.white38 : AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: timeago.format(offer.postedAt, locale: 'fr'),
                        fontSize: 12,
                        color: isDark ? Colors.white38 : AppColors.textTertiary,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const CustomText(
                      text: 'Postuler',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required bool isDark,
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: isHighlighted
              ? AppColors.success
              : (isDark ? Colors.white54 : AppColors.textSecondary),
        ),
        const SizedBox(width: 4),
        CustomText(
          text: text,
          fontSize: 13,
          color: isHighlighted
              ? AppColors.success
              : (isDark ? Colors.white54 : AppColors.textSecondary),
          fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildTag(String tag, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: CustomText(
        text: tag,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      ),
    );
  }
}
