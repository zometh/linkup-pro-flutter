/*
{
    "success": false,
    "statusCode": 404,
    "message": "Mot de passe incorrect!",
    "timestamp": "2025-10-07T00:39:29.925Z"
}
*/
import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final DioException exception;

  NetworkException({required this.exception});

  String get message => exception.response?.data["message"].toString() ?? "";
  int get statusCode => exception.response?.data["statusCode"].toInt() ?? 200;
  bool get success => exception.response?.data["success"] ?? false;
  List<dynamic>? get errors => exception.response?.data["errors"];
  @override
  String toString() {
    return "{"
        "message : $message,"
        "statusCode : $statusCode,"
        "success: $success,"
        "errors: $errors"
        "}";
  }


}