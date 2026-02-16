import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';

/// Recommended job offer card (horizontal scroll)
class RecommendedOfferCard extends StatelessWidget {
  final JobOfferEntity offer;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const RecommendedOfferCard({
    super.key,
    required this.offer,
    required this.isDark,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            _buildHeader(),
            const SizedBox(height: 10),
            _buildTitle(),
            const Spacer(),
            _buildTags(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildCompanyLogo(),
        const SizedBox(width: 10),
        Expanded(child: _buildCompanyInfo()),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: offer.company.logo != null
            ? CachedNetworkImage(
                imageUrl: offer.company.logo!,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(),
                errorWidget: (_, __, ___) => _buildDefaultIcon(),
              )
            : _buildDefaultIcon(),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Icon(
      Icons.business,
      color: isDark ? Colors.white24 : AppColors.textTertiary,
      size: 18,
    );
  }

  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: offer.company.name,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white60 : AppColors.textSecondary,
        ),
        if (offer.company.location != null)
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 11,
                color: isDark ? Colors.white38 : AppColors.textTertiary,
              ),
              const SizedBox(width: 2),
              Expanded(
                child: CustomText(
                  text: offer.company.location!,
                  fontSize: 11,
                  color: isDark ? Colors.white38 : AppColors.textTertiary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onSave();
      },
      child: Icon(
        offer.isSaved ? Icons.bookmark : Icons.bookmark_outline,
        color: offer.isSaved
            ? AppColors.primary
            : (isDark ? Colors.white38 : AppColors.textTertiary),
        size: 18,
      ),
    );
  }

  Widget _buildTitle() {
    return CustomText(
      text: offer.title,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : AppColors.textPrimary,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTags() {
    return Row(
      children: [
        if (offer.salary != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomText(
              text: '${offer.salary!.toStringAsFixed(0)} FCFA',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomText(
            text: offer.employmentTypeName,
            fontSize: 10,
            color: isDark ? Colors.white60 : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
