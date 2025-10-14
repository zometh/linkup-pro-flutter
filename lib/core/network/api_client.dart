// lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/services/custom_toast.dart';
import 'package:linkup_pro/core/utils/services/localdb.dart';
import 'package:toastification/toastification.dart';
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
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
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
      if(token == null){
        return {};
      }
      final response = await _dio.delete(path, queryParameters: queryParams, options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
      ));
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
  Future<Map<String, dynamic>> post(
    String path, {
    required dynamic data,
  }) async {
    final token = await localDb.getToken();
    try {
      final response = await _dio.post(path, data: data, options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }
      ));
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
  Future<List<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    final token = await localDb.getToken();
    try {
      final response = await _dio.get(path, queryParameters: queryParams, options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }
      ));
      final data =  response.data;

      return data.cast<Map<String, dynamic>>();
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
