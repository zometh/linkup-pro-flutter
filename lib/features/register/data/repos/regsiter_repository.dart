import 'package:dartz/dartz.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';

import '../entities/profile.dart';
import '../../../../core/entities/user.dart';

abstract class RegisterRepository {
  Future<Either<Failure, Map<String, dynamic>>> register(User user);
  Future<Either<Failure, Map<String, dynamic>>> deleteUser();
  Future<Either<Failure, List<Map<String, dynamic>>>> getSectors();
  Future<Either<Failure, Map<String, dynamic>>> createProfile(Profile profile);
}