import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/profile_skills/data/enums/competence_level.dart';

class LevelChip extends StatelessWidget {
  final CompetenceLevel level;

  const LevelChip({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final config = _getLevelConfig(level);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.color, width: 1),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _LevelConfig _getLevelConfig(CompetenceLevel level) {
    switch (level) {
      case CompetenceLevel.BEGINNER:
        return _LevelConfig(color: AppColors.warning, label: 'Débutant');
      case CompetenceLevel.INTERMEDIATE:
        return _LevelConfig(color: AppColors.info, label: 'Intermédiaire');
      case CompetenceLevel.EXPERT:
        return _LevelConfig(color: AppColors.success, label: 'Expert');
    }
  }
}

class _LevelConfig {
  final Color color;
  final String label;

  _LevelConfig({required this.color, required this.label});
}
