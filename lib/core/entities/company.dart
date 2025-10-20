
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
  final bool isValidated;
  final String description;
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
    );
  }
}