import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/features/profile/data/repositories/profile_repository.dart';
import 'package:linkup_pro/features/profile/data/repositories/profile_repository_impl.dart';

final editProfileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(GetIt.I<ApiClient>());
});

final editProfileProvider =
    NotifierProvider<EditProfileNotifier, EditProfileState>(() {
      return EditProfileNotifier();
    });

class EditProfileState {
  final bool isLoading;
  final String? error;
  final Member? member;
  final Company? company;

  EditProfileState({
    this.isLoading = false,
    this.error,
    this.member,
    this.company,
  });

  EditProfileState copyWith({
    bool? isLoading,
    String? error,
    Member? member,
    Company? company,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      member: member ?? this.member,
      company: company ?? this.company,
    );
  }
}

class EditProfileNotifier extends Notifier<EditProfileState> {
  @override
  EditProfileState build() {
    return EditProfileState();
  }

  ProfileRepository get _repository => ref.read(editProfileRepositoryProvider);
  LocalDBService get _localDB => GetIt.I<LocalDBService>();

  Future<bool> updateMemberProfile({
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
    state = state.copyWith(isLoading: true, error: null);

    try {
      final member = await _repository.updateMemberProfile(
        profileId: profileId,
        firstName: firstName,
        lastName: lastName,
        biography: biography,
        phone: phone,
        birthDate: birthDate,
        portfolio: portfolio,
        address: address,
        photo: photo,
      );

      // Sauvegarder les informations mises à jour localement
      await _localDB.saveUserInfos(member);

      state = state.copyWith(isLoading: false, member: member);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateCompanyProfile({
    required String companyId,
    String? name,
    String? description,
    String? website,
    String? phone,
    String? address,
    File? logo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final company = await _repository.updateCompanyProfile(
        companyId: companyId,
        name: name,
        description: description,
        website: website,
        phone: phone,
        address: address,
        logo: logo,
      );

      // Sauvegarder les informations mises à jour localement
      await _localDB.saveUserInfos(company);

      state = state.copyWith(isLoading: false, company: company);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
