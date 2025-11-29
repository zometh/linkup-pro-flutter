import 'package:linkup_pro/core/enums/user_role.dart';

class User {
  final String email;
  final String password;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? address;
  final UserRole role;
  final DateTime? registrationDate;
  final String? id;
  int? followers;
  int? following;

  User({
    required this.email,
    required this.password,
    required this.username,
    this.firstName,
    this.lastName,
    this.address,
    required this.role,
    this.registrationDate,
    this.id,
    this.followers = 0,
    this.following = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      address: json['address'],
      role: json['role'] != null
          ? userRoleFromString(json["role"])
          : UserRole.member,
      registrationDate: json['registrationDate'] != null
          ? DateTime.tryParse(json['registrationDate'])
          : DateTime.now(),
      password: json['password'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'username': username,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (address != null) 'address': address,
      'role': role.toString().split('.').last.toUpperCase(),
    };
  }
}
