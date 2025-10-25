
import 'package:linkup_pro/core/entities/user.dart';
import 'package:linkup_pro/core/enums/user_visibility.dart';

class Member{
  final String id;
  final String? biography;
  final DateTime? birthDate;
  final String phone;
  final String? portfolio;
  final UserVisibility profileVisibility;
  final String? profileFileId;
  final String? photoUrl;
  final String sector;
  final User user;

  Member({
    required this.id,
    this.profileFileId,
    this.biography,
    this.birthDate,
    required this.phone,
    this.portfolio,
    this.photoUrl,
    required this.sector,
    this.profileVisibility = UserVisibility.public,
    required this.user,
  });

  factory Member.fromJson(Map<String, dynamic> json) {

    return Member(
      id: json['id'] as String,
      biography: json['biography'],
      phone: json['phone'],
      portfolio: json['portfolio'],
      photoUrl: json['photo'],
      birthDate: DateTime.tryParse(json['birthDate']),
      sector: json['sector'],
      profileFileId: json['profileFileId'],
      profileVisibility: json["visibility"] != null ? getVisibility(json["visibility"]) : UserVisibility.public,
      user: User.fromJson(json['user']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if(biography != null) 'biography': biography,
      if(birthDate != null) 'birthDate': birthDate!.toIso8601String(),
      'phone': phone,
      if(portfolio != null) 'portfolio': portfolio,
      if(photoUrl != null) 'photo': photoUrl,
      'sector': sector,
      if(profileFileId != null) 'profileFileId': profileFileId,
      'visibility': profileVisibility.toString().split('.').last,
      'user': user.toJson(),
    };
  }

}
