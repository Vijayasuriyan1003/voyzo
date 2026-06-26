import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class DioClient {
  static final CookieJar cookieJar = CookieJar();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://dev-taxi.m.frappe.cloud',
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(CookieManager(cookieJar));
}
