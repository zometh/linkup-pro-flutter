import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/profile_jobs/presentation/providers/profile_jobs_provider.dart';

class DeleteJobDialog extends ConsumerWidget {
  final String jobId;

  const DeleteJobDialog({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDarkMode ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: CustomText(
        text: 'Supprimer l\'expérience',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      content: CustomText(
        text:
            'Êtes-vous sûr de vouloir supprimer cette expérience professionnelle ?',
        fontSize: 14,
        color: isDarkMode ? Colors.white70 : Colors.black87,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: CustomText(
            text: 'Annuler',
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final success = await ref
                .read(profileJobsProvider.notifier)
                .deleteJob(jobId);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Expérience supprimée avec succès'
                        : 'Erreur lors de la suppression',
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}
