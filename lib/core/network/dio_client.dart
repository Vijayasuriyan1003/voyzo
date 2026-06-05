import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://6a21d5b9b1d0aaf32b500073.mockapi.io/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
