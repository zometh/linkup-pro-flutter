import 'package:linkup_pro/features/profile_skills/data/entity/profile_skills_entity.dart';

abstract class ProfileSkillsRepository {
  Future<List<Map<String, dynamic>>> getMySkills();
  Future<List<Map<String, dynamic>>> getSkillsByProfile(String profileId);
  Future<Map<String, dynamic>> addSkill(ProfileSkillsEntity skill);
  Future<Map<String, dynamic>> updateSkill(
    String skillId,
    ProfileSkillsEntity skill,
  );
  Future<void> deleteSkill(String skillId);
  Future<List<Map<String, dynamic>>> getCompetenceLevels();
}
