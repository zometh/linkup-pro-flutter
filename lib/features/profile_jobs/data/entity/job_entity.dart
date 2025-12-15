class JobEntity {
  final String? id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String? companyId;
  final String? temporaryCompanyName;

  JobEntity({
    this.id,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
    required this.isCurrent,
    this.companyId,
    this.temporaryCompanyName,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      'isCurrent': isCurrent,
      if (companyId != null && companyId!.isNotEmpty) 'companyId': companyId,
      if (temporaryCompanyName != null && temporaryCompanyName!.isNotEmpty)
        'temporaryCompanyName': temporaryCompanyName,
    };
  }

  factory JobEntity.fromJson(Map<String, dynamic> json) {
    return JobEntity(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrent: json['isCurrent'] ?? false,
      companyId: json['companyId'],
      temporaryCompanyName: json['temporaryCompanyName'],
    );
  }
}
