import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/services/custom_toast.dart';
import 'package:linkup_pro/features/auth/data/auth_repository.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/types/error_api_type.dart';

class AuthRepositoryImplement implements AuthRepository {
  final _apiClient = GetIt.I<ApiClient>();
  @override
  Future<String?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignedIn() {
    // TODO: implement isSignedIn
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signIn(String credential, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', data: {
        credential.contains("@") ? "email" : "username" : credential,
        'password': password,
      });
      final token = response['auth_token'] as String;
      return Right(token);
    } catch (e) {
      return Left(Failure( e.toString()));
    }
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

}