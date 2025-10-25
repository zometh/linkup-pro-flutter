import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/login/data/auth_repository.dart';

import '../../../core/network/api/api_client.dart';
import '../../../core/utils/types/error_api_type.dart';

class AuthRepositoryImplement implements AuthRepository {
  final _apiClient = GetIt.I<ApiClient>();
  @override
  Future<String?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignedIn() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> signIn(
    String credential,
    String password,
  ) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          credential.contains("@") ? "email" : "username": credential,
          'password': password,
        },
      );


      return Right({"data": response});
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
