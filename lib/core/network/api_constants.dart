// lib/core/network/api_constants.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['BACKEND_URL'] ?? 'https://883b3c0daad8.ngrok-free.app/api/v1';
}