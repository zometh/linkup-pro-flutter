class JobModel {
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String profileId;
  final String? companyId;
  final String? temporaryCompanyName;
  final CompanyInfo? company;

  JobModel({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
    required this.isCurrent,
    required this.profileId,
    this.companyId,
    this.temporaryCompanyName,
    this.company,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrent: json['isCurrent'] ?? false,
      profileId: json['profileId'] ?? '',
      companyId: json['companyId'],
      temporaryCompanyName: json['temporaryCompanyName'],
      company: json['company'] != null
          ? CompanyInfo.fromJson(json['company'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      'isCurrent': isCurrent,
      'profileId': profileId,
      if (companyId != null) 'companyId': companyId,
      if (temporaryCompanyName != null)
        'temporaryCompanyName': temporaryCompanyName,
    };
  }

  JobModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrent,
    String? profileId,
    String? companyId,
    String? temporaryCompanyName,
    CompanyInfo? company,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      profileId: profileId ?? this.profileId,
      companyId: companyId ?? this.companyId,
      temporaryCompanyName: temporaryCompanyName ?? this.temporaryCompanyName,
      company: company ?? this.company,
    );
  }

  // Helper method to get company name
  String get companyName {
    if (company != null) {
      return company!.name;
    }
    return temporaryCompanyName ?? 'Entreprise inconnue';
  }

  // Helper method to check if has company logo
  bool get hasCompanyLogo {
    return company != null &&
        company!.logo != null &&
        company!.logo!.isNotEmpty;
  }
}

class CompanyInfo {
  final String id;
  final String name;
  final String? logo;

  CompanyInfo({required this.id, required this.name, this.logo});

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, if (logo != null) 'logo': logo};
  }
}
