import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/features/register/data/entities/entreprise.dart';
import 'package:linkup_pro/features/register/data/repos/register_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:get_it/get_it.dart';
part 'register_company.g.dart';

@Riverpod(keepAlive: true)
class RegisterCompany extends _$RegisterCompany {
  final _db = GetIt.I<LocalDBService>();

  final _registerRepositoryImplements = GetIt.I<RegisterRepositoryImplement>();

  @override
  bool build() {
    return false;
  }

  Future<bool> createCompany(Entreprise companyData) async {
    // Mettre l'état à 'loading'
    state = true;

    try {
      final result = await _registerRepositoryImplements.createEntreprise(
        companyData,
      );

      // Traiter le résultat
      final List<dynamic> success = result.fold(
        (failure) {
          // Handle failure
          return [false, {}];
        },
        (data) {
          return [true, data];
        },
      );

      // Traiter le résultat
      final data = success[1] as Map<String, dynamic>;
      final company = Company.fromJson(data['data']);
      await _db.saveUserInfos(company);
      state = false;
      return success[0];
    } catch (e) {
      // En cas d'erreur, reset state et retourner false
      state = false;
      rethrow;
    }
  }
}
