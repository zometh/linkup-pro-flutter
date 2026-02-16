import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/features/profile_skills/data/entity/profile_skills_entity.dart';
import 'package:linkup_pro/features/profile_skills/data/repos/profile_skills_repository.dart';

class ProfileSkillsRepositoryImpl implements ProfileSkillsRepository {
  final ApiClient apiClient = GetIt.instance.get<ApiClient>();

  @override
  Future<List<Map<String, dynamic>>> getProfileSkills(String userId) async {
    try {
      final response = await apiClient.get('/competences/my-skills/$userId');
      return response;
    } catch (e) {
      throw Exception('Failed to get skills: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSkillsByProfile(
    String profileId,
  ) async {
    try {
      final response = await apiClient.get('/competences/profile/$profileId');
      return response;
    } catch (e) {
      throw Exception('Failed to get skills: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> addSkill(ProfileSkillsEntity skill) async {
    try {
      final response = await apiClient.post(
        '/competences',
        data: skill.toJson(),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to add skill: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateSkill(
    String skillId,
    ProfileSkillsEntity skill,
  ) async {
    try {
      final response = await apiClient.put(
        '/competences/$skillId',
        skill.toJson(),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update skill: $e');
    }
  }

  @override
  Future<void> deleteSkill(String skillId) async {
    try {
      await apiClient.delete('/competences/$skillId');
    } catch (e) {
      throw Exception('Failed to delete skill: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompetenceLevels() async {
    try {
      final response = await apiClient.get('/competences/levels');
      return response;
    } catch (e) {
      throw Exception('Failed to get competence levels: $e');
    }
  }
}
