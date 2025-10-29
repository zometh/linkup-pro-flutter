class CompanyPost {
  final String name;
  final String logo;

  CompanyPost({
    required this.name,
    required this.logo,
  });

  factory CompanyPost.fromJson(Map<String, dynamic> json) {
    return CompanyPost(
      name: json['name'],
      logo: json['logo'],
    );
  }
}
