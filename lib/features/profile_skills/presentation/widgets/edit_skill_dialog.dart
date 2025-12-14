import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/profile_skills/data/entity/profile_skills_entity.dart';
import 'package:linkup_pro/features/profile_skills/data/models/competence_model.dart';
import 'package:linkup_pro/features/profile_skills/presentation/providers/profile_skills_provider.dart';

class EditSkillDialog extends ConsumerStatefulWidget {
  final CompetenceModel skill;

  const EditSkillDialog({super.key, required this.skill});

  @override
  ConsumerState<EditSkillDialog> createState() => _EditSkillDialogState();
}

class _EditSkillDialogState extends ConsumerState<EditSkillDialog> {
  late TextEditingController _nameController;
  String? _selectedCategory;
  String? _selectedLevelId;

  final List<String> _categories = [
    'Développement',
    'Design',
    'Marketing',
    'Gestion',
    'Communication',
    'Analyse',
    'Vente',
    'Support',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.skill.name);
    _selectedCategory = widget.skill.category;
    _selectedLevelId = widget.skill.levelId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'edit_skill'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'modify_skill_details'.tr(),
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildLevelDropdown(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'cancel'.tr(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _handleUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'modify'.tr(),
                      style: const TextStyle(fontSize: 15),
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

  Widget _buildNameField() {
    return TextField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      controller: _nameController,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: 'skill_name'.tr(),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        hintText: 'Ex: Flutter, Photoshop, SEO...',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: 'category_optional'.tr(),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      items: _categories.map((category) {
        return DropdownMenuItem<String>(value: category, child: Text(category));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }

  Widget _buildLevelDropdown() {
    final skillsState = ref.watch(profileSkillsProvider);
    final levels = skillsState.levels;

    return DropdownButtonFormField<String>(
      initialValue: _selectedLevelId,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: 'level'.tr(),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      items: levels.map((level) {
        return DropdownMenuItem<String>(
          value: level.id,
          child: Text(level.value.toLowerCase().tr()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLevelId = value;
        });
      },
    );
  }

  Future<void> _handleUpdate() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('skill_name_required'.tr()),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final updatedSkill = ProfileSkillsEntity(
      name: _nameController.text.trim(),
      category: _selectedCategory,
      levelId: _selectedLevelId,
    );

    final success = await ref
        .read(profileSkillsProvider.notifier)
        .updateSkill(widget.skill.id, updatedSkill);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('skill_updated_successfully'.tr()),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
