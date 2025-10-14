import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalDBService {

  final storage = FlutterSecureStorage();
  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'auth_token');
  }
  Future<String?> getUserId() async {
    return await storage.read(key: 'user_id');
  }
  Future<void> saveUserId(String userId) async {
    await storage.write(key: 'user_id', value: userId);
  }
  Future<void> deleteUserId() async {
    await storage.delete(key: 'user_id');
  }
  Future<void> saveLanguageCode(String code) async {
    await storage.write(key: 'language_code', value: code);
  }
  Future<String?> getLanguageCode() async {
    return await storage.read(key: 'language_code');
  }

  Future<void> clearAllData() async {
    await storage.deleteAll();
  }
}
