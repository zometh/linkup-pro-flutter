// lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import 'package:linkup_pro/core/utils/services/custom_toast.dart';
import 'package:toastification/toastification.dart';
import 'api_constants.dart';
import 'api_interceptor.dart';
import 'network_exception.dart';

class ApiClient {
  final Dio _dio;

  // Le constructeur configure l'instance de Dio
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          responseType: ResponseType.json,
        ),
      ) {
    _dio.interceptors.add(ApiInterceptors());
  }

 /* Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      NetworkException exception = NetworkException(exception: e);
      showToast(
        description: exception.message ?? 'An unknown error occurred',
        type: ToastificationType.error,
      );
      throw NetworkException(
        exception: e
      );
    } catch (e) {
      showToast(description: e.toString(), type: ToastificationType.error);

      print(e);
    }
  }*/

  // Vous ajouteriez ici les méthodes POST, PUT, DELETE de la même manière
  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    // ... implémentation similaire
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      NetworkException exception = NetworkException(exception: e);

      showToast(
        description: exception.message,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );

      throw NetworkException(
        exception: e
      );
    }
  }
}
