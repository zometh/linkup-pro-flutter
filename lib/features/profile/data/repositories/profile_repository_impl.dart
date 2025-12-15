import 'dart:io';
import 'package:dio/dio.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/features/profile/data/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepositoryImpl(this._apiClient);

  @override
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
  }) async {
    final formData = FormData();

    if (firstName != null)
      formData.fields.add(MapEntry('firstName', firstName));
    if (lastName != null) formData.fields.add(MapEntry('lastName', lastName));
    if (biography != null)
      formData.fields.add(MapEntry('biography', biography));
    if (phone != null) formData.fields.add(MapEntry('phone', phone));
    if (birthDate != null) {
      formData.fields.add(MapEntry('birthDate', birthDate.toIso8601String()));
    }
    if (portfolio != null)
      formData.fields.add(MapEntry('portfolio', portfolio));
    if (address != null) formData.fields.add(MapEntry('address', address));

    if (photo != null) {
      formData.files.add(
        MapEntry(
          'photo',
          await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
        ),
      );
    }

    final response = await _apiClient.put('/profiles/$profileId', formData);

    return Member.fromJson(response);
  }

  @override
  Future<Company> updateCompanyProfile({
    required String companyId,
    String? name,
    String? description,
    String? website,
    String? phone,
    String? address,
    File? logo,
  }) async {
    final formData = FormData();

    if (name != null) {
      formData.fields.add(MapEntry('name', name));
    }
    if (description != null) {
      formData.fields.add(MapEntry('description', description));
    }
    if (website != null) formData.fields.add(MapEntry('website', website));
    if (phone != null) formData.fields.add(MapEntry('phone', phone));
    if (address != null) formData.fields.add(MapEntry('address', address));

    if (logo != null) {
      formData.files.add(
        MapEntry(
          'logo',
          await MultipartFile.fromFile(
            logo.path,
            filename: logo.path.split('/').last,
          ),
        ),
      );
    }

    final response = await _apiClient.put('/company/$companyId', formData);

    return Company.fromJson(response);
  }

  @override
  Future<Member> getMemberProfile(String profileId) async {
    final response = await _apiClient.getOne('/profiles/$profileId');
    return Member.fromJson(response);
  }

  @override
  Future<Company> getCompanyProfile(String companyId) async {
    final response = await _apiClient.getOne('/company/$companyId');
    return Company.fromJson(response);
  }
}
