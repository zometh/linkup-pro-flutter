import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/profile_jobs/presentation/providers/profile_jobs_provider.dart';
import 'package:linkup_pro/features/profile_jobs/presentation/widgets/job_card.dart';
import 'package:linkup_pro/features/profile_jobs/presentation/pages/add_job_page.dart';
import 'package:linkup_pro/features/profile_jobs/presentation/pages/edit_job_page.dart';
import 'package:linkup_pro/features/profile_jobs/presentation/widgets/delete_job_dialog.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class ProfileJobsPage extends ConsumerStatefulWidget {
  final bool isOwnProfile;
  final String userId;
  const ProfileJobsPage({super.key, required this.isOwnProfile, required this.userId});

  @override
  ConsumerState<ProfileJobsPage> createState() => _ProfileJobsPageState();
}

class _ProfileJobsPageState extends ConsumerState<ProfileJobsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileJobsProvider.notifier).loadMyJobs(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobsState = ref.watch(profileJobsProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return _buildContent(jobsState, isDarkMode, widget.isOwnProfile);
  }

  Widget _buildContent(ProfileJobsState jobsState, bool isDarkMode, bool isOwnProfile) {
    if (jobsState.isLoading && jobsState.jobs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (jobsState.error != null && jobsState.jobs.isEmpty) {
      return _buildErrorView(isDarkMode);
    }

    if (jobsState.jobs.isEmpty) {
      return _buildEmptyView(isDarkMode, isOwnProfile);
    }

    return Column(
      children: [
        if(isOwnProfile)Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8, right: 13),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            itemCount: jobsState.jobs.length,
            itemBuilder: (context, index) {
              final job = jobsState.jobs[index];
              return JobCard(
                job: job,
                onEdit: () => _showEditDialog(job),
                onDelete: () => _showDeleteDialog(job.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyView(bool isDarkMode, bool isOwnProfile) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.work_off_outlined,
                size: 80,
                color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              CustomText(
                text: 'Aucune expérience professionnelle',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              const SizedBox(height: 8),
              if(isOwnProfile)CustomText(
                text: 'Ajoutez votre première expérience professionnelle',
                fontSize: 14,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
             if(isOwnProfile) ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter une expérience'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(bool isDarkMode) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: AppColors.error),
              const SizedBox(height: 16),
              CustomText(
                text: 'Erreur de chargement',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: 'Une erreur est survenue lors du chargement',
                fontSize: 14,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    ref.read(profileJobsProvider.notifier).loadMyJobs(widget.userId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDialog() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddJobPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _showEditDialog(job) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditJobPage(job: job),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _showDeleteDialog(String jobId) {
    showDialog(
      context: context,
      builder: (context) => DeleteJobDialog(jobId: jobId),
    );
  }
}
