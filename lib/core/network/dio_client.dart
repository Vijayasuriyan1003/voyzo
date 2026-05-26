import 'package:dio/dio.dart';
import 'package:voyzo/core/constants/app_constants.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
}
