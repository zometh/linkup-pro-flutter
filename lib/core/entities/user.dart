
import 'package:linkup_pro/core/enums/user_role.dart';

class User {
  final String email;
  final String password;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? address;
  final UserRole role;

  final String? id;

  User({
    required this.email,
    required this.password,
    required this.username,
    this.firstName,
    this.lastName,
    this.address,
    required this.role,

    this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      address: json['address'],
      role: json['role'] != null ? userRoleFromString(json["role"]) : UserRole.member,

      password: json['password'] ?? ''
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
