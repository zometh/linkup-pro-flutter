import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/profile_jobs/data/models/job_model.dart';

class JobCard extends StatefulWidget {
  final JobModel job;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const JobCard({
    super.key,
    required this.job,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  String _formatDateRange() {
    final dateFormat = DateFormat('MMM yyyy', 'fr');
    final start = dateFormat.format(widget.job.startDate);
    final end = widget.job.isCurrent
        ? 'Présent'
        : dateFormat.format(widget.job.endDate!);
    return '$start - $end';
  }

  String _calculateDuration() {
    final endDate = widget.job.isCurrent ? DateTime.now() : widget.job.endDate!;
    final duration = endDate.difference(widget.job.startDate);
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;

    if (years > 0 && months > 0) {
      return '$years ${years > 1 ? 'ans' : 'an'} $months mois';
    } else if (years > 0) {
      return '$years ${years > 1 ? 'ans' : 'an'}';
    } else if (months > 0) {
      return '$months mois';
    } else {
      return '< 1 mois';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
              ),
            ),
            child: widget.job.hasCompanyLogo
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.job.company?.logo ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.business,
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                          size: 28,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.business,
                    color: isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                    size: 28,
                  ),
          ),
          title: CustomText(
            text: widget.job.title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              CustomText(
                text: widget.job.companyName,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: isDarkMode
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: CustomText(
                      text: _formatDateRange(),
                      fontSize: 13,
                      color: isDarkMode
                          ? Colors.grey.shade500
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: '(${_calculateDuration()})',
                    fontSize: 12,
                    color: isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade500,
                  ),
                ],
              ),
              if (widget.job.isCurrent) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: 'Poste actuel',
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
          trailing: PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              size: 20,
            ),
            color: isDarkMode ? AppColors.darkSurface : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'modify'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                onTap: () => Future.delayed(Duration.zero, widget.onEdit),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'delete'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                onTap: () => Future.delayed(Duration.zero, widget.onDelete),
              ),
            ],
          ),
          children: [
            if (widget.job.description != null &&
                widget.job.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey.shade800.withOpacity(0.3)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          text: 'Description',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade800,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: widget.job.description!,
                      fontSize: 13,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.event,
                    label: 'Début',
                    value: DateFormat(
                      'dd MMM yyyy',
                      'fr',
                    ).format(widget.job.startDate),
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.event_available,
                    label: widget.job.isCurrent ? 'Actuel' : 'Fin',
                    value: widget.job.isCurrent
                        ? 'En cours'
                        : DateFormat(
                            'dd MMM yyyy',
                            'fr',
                          ).format(widget.job.endDate!),
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey.shade800.withOpacity(0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              CustomText(
                text: label,
                fontSize: 11,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
            ],
          ),
          const SizedBox(height: 4),
          CustomText(
            text: value,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ],
      ),
    );
  }
}
