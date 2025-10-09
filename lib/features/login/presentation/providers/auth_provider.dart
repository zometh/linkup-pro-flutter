import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/login/data/auth_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/services/localdb.dart';
import '../../../../core/utils/services/my_logger.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final _authRepositoryImplements = GetIt.I<AuthRepositoryImplement>();
  final _db = GetIt.I<LocalDBService>();
  final _logger = GetIt.I<MyLogger>();
  bool isLoading = false;
  String errorMessage = '';

  @override
  bool build() => isLoading;
  Future<bool> signIn(String credential, String password) async {
    state = true;
   
    final response = await _authRepositoryImplements.signIn(
      credential,
      password,
    );
    response.fold(
      (failure) {
        _logger.log(
          'SignIn Error: ${failure.message}',
          type: LogType.error,
          error: failure,
        );
        state = false;
        return false;
      },
      (data) async {
        await _db.saveToken(data['token'] as String);
        await _db.saveUserId(data['userId'] as String);

        state = false;
        return true;
      },
    );
    return response.fold(
      (failure) => false,
      (data) => true,
    );
  }
}
