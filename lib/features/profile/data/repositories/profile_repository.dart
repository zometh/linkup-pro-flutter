import 'dart:io';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/entities/company.dart';

abstract class ProfileRepository {
  Future<Member> updateMemberProfile({
    required String profileId,
    String? firstName,
    String? lastName,
    String? biography,
    String? phone,
    DateTime? birthDate,
    String? portfolio,
    String? address,
    File? photo,
  });

  Future<Company> updateCompanyProfile({
    required String companyId,
    String? name,
    String? description,
    String? website,
    String? phone,
    String? address,
    File? logo,
  });

  Future<Member> getMemberProfile(String profileId);
  Future<Company> getCompanyProfile(String companyId);
}
