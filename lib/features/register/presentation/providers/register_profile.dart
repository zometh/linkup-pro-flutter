import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/features/register/data/entities/profile.dart';
import 'package:linkup_pro/features/register/data/repos/register_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/localdb/localdb.dart';



part 'register_profile.g.dart';

@Riverpod(keepAlive: true)
class RegisterProfile extends _$RegisterProfile {
  final _db = GetIt.I<LocalDBService>();

  final _registerRepositoryImplements = GetIt.I<RegisterRepositoryImplement>();

  @override
  bool build() {
    return false;
  }

  Future<bool> createProfile(Profile profile) async {
    // Mettre l'état à 'loading'
    state = true;

    try {
      final result = await _registerRepositoryImplements.createProfile(profile);

      // Traiter le résultat
      final List<dynamic> success = result.fold(
        (failure) {
          // Handle failur
          return [false, {}];
        },
        (data) {

         //Future.microtask(()async => await saveData(data));

          return [true, data];
        },
      );
      final data = success[1] as Map<String, dynamic>;

     final member = Member.fromJson(data['data']);
      await _db.saveUserInfos(member);

      state = false;
      return success[0];
    } catch (e) {
      // En cas d'erreur, reset state et retourner false
      state = false;
      rethrow;
    }
  }

}
