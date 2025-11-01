import 'package:linkup_pro/core/enums/user_role.dart';
import 'package:linkup_pro/features/posts/domain/entities/company_post.dart';
import 'package:linkup_pro/features/posts/domain/entities/member_post.dart';

class PostOwner {
  final UserRole role;
  final String id;
  final String? sector;
  final dynamic owner;

  PostOwner({
    required this.role,
    required this.id,
     this.sector,
    required this.owner,

  });

  factory PostOwner.fromJson(Map<String, dynamic> json) {
    return PostOwner(
      role: userRoleFromString(json['role']),
      id: json['id'],
      sector: json['sector'],
      owner: userRoleFromString(json['role']) == UserRole.member ? MemberPost.fromJson(json['data']) : CompanyPost.fromJson( json['data']),
    );
  }
}