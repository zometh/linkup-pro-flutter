import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/profile_skills/data/entity/profile_skills_entity.dart';
import 'package:linkup_pro/features/profile_skills/data/models/competence_level_model.dart';
import 'package:linkup_pro/features/profile_skills/data/models/competence_model.dart';
import 'package:linkup_pro/features/profile_skills/data/repos/profile_skills_repository.dart';
import 'package:linkup_pro/features/profile_skills/data/repos_implements/profile_skills_repository_impl.dart';

class ProfileSkillsState {
  final List<CompetenceModel> skills;
  final List<CompetenceLevelModel> levels;
  final bool isLoading;
  final String? error;

  ProfileSkillsState({
    this.skills = const [],
    this.levels = const [],
    this.isLoading = false,
    this.error,
  });

  ProfileSkillsState copyWith({
    List<CompetenceModel>? skills,
    List<CompetenceLevelModel>? levels,
    bool? isLoading,
    String? error,
  }) {
    return ProfileSkillsState(
      skills: skills ?? this.skills,
      levels: levels ?? this.levels,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ProfileSkillsNotifier extends Notifier<ProfileSkillsState> {
  final ProfileSkillsRepository _repository = ProfileSkillsRepositoryImpl();

  @override
  ProfileSkillsState build() {
    return ProfileSkillsState();
  }

  Future<void> loadMySkills() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getMySkills();
      final skills = response
          .map((json) => CompetenceModel.fromJson(json))
          .toList();
      state = state.copyWith(skills: skills, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(skills: [], isLoading: false, error: e.toString());
    }
  }

  Future<void> loadSkills(String profileId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getSkillsByProfile(profileId);
      final skills = response
          .map((json) => CompetenceModel.fromJson(json))
          .toList();
      state = state.copyWith(skills: skills, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(skills: [], isLoading: false, error: e.toString());
    }
  }

  Future<void> loadLevels() async {
    try {
      final response = await _repository.getCompetenceLevels();
      final levels = response
          .map((json) => CompetenceLevelModel.fromJson(json))
          .toList();
      state = state.copyWith(levels: levels);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<bool> addSkill(ProfileSkillsEntity skill) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.addSkill(skill);
      final newSkill = CompetenceModel.fromJson(response);
      final updatedSkills = [...state.skills, newSkill];
      state = state.copyWith(
        skills: updatedSkills,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateSkill(String skillId, ProfileSkillsEntity skill) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.updateSkill(skillId, skill);
      final updatedSkill = CompetenceModel.fromJson(response);
      final updatedSkills = state.skills.map((s) {
        return s.id == skillId ? updatedSkill : s;
      }).toList();
      state = state.copyWith(
        skills: updatedSkills,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteSkill(String skillId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteSkill(skillId);
      final updatedSkills = state.skills
          .where((skill) => skill.id != skillId)
          .toList();
      state = state.copyWith(
        skills: updatedSkills,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final profileSkillsProvider =
    NotifierProvider<ProfileSkillsNotifier, ProfileSkillsState>(
      ProfileSkillsNotifier.new,
    );
