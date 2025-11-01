/*
{
username: jairo.pfannerstill,
role: ENTREPRISE,
followersCount: 0,
followingCount: 0,
biography: null,
portfolio: null, c
ompanyDescription:
Vestibulum morbi blandit cursus risus.
}
 */
import 'package:linkup_pro/core/enums/user_role.dart';
class UserPreviewAdds {
  final String username;
  final UserRole role;
  final int followersCount;
  final int followingCount;
  final String? biography;
  final String? portfolio;
  final String? companyDescription;

  UserPreviewAdds({
    required this.username,
    required this.role,
    required this.followersCount,
    required this.followingCount,
    this.biography,
    this.portfolio,
    this.companyDescription,
  });

  factory UserPreviewAdds.fromJson(Map<String, dynamic> json) {

    return UserPreviewAdds(
      username: json['username'],
      role: userRoleFromString(json['role']),
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
      biography: json['biography'],
      portfolio: json['portfolio'],
      companyDescription: json['companyDescription'],
    );
  }
}