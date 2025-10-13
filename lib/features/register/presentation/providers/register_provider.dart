import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/register/data/entities/user.dart';
import 'package:linkup_pro/features/register/data/register_user/register_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/services/localdb.dart';
import '../../../../core/utils/services/my_logger.dart';


part 'register_provider.g.dart';
@riverpod
class Register extends _$Register{
  final _registerRepositoryImplements = GetIt.I<RegisterRepositoryImplement>();
  final _db = GetIt.I<LocalDBService>();
  final _logger = GetIt.I<MyLogger>();
  @override
  bool build() {
    return false;
  }
  Future<bool> registerUser(User user) async{
    state = true;
    final response = await _registerRepositoryImplements.register(user);
    response.fold(
      (failure) {
        _logger.log(
          'Register Error: ${failure.message}',
          type: LogType.error,
          error: failure,
        );
        state = false;
        return false;
      },
      (data) async {
        await _db.saveToken(data['token'] as String);
        state = false;
        return true;
      }
    );

    return response.fold(
        (f) => false
    , (d) => true);
  }
  Future<bool> deleteUser() async{
      state = true;
      final response = await _registerRepositoryImplements.deleteUser();
      response.fold(
              (failure) {
            _logger.log(
              'Delete User Error: ${failure.message}',
              type: LogType.error,
              error: failure,
            );
            state = false;
            return false;
          },
              (data) async {
            await _db.deleteUserId();
            await _db.deleteToken();
            state = false;
            return true;
              }
      );
      return response.fold(
              (f) => false
          , (d) => true);
  }
}