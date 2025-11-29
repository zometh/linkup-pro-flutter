import 'package:linkup_pro/core/entities/user.dart';

class Company {
  final String id;
  final String name;
  final User user;
  final DateTime creationDate;
  final String website;
  final String logo;
  final String profileFileId;
  final String phone;
  final String size;
  final bool isValidated;
  final String description;
  final String sector;
  Company({
    required this.creationDate,
    required this.id,
    required this.name,
    required this.user,
    required this.website,
    required this.logo,
    required this.profileFileId,
    required this.phone,
    required this.isValidated,
    required this.description,
    required this.size,
    required this.sector,
  });
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      user: User.fromJson(json['user']),
      creationDate: DateTime.parse(json['creationDate']),
      website: json['website'],
      logo: json['logo'],
      profileFileId: json['profileFileId'],
      phone: json['phone'],
      isValidated: json['isValidated'],
      description: json['description'],
      size: json['size'],
      sector: json['sector'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user': user.toJson(),
      'creationDate': creationDate.toIso8601String(),
      'website': website,
      'logo': logo,
      'profileFileId': profileFileId,
      'phone': phone,
      'isValidated': isValidated,
      'description': description,
      'size': size,
      'sector': sector,
    };
  }

  @override
  String toString() {
    return 'Company(id: $id, name: $name, user: $user, creationDate: $creationDate, website: $website, logo: $logo, profileFileId: $profileFileId, phone: $phone, size: $size, isValidated: $isValidated, description: $description, sector: $sector)';
  }
}
