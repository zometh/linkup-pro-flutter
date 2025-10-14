
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/register/data/entities/profile.dart';
import 'package:linkup_pro/features/register/data/repos/register_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_profile.g.dart';
@riverpod
class RegisterProfile extends _$RegisterProfile {
    final _registerRepositoryImplements = GetIt.I<RegisterRepositoryImplement>();

  @override
  bool build() {
    return false;
  }
  Future<bool> createProfile(Profile profile) async {
    
    state = true;
    final result = await _registerRepositoryImplements.createProfile(profile);
    result.fold(
      (failure) {
        // Handle failure
        state = false;
        return false;
      },
      (data) {
        // Handle success
        state = false;
        return true;
      },
    );
    return result.fold(
        (f) => false
    , (d) => true);
  }
}