/// Preview of a company for job offers
class CompanyPreview {
  final String id;
  final String name;
  final String? logo;
  final String? sector;
  final String? location;

  const CompanyPreview({
    required this.id,
    required this.name,
    this.logo,
    this.sector,
    this.location,
  });

  factory CompanyPreview.fromJson(Map<String, dynamic> json) {
    return CompanyPreview(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      sector: json['sector'] is Map
          ? json['sector']['name'] as String?
          : json['sector'] as String?,
      location:
          json['user']?['address'] as String? ?? json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'sector': sector,
      'location': location,
    };
  }

  @override
  String toString() => 'CompanyPreview(id: $id, name: $name)';
}
