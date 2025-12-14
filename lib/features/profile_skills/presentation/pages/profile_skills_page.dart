import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/profile_skills/presentation/providers/profile_skills_provider.dart';
import 'package:linkup_pro/features/profile_skills/presentation/widgets/empty_skills_view.dart';
import 'package:linkup_pro/features/profile_skills/presentation/widgets/error_skills_view.dart';
import 'package:linkup_pro/features/profile_skills/presentation/widgets/skill_card.dart';
import 'package:linkup_pro/features/profile_skills/presentation/widgets/add_skill_dialog.dart';
import 'package:linkup_pro/features/profile_skills/presentation/widgets/edit_skill_dialog.dart';
import 'package:linkup_pro/features/profile_skills/presentation/widgets/delete_skill_dialog.dart';

class ProfileSkillsPage extends ConsumerStatefulWidget {
  const ProfileSkillsPage({super.key});

  @override
  ConsumerState<ProfileSkillsPage> createState() => _ProfileSkillsPageState();
}

class _ProfileSkillsPageState extends ConsumerState<ProfileSkillsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileSkillsProvider.notifier).loadMySkills();
      ref.read(profileSkillsProvider.notifier).loadLevels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final skillsState = ref.watch(profileSkillsProvider);

    return _buildContent(skillsState);
  }

  Widget _buildContent(ProfileSkillsState skillsState) {
    if (skillsState.isLoading && skillsState.skills.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (skillsState.error != null && skillsState.skills.isEmpty) {
      return ErrorSkillsView(
        onRetry: () => ref.read(profileSkillsProvider.notifier).loadMySkills(),
      );
    }

    if (skillsState.skills.isEmpty) {
      return EmptySkillsView(onAddSkill: _showAddDialog);
    }

    return Column(
      children: [
        Align(
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
            itemCount: skillsState.skills.length,
            itemBuilder: (context, index) {
              final skill = skillsState.skills[index];
              return SkillCard(
                skill: skill,
                onEdit: () => _showEditDialog(skill),
                onDelete: () => _showDeleteDialog(skill.id),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddDialog() {
    showDialog(context: context, builder: (context) => const AddSkillDialog());
  }

  void _showEditDialog(skill) {
    showDialog(
      context: context,
      builder: (context) => EditSkillDialog(skill: skill),
    );
  }

  void _showDeleteDialog(String skillId) {
    showDialog(
      context: context,
      builder: (context) => DeleteSkillDialog(skillId: skillId),
    );
  }
}
