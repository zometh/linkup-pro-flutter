import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/domain/entities/job_offer_company.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Company's own job offer card
class CompanyOfferCard extends StatelessWidget {
  final JobOfferCompany offer;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  const CompanyOfferCard({
    super.key,
    required this.offer,
    required this.isDark,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
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
            color: offer.isActive
                ? (isDark ? Colors.white10 : const Color(0xFFEEEEEE))
                : Colors.orange.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildTitle(),
            const SizedBox(height: 12),
            _buildStats(),
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: offer.isActive
                    ? const Color(0xFF10B981).withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: offer.isActive
                          ? const Color(0xFF10B981)
                          : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    text: offer.isActive ? 'Active' : 'Inactive',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: offer.isActive
                        ? const Color(0xFF10B981)
                        : Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CustomText(
              text: offer.employmentTypeValue,
              fontSize: 12,
              color: isDark ? Colors.white54 : AppColors.textTertiary,
            ),
          ],
        ),
        CustomText(
          text: timeago.format(offer.postedDate, locale: 'fr_short'),
          fontSize: 11,
          color: isDark ? Colors.white38 : AppColors.textTertiary,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return CustomText(
      text: offer.title,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : AppColors.textPrimary,
      maxLines: 2,
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStat(
          Icons.people_outline,
          '${offer.applicationsCount} candidatures',
        ),
        const SizedBox(width: 16),
        if (offer.salary != null)
          _buildStat(Icons.payments_outlined, '${offer.salary!.toStringAsFixed(0)} FCFA'),
      ],
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: isDark ? Colors.white54 : AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        CustomText(
          text: text,
          fontSize: 12,
          color: isDark ? Colors.white54 : AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: offer.isActive ? Icons.pause : Icons.play_arrow,
            label: offer.isActive ? 'Désactiver' : 'Activer',
            onTap: onToggleActive,
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            icon: Icons.edit_outlined,
            label: 'Modifier',
            onTap: onEdit,
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 8),
        _buildIconButton(Icons.delete_outline, onDelete, Colors.red.shade400),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary
              : (isDark ? AppColors.darkInput : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isPrimary
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppColors.textSecondary),
            ),
            const SizedBox(width: 6),
            CustomText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isPrimary
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
