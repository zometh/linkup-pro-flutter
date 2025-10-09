import 'package:dartz/dartz.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';

import 'entities/user.dart';

abstract class RegisterRepository {
  Future<Either<Failure, Map<String, dynamic>>> register(User user);
}