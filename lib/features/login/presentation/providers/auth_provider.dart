import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/features/login/data/auth_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/localdb/localdb.dart';
import '../../../../core/utils/my_logger.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final _authRepositoryImplements = GetIt.I<AuthRepositoryImplement>();
  final _db = GetIt.I<LocalDBService>();
  final _logger = GetIt.I<MyLogger>();
  bool isLoading = false;

  @override
  bool build() => isLoading;
  Future<bool> signIn(String credential, String password) async {
    state = true;

    try {
      final response = await _authRepositoryImplements.signIn(
        credential,
        password,
      );
      final List<dynamic> results = response.fold(
        (failure) {
          _logger.log(
            'SignIn Error: ${failure.message}',
            type: LogType.error,
            error: failure,
          );
          return [false, {}];
        },
        (data) {
          return [true, data["data"]];
        },
      );
      final data = results[1] as Map<String, dynamic>;
      await _db.saveToken(data['access_token'] as String);
      final String role = data["data"]['user']['role'] as String;
      //print('User role: $role'); // Debug print
      if (role == 'MEMBER') {
        final member = Member.fromJson(data['data']);
        await _db.saveUserInfos(member);
      } else {
        final company = Company.fromJson(data['data']);
        await _db.saveUserInfos(company);
      }
      state = false;
      return results[0] as bool;
    } catch (e) {
      _logger.log(
        'SignIn Error: ${e.toString()}',
        type: LogType.error,
        error: e,
      );
      state = false;
      return false;
    }
  }
}
