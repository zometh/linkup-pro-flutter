import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/users/domain/user_repos_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users.g.dart';

@Riverpod()
class Users extends _$Users {
  final usersImplement = GetIt.I<UsersRepositoryImpl>();
  @override
  bool build() {
    return false;
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    Future.microtask(() => state = true);
    try{
      final response = await usersImplement.getOneUser(userId);
      final result =  response.fold((e) => null, (r) => r);
      Future.microtask(() => state = false);

      return result;
    } catch (e) {
      Future.microtask(() => state = false);
      rethrow;
    }
  }

}