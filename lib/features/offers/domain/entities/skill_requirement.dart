/// Skill requirement for a job offer
class SkillRequirement {
  final String skillId;
  final String skillName;
  final String? levelId;
  final String? levelName;
  final bool isRequired;

  const SkillRequirement({
    required this.skillId,
    required this.skillName,
    this.levelId,
    this.levelName,
    this.isRequired = true,
  });

  factory SkillRequirement.fromJson(Map<String, dynamic> json) {
    return SkillRequirement(
      skillId:
          json['skillId'] as String? ?? json['skill']?['id'] as String? ?? '',
      skillName:
          json['skill']?['name'] as String? ??
          json['skillName'] as String? ??
          '',
      levelId: json['levelId'] as String?,
      levelName:
          json['level']?['name'] as String? ?? json['levelName'] as String?,
      isRequired: json['isRequired'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillId': skillId,
      'skillName': skillName,
      'levelId': levelId,
      'levelName': levelName,
      'isRequired': isRequired,
    };
  }

  @override
  String toString() =>
      'SkillRequirement(skillId: $skillId, skillName: $skillName)';
}
