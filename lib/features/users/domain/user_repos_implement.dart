import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/users/domain/users_repos.dart';

class UsersRepositoryImpl implements UsersRepository {
  final apiClient = GetIt.I<ApiClient>();

  @override
  Future<Either<Failure, bool>> followOrUnfollow(String userId) async {
    try {
      final response = await apiClient.post('/follow/user/$userId', data: {});
      return Right(response["isFollowing"] as bool);
    } catch (e) {
      return Future.value(Left(Failure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOneUser(
    String userId,
  ) async {
    try {
      final response = await apiClient.getOne('/users/$userId');
      return Right(response);
    } catch (e) {
      return Future.value(Left(Failure(e.toString())));
    }
  }
}
