// lib/core/network/api_interceptors.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../services/localdb/localdb.dart';
import '../../utils/my_logger.dart';


class ApiInterceptors extends Interceptor {
  MyLogger logger = MyLogger();
  final localDb = GetIt.instance.get<LocalDBService>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    final authToken = await localDb.getToken();

    if (authToken!= null) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }

    logger.log(' REQUEST[${options.method}] => PATH: ${options.path}', type: LogType.debug);
    super.onRequest(options, handler);
  }

  // Exécuté quand une réponse est reçue avec succès
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.log(' RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}', type: LogType.info);
    super.onResponse(response, handler);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(' ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    logger.log(' ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}', type: LogType.error);
    super.onError(err, handler);
  }
}