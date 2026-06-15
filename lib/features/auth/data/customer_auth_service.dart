import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomerAuthService {
  static const _baseUrl = 'https://dev-taxi.m.frappe.cloud';

  static const _keySid = 'customer_sid';
  static const _keyFullName = 'customer_full_name';
  static const _keyUser = 'customer_user';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      contentType: 'application/x-www-form-urlencoded',
      receiveDataWhenStatusError: true,
    ),
  );

  /// Logs in and persists the session. Throws a [String] error message on failure.
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '/api/method/login',
        data: {'usr': email, 'pwd': password},
      );

      final data = response.data as Map<String, dynamic>? ?? {};

      // Extract sid from Set-Cookie response header.
      String? sid;
      final cookies = response.headers['set-cookie'] ?? [];
      for (final cookie in cookies) {
        final match = RegExp(r'sid=([^;]+)').firstMatch(cookie);
        if (match != null && match.group(1) != 'Guest') {
          sid = match.group(1);
          break;
        }
      }

      await Future.wait([
        if (sid != null) _storage.write(key: _keySid, value: sid),
        _storage.write(key: _keyUser, value: email),
        _storage.write(
          key: _keyFullName,
          value: data['full_name']?.toString() ?? '',
        ),
      ]);
    } on DioException catch (e) {
      final body = e.response?.data;
      String message = 'Login failed. Please try again.';
      if (body is Map) {
        message = body['message']?.toString() ?? message;
      }
      throw message;
    }
  }

  Future<bool> isLoggedIn() async {
    final sid = await _storage.read(key: _keySid);
    return sid != null && sid.isNotEmpty;
  }

  Future<String?> getFullName() => _storage.read(key: _keyFullName);

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
