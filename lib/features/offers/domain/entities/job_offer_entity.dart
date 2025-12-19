import 'package:linkup_pro/features/offers/domain/entities/company_preview.dart';
import 'package:linkup_pro/features/offers/domain/entities/skill_requirement.dart';

/// Entity representing a job offer
class JobOfferEntity {
  final String id;
  final String title;
  final String description;
  final double? salary;
  final String employmentTypeId;
  final String employmentTypeName;
  final DateTime creationDate;
  final DateTime? expiryDate;
  final bool isActive;
  final CompanyPreview company;
  final List<SkillRequirement> requiredSkills;
  final int applicationsCount;
  final double? matchScore;
  final bool hasApplied;
  final bool isSaved;

  const JobOfferEntity({
    required this.id,
    required this.title,
    required this.description,
    this.salary,
    required this.employmentTypeId,
    required this.employmentTypeName,
    required this.creationDate,
    this.expiryDate,
    required this.isActive,
    required this.company,
    required this.requiredSkills,
    this.applicationsCount = 0,
    this.matchScore,
    this.hasApplied = false,
    this.isSaved = false,
  });

  factory JobOfferEntity.fromJson(Map<String, dynamic> json) {
    // Handle company - can be null in simplified responses
    final companyJson = json['company'] as Map<String, dynamic>?;
    final company = companyJson != null
        ? CompanyPreview.fromJson(companyJson)
        : const CompanyPreview(id: '', name: 'Entreprise');

    // Handle creationDate - can be 'creationDate' or 'postedDate'
    final dateString = json['creationDate'] as String? ??
        json['postedDate'] as String? ??
        DateTime.now().toIso8601String();

    return JobOfferEntity(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      salary: json['salary'] != null
          ? (json['salary'] as num).toDouble()
          : null,
      employmentTypeId:
          json['employmentTypeId'] as String? ??
          json['employmentType']?['id'] as String? ??
          '',
      employmentTypeName:
          json['type'] as String? ??
          json['type'] as String? ??
          '',
      creationDate: DateTime.parse(dateString),
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      company: company,
      requiredSkills:
          (json['requiredSkills'] as List<dynamic>?)
              ?.map((e) => SkillRequirement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      applicationsCount:
          json['_count']?['applications'] as int? ??
          json['applicationsCount'] as int? ??
          0,
      matchScore: json['matchScore'] != null
          ? (json['matchScore'] as num).toDouble()
          : null,
      hasApplied: json['hasApplied'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'salary': salary,
      'employmentTypeId': employmentTypeId,
      'creationDate': creationDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'isActive': isActive,
      'company': company.toJson(),
      'requiredSkills': requiredSkills.map((e) => e.toJson()).toList(),
      'applicationsCount': applicationsCount,
      'matchScore': matchScore,
      'hasApplied': hasApplied,
      'isSaved': isSaved,
    };
  }

  JobOfferEntity copyWith({
    String? id,
    String? title,
    String? description,
    double? salary,
    String? employmentTypeId,
    String? employmentTypeName,
    DateTime? creationDate,
    DateTime? expiryDate,
    bool? isActive,
    CompanyPreview? company,
    List<SkillRequirement>? requiredSkills,
    int? applicationsCount,
    double? matchScore,
    bool? hasApplied,
    bool? isSaved,
  }) {
    return JobOfferEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      salary: salary ?? this.salary,
      employmentTypeId: employmentTypeId ?? this.employmentTypeId,
      employmentTypeName: employmentTypeName ?? this.employmentTypeName,
      creationDate: creationDate ?? this.creationDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      company: company ?? this.company,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      applicationsCount: applicationsCount ?? this.applicationsCount,
      matchScore: matchScore ?? this.matchScore,
      hasApplied: hasApplied ?? this.hasApplied,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  /// Check if the offer is recommended (match score >= 50)
  bool get isRecommended => (matchScore ?? 0) >= 50;

  /// Check if the offer is expired
  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());

  @override
  String toString() {
    return 'JobOfferEntity(id: $id, title: $title, company: ${company.name})';
  }
}
