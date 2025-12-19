import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:linkup_pro/features/offers/presentation/providers/job_application_provider.dart';
import 'package:linkup_pro/features/offers/presentation/providers/job_offer_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Bottom sheet for job offer details
class OfferDetailSheetNew extends ConsumerStatefulWidget {
  final JobOfferEntity offer;
  final VoidCallback onApply;
  final VoidCallback onSave;

  const OfferDetailSheetNew({
    super.key,
    required this.offer,
    required this.onApply,
    required this.onSave,
  });

  @override
  ConsumerState<OfferDetailSheetNew> createState() =>
      _OfferDetailSheetNewState();
}

class _OfferDetailSheetNewState extends ConsumerState<OfferDetailSheetNew> {
  bool _isApplying = false;

  Future<void> _handleApply() async {
    setState(() => _isApplying = true);

    final result = await ref
        .read(memberApplicationsProvider.notifier)
        .applyToJob(jobOfferId: widget.offer.id);

    setState(() => _isApplying = false);

    if (result != null) {
      ref
          .read(targetedJobOffersProvider.notifier)
          .markAsApplied(widget.offer.id);
      widget.onApply();
    }
  }

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
                  _buildHeader(isDark),
                  const SizedBox(height: 24),
                  _buildInfoCards(isDark),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Description',
                    widget.offer.description,
                    isDark,
                  ),
                  if (widget.offer.requiredSkills.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSkillsSection(isDark),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildBottomBar(isDark),
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

  Widget _buildHeader(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: widget.offer.company.logo != null
                ? CachedNetworkImage(
                    imageUrl: widget.offer.company.logo!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const SizedBox(),
                    errorWidget: (_, __, ___) => Icon(
                      Icons.business,
                      color: isDark ? Colors.white24 : AppColors.textTertiary,
                      size: 28,
                    ),
                  )
                : Icon(
                    Icons.business,
                    color: isDark ? Colors.white24 : AppColors.textTertiary,
                    size: 28,
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: widget.offer.title,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              CustomText(
                text: widget.offer.company.name,
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  CustomText(
                    text: timeago.format(
                      widget.offer.creationDate,
                      locale: 'fr',
                    ),
                    fontSize: 12,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards(bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildInfoCard(
          Icons.work_outline,
          widget.offer.employmentTypeName,
          isDark,
        ),
        if (widget.offer.salary != null)
          _buildInfoCard(
            Icons.euro,
            '${widget.offer.salary!.toStringAsFixed(0)} FCFA/an',
            isDark,
          ),
        if (widget.offer.company.location != null)
          _buildInfoCard(
            Icons.location_on_outlined,
            widget.offer.company.location!,
            isDark,
          ),
        _buildInfoCard(
          Icons.people_outline,
          '${widget.offer.applicationsCount} candidatures',
          isDark,
        ),
        if (widget.offer.matchScore != null) _buildMatchScoreCard(isDark),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? Colors.white60 : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          CustomText(
            text: text,
            fontSize: 13,
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchScoreCard(bool isDark) {
    final score = widget.offer.matchScore!;
    final color = score >= 70
        ? const Color(0xFF10B981)
        : score >= 40
        ? Colors.orange
        : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 16, color: color),
          const SizedBox(width: 6),
          CustomText(
            text: '${score.toStringAsFixed(0)}% de correspondance',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: content,
          fontSize: 14,
          color: isDark ? Colors.white70 : AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildSkillsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Compétences requises',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.offer.requiredSkills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: skill.skillName,
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  if (skill.levelName != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CustomText(
                        text: skill.levelName!,
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isDark) {
    final hasApplied = widget.offer.hasApplied;

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
          GestureDetector(
            onTap: widget.onSave,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: widget.offer.isSaved
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : (isDark ? AppColors.darkInput : const Color(0xFFF5F5F5)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                widget.offer.isSaved ? Icons.bookmark : Icons.bookmark_outline,
                color: widget.offer.isSaved
                    ? AppColors.primary
                    : (isDark ? Colors.white60 : AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: hasApplied || _isApplying ? null : _handleApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasApplied
                    ? const Color(0xFF10B981)
                    : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: _isApplying
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      hasApplied ? 'Candidature envoyée ✓' : 'Postuler',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
