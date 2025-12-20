import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http_parser/http_parser.dart';

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
          headers: {
            'ngrok-skip-browser-warning': 'true', // Requis pour ngrok
          },
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
        data: queryParams,
        options: getOption(token),
      );
      return response.data;
    } on DioException catch (e) {
      manageException(e);
      return {};
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
        options: token != null ? getOption(token) : null,
      );
      return response.data;
    } on DioException catch (e) {
      manageException(e);
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    final token = await localDb.getToken();
    // Debug: log endpoint and whether token is present
    // Ne pas logger le token complet pour la sécurité, seulement sa présence
    print('[ApiClient] GET $path called. tokenPresent=${token != null} queryParams=${queryParams ?? {}}');
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: token != null ? getOption(token) : null,
      );
      final data = response.data;

      if (data is List) {
        return (data).cast<Map<String, dynamic>>();
      }

      if (data is Map<String, dynamic>) {
        if (data['data'] is List) {
          return (data['data'] as List).cast<Map<String, dynamic>>();
        }
        if (data['comments'] is List) {
          return (data['comments'] as List).cast<Map<String, dynamic>>();
        }
        if (data['result'] is List) {
          return (data['result'] as List).cast<Map<String, dynamic>>();
        }
      }
      return <Map<String, dynamic>>[];
    } on DioException catch (e) {
      manageException(e);
      return [];
    }
  }

  Future<Map<String, dynamic>> getOne(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    final token = await localDb.getToken();
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: token != null ? getOption(token) : null,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      manageException(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> put(String path, dynamic data) async {
    final token = await localDb.getToken();
    try {
      final response = await _dio.patch(
        path,
        data: data,
        options: token != null ? getOption(token) : null,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      manageException(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> uploadFile(String path, {required String fileField, required List<int> bytes, required String filename, String? contentType}) async {
    final token = await localDb.getToken();
    try {
      final multipartFile = MultipartFile.fromBytes(bytes, filename: filename, contentType: contentType != null ? MediaType.parse(contentType) : null);
      final formData = FormData.fromMap({
        fileField: multipartFile,
      });

      final response = await _dio.post(
        path,
        data: formData,
        options: token != null ? getOption(token).copyWith(headers: {
          ...getOption(token).headers!,
          'Content-Type': 'multipart/form-data',
        }) : Options(contentType: 'multipart/form-data'),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      manageException(e);
      return {};
    }
  }

  manageException(dynamic error) {
    NetworkException exception = NetworkException(exception: error);
    if (exception.errors == null) {
      showSuccess(exception.message);
    } else {
      for (final error in exception.errors!) {
        showError(error);
      }
    }
  }

  void showSuccess(String message) {
    showToast(
      description: message,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
    );
  }

  void showError(dynamic error) {
    if (error.toString().isNotEmpty) {
      showToast(
        description: error,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    }
  }

  Options getOption(String token) {
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true', // Requis pour ngrok
      },
    );
  }
}
