abstract class AuthRepository {
  Future<void> signIn(String username, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<String?> getCurrentUser();
}