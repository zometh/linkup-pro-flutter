class CompetenceLevelModel {
  final String id;
  final String type;
  final String value;
  final String? description;
  final bool active;

  CompetenceLevelModel({
    required this.id,
    required this.type,
    required this.value,
    this.description,
    required this.active,
  });

  factory CompetenceLevelModel.fromJson(Map<String, dynamic> json) {
    return CompetenceLevelModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      value: json['value'] ?? '',
      description: json['description'],
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'value': value,
      if (description != null) 'description': description,
      'active': active,
    };
  }
}
