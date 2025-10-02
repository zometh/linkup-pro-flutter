// lib/core/network/api_constants.dart
import 'package:flutter_dotenv/flutter_dotenv.dart'as DotEnv;

class ApiConstants {
  static String get baseUrl => DotEnv.DotEnv().env['BACKEND_URL'] ?? 'https://api.votre-reseau-social.com/v1';
}