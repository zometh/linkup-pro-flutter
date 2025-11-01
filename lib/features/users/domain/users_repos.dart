
import 'package:dartz/dartz.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';

abstract class UsersRepository {
  Future<Either<Failure, bool>> followOrUnfollow(String userId);
}

