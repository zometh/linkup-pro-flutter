import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
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
    throw UnimplementedError();
  }

  @override
  Future<void> sendDeviceToken(String token) async{

    try{
      await _apiClient.post(
        "/auth/device-token",
        data: {
          "deviceToken": token,
        },
      );
    }catch(e){
      MyLogger().log("Error sending Device token : $e");
    }
  }
}
