import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_button.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/features/report/domain/entity/report.dart';
import 'package:linkup_pro/features/report/domain/enums/report_content_type.dart';
import 'package:linkup_pro/features/report/presentation/providers/report_page.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/widgets/custom_toast.dart';

class ReportPage extends ConsumerStatefulWidget {
  final ReportContentType reportType;
  final String? publicationId;
  final String? commentId;
  final String? userId;

  const ReportPage({
    super.key,
    required this.reportType,
    this.publicationId,
    this.commentId,
    this.userId,
  });

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  String? selectedReason;
  final TextEditingController _descriptionController = TextEditingController();

  final List<Map<String, dynamic>> reportReasons = [
    {'key': 'spam', 'icon': Icons.report_gmailerrorred},
    {'key': 'harassment', 'icon': Icons.person_off},
    {'key': 'hate_speech', 'icon': Icons.sentiment_very_dissatisfied},
    {'key': 'violence', 'icon': Icons.dangerous},
    {'key': 'inappropriate_content', 'icon': Icons.warning},
    {'key': 'false_information', 'icon': Icons.fact_check},
    {'key': 'copyright_violation', 'icon': Icons.copyright},
    {'key': 'other_reason', 'icon': Icons.more_horiz},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(reportPageProviderProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return isLoading ?
        const CustomProgress()
    :Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.lightBorder,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: isDarkMode ? Colors.white : AppColors.textPrimary,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'report_content'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getContentTypeText(),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bannière d'information
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.error.withValues(alpha: 0.1),
                            AppColors.error.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.error,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Aidez-nous à maintenir une communauté respectueuse',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDarkMode ? Colors.white.withValues(alpha: 0.9) : AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Titre de la section
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'report_reason'.tr(),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grille des raisons
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: reportReasons.length,
                      itemBuilder: (context, index) {
                        final reason = reportReasons[index];
                        final isSelected = selectedReason == reason['key'];

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedReason = reason['key'];
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppGradients.primaryGradient
                                  : null,
                              color: !isSelected
                                  ? isDarkMode ? AppColors.darkCard : Colors.white
                                  : null,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : isDarkMode
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : AppColors.lightBorder,
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  reason['icon'],
                                  color: isSelected
                                      ? Colors.white
                                      : isDarkMode
                                          ? Colors.white70
                                          : AppColors.primary,
                                  size: 28,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  reason['key'].toString().tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : isDarkMode
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // Description optionnelle
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'describe_issue'.tr(),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.08)
                              : AppColors.lightBorder,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        maxLength: 200,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'add_more_details'.tr(),
                          hintStyle: TextStyle(
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.3)
                                : AppColors.textTertiary,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          counterStyle: TextStyle(
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.5)
                                : AppColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bouton de soumission
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: CustomButton(
                text: 'submit'.tr(),
                onPressed: _submitReport,
                height: 54,
                borderRadius: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _submitReport() async{
    if (selectedReason == null) {

      showToast(description: 'select_report_reason'.tr(),
          type: ToastificationType.error
      );
      return;
    }
    final reportImplement = ref.read(reportPageProviderProvider.notifier);
    final report = Report(
        reason: selectedReason!,
        contentType: widget.reportType, userId: widget.userId, publicationId: widget.publicationId, commentId: widget.commentId, details: _descriptionController.text.trim());
    final response  = await reportImplement.createReport(report);
    if(response == null) {


      showToast(description: 'report_error'.tr(),
      type: ToastificationType.error
      );
      return;
    }
    showToast(description: 'report_submitted'.tr(),
        type: ToastificationType.info
    );


    Navigator.pop(context);
  }

  String _getContentTypeText() {
    switch (widget.reportType) {
      case ReportContentType.publication:
        return 'post'.tr();
      case ReportContentType.comment:
        return 'comment'.tr();
      case ReportContentType.user:
        return 'profile'.tr();
    }
  }
}
