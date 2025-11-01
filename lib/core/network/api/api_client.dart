// lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:toastification/toastification.dart';

import '../../widgets/custom_toast.dart';
import '../../services/localdb/localdb.dart';
import 'api_constants.dart';
import 'api_interceptor.dart';
import 'network_exception.dart';

class ApiClient {
  final Dio _dio;
  final localDb = GetIt.instance.get<LocalDBService>();

  ApiClient()
      : _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      sendTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  ) {
    _dio.interceptors.add(ApiInterceptors());
  }

  Future<Map<String, dynamic>> delete(
      String path, {
        Map<String, dynamic>? queryParams,
      }) async {
    try {
      final token = await localDb.getToken();
      if (token == null) {
        return {};
      }
      final response = await _dio.delete(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      NetworkException exception = NetworkException(exception: e);

      if (exception.errors == null) {
        showToast(
          description: exception.message,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
      } else {
        for (final error in exception.errors!) {
          showToast(
            description: error,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
          );
        }
      }

      throw NetworkException(exception: e);
    }
  }

  Future<Map<String, dynamic>> post(
      String path, {
        required dynamic data,
      }) async {
    final token = await localDb.getToken();
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      NetworkException exception = NetworkException(exception: e);

      if (exception.errors == null) {
        showToast(
          description: exception.message,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
      } else {
        for (final error in exception.errors!) {
          showToast(
            description: error,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
          );
        }
      }

      throw NetworkException(exception: e);
    }
  }

  /// Robust get: accepts responses that are either a List (direct array)
  /// or an object containing the list under `data` or `comments` keys.
  Future<List<Map<String, dynamic>>> get(
      String path, {
        Map<String, dynamic>? queryParams,
      }) async {
    final token = await localDb.getToken();
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final data = response.data;

      // If the backend returned a direct array
      if (data is List) {
        return (data as List).cast<Map<String, dynamic>>();
      }

      // If the backend returned an object wrapping the list
      if (data is Map<String, dynamic>) {
        if (data['data'] is List) {
          return (data['data'] as List).cast<Map<String, dynamic>>();
        }
        if (data['comments'] is List) {
          return (data['comments'] as List).cast<Map<String, dynamic>>();
        }
        // some APIs return items directly in a 'result' key
        if (data['result'] is List) {
          return (data['result'] as List).cast<Map<String, dynamic>>();
        }
      }

      // If nothing matched, return empty list instead of throwing.
      return <Map<String, dynamic>>[];
    } on DioException catch (e) {
      NetworkException exception = NetworkException(exception: e);

      if (exception.errors == null) {
        showToast(
          description: exception.message,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
      } else {
        for (final error in exception.errors!) {
          showToast(
            description: error,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
          );
        }
      }

      throw NetworkException(exception: e);
    }
  }

  // Méthode pour récupérer un seul objet (au lieu d'une liste)
  Future<Map<String, dynamic>> getOne(
      String path, {
        Map<String, dynamic>? queryParams,
      }) async {
    final token = await localDb.getToken();
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Retourne directement les données sans cast en liste
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      NetworkException exception = NetworkException(exception: e);

      if (exception.errors == null) {
        showToast(
          description: exception.message,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
        );
      } else {
        for (final error in exception.errors!) {
          showToast(
            description: error,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
          );
        }
      }

      throw NetworkException(exception: e);
    }
  }
}
