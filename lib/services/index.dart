import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:inside_maple/utils/logger.dart';

import '../utils/index.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: getServerUrl(),
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  static final box = Hive.box('insideMaple');

  static initDio() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String authToken = box.get('auth_token', defaultValue: 'empty_auth_token');

          options.headers.addAll({
            "authorization": "Bearer $authToken",
          });

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          loggerNoStack.e('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );
  }

  static Dio getDio() => _dio;
}
