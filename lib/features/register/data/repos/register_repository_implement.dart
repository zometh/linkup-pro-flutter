import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/services/my_logger.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/register/data/entities/profile.dart';
import 'package:linkup_pro/core/entities/user.dart';
import 'package:linkup_pro/features/register/data/repos/regsiter_repository.dart';

import '../../../../core/network/api/api_client.dart';

class RegisterRepositoryImplement extends RegisterRepository {

  final _apiClient = GetIt.I<ApiClient>();

  @override
  Future<Either<Failure, Map<String, dynamic>>> register(User user) async {
    try {
      final response =  await _apiClient.post('/auth/register', data: user.toJson());
      final authtoken = response['access_token'];

      return Right({
        "token": authtoken,
      });
    } catch (e) {
      return Left(Failure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteUser() async{
    try{
      final response =  await _apiClient.delete('/auth');
      final message = response['message'];
      return Right({
        "message": message,
      });
    } catch (e) {
      return Left(Failure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getSectors() async{
    try{
      final response =  await _apiClient.get('/sector');

      return Right(response);
    } catch (e) {
      return Left(Failure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createProfile(Profile profile) async {
    try{
      final formData = FormData.fromMap({
        ...profile.toMap()
      });
      final response =  await _apiClient.post('/profiles', data: formData);
      return Right({
        "data": response["data"],
      });
    } catch (e) {
      return Left(Failure( e.toString()));
    }
  }
}