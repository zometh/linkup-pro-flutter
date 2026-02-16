import 'package:linkup_pro/features/profile_skills/data/enums/competence_level.dart';

class ProfileSkillsEntity {
  ProfileSkillsEntity({
    required this.name,
    this.category,
    this.level,
    this.levelId,
  });

  final String name;
  final String? category;
  final CompetenceLevel? level;
  final String? levelId;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (category != null) 'category': category,
      if (levelId != null) 'levelId': levelId,
      if (level != null && levelId == null)
        'level': level.toString().toLowerCase().split('.').last,
    };
  }
}
