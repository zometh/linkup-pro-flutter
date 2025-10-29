import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/enums/user_role.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';

import '../../entities/company.dart';

class LocalDBService {
  final storage = FlutterSecureStorage();
  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<bool> isConnected() async {
    String? token = await getToken();
    String? userId = await getUserId();
    return token != null && userId != null;
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

  Future<UserRole> getUserRole() async {
    String? roleString = await storage.read(key: 'user_role');
    if (roleString != null) {
      return userRoleFromString(roleString);
    } else {
      throw Exception('User role not found in local storage');
    }
  }

  Future<void> saveUserInfos(dynamic data) async {
    await storage.write(
      key: 'user_role',
      value: data.user.role.toString().split('.').last,
    );
    await saveUserId(data.user.id!);
    final userInfos = jsonEncode(data.toJson());
    await storage.write(key: 'user_infos', value: userInfos);
  }

  Future<dynamic> getUserInfos() async {
    String? userInfos = await storage.read(key: 'user_infos');
    UserRole role = await getUserRole();
    Map<String, dynamic> userInfosMap = userInfos != null
        ? jsonDecode(userInfos)
        : {};
    if (role == UserRole.member) {
      return Member.fromJson(userInfosMap);
    }
    return Company.fromJson(userInfosMap);
  }

  Future<String> getUserProfileImage() async {
    String imageUrl = '';
    String? userInfos = await storage.read(key: 'user_infos');
    UserRole role = await getUserRole();
    Map<String, dynamic> userInfosMap = userInfos != null
        ? jsonDecode(userInfos)
        : {};
    if (role == UserRole.member) {
      Member member = Member.fromJson(userInfosMap);
      imageUrl = member.photoUrl ?? '';
    }else{
      Company company = Company.fromJson(userInfosMap);
      imageUrl = company.logo ?? '';
    }
    print(imageUrl);
    return imageUrl;
  }
}
