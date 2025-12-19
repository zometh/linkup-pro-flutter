/*
{
    id: '6941c94cd56006ca7f1f734d',
    title: 'Développeur Flutter',
    description: 'test\ntest',
    salary: 600000,
    postedDate: 2025-12-16T21:04:12.016Z,
    expiryDate: null,
    isActive: true,
    applicationsCount: 0,

    employmentType: { id: '6941889b936fe93cb7fb7d0c', value: 'CDI' }
  }*/
class JobOfferCompany {
  final String id;
  final String title;
  final String description;
  final double? salary;
  final DateTime postedDate;
  final DateTime? expiryDate;
  final bool isActive;
  final int applicationsCount;
  final Map<String, dynamic> employmentType;

  const JobOfferCompany({
    required this.id,
    required this.title,
    required this.description,
    this.salary,
    required this.postedDate,
    this.expiryDate,
    required this.isActive,
    required this.applicationsCount,
    required this.employmentType,
  });

  /// Getter pour le type de contrat formaté
  String get employmentTypeValue => employmentType['value'] ?? '';

  JobOfferCompany copyWith({
    String? id,
    String? title,
    String? description,
    double? salary,
    DateTime? postedDate,
    DateTime? expiryDate,
    bool? isActive,
    int? applicationsCount,
    Map<String, dynamic>? employmentType,
  }) {
    return JobOfferCompany(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      salary: salary ?? this.salary,
      postedDate: postedDate ?? this.postedDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      applicationsCount: applicationsCount ?? this.applicationsCount,
      employmentType: employmentType ?? this.employmentType,
    );
  }

  factory JobOfferCompany.fromJson(Map<String, dynamic> json) {
    return JobOfferCompany(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      salary: json['salary'] != null
          ? (json['salary'] as num).toDouble()
          : null,
      postedDate: DateTime.parse(json['postedDate'] as String),
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      isActive: json['isActive'] as bool,
      applicationsCount: json['applicationsCount'] as int,
      employmentType: json['employmentType'] as Map<String, dynamic>? ?? {},
    );
  }
}
