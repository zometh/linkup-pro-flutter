import 'package:linkup_pro/features/profile_skills/data/enums/competence_level.dart';

class CompetenceModel {
  final String id;
  final String name;
  final String? category;
  final String? levelId;
  final CompetenceLevel? level;
  final String profileId;

  CompetenceModel({
    required this.id,
    required this.name,
    this.category,
    this.levelId,
    this.level,
    required this.profileId,
  });

  factory CompetenceModel.fromJson(Map<String, dynamic> json) {
    print(json);
    CompetenceLevel? parsedLevel;
    if (json['level'] != null) {
      final levelValue = json['level'].toString().toLowerCase();
      try {
        parsedLevel = competenceLevelFromString(levelValue);
      } catch (e) {
        parsedLevel = null;
      }
    }

    return CompetenceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'],
      levelId: json['levelId'],
      level: parsedLevel,
      profileId: json['profileId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (category != null) 'category': category,
      if (levelId != null) 'levelId': levelId,
      'profileId': profileId,
    };
  }

  CompetenceModel copyWith({
    String? id,
    String? name,
    String? category,
    String? levelId,
    CompetenceLevel? level,
    String? profileId,
  }) {
    return CompetenceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      levelId: levelId ?? this.levelId,
      level: level ?? this.level,
      profileId: profileId ?? this.profileId,
    );
  }
}
