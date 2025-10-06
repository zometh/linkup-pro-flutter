import "package:dartz/dartz.dart";
import "package:linkup_pro/core/utils/types/error_api_type.dart";
abstract class AuthRepository {
  Future<Either<Failure, String>> signIn(String username, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<String?> getCurrentUser();
}