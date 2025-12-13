import 'package:linkup_pro/features/profile_skills/data/enums/competence_level.dart';

class ProfileSkillsEntity {
  ProfileSkillsEntity({required this.name, this.category, this.level});
  final String name;
  final String? category;
  final CompetenceLevel? level;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (category != null) 'category': category,
      if (level != null)
        'level': level.toString().toLowerCase().split('.').last,
    };
  }
}
