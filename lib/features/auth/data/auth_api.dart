import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:voyzo/core/exceptions/app_exception.dart';
import 'package:voyzo/core/network/dio_client.dart';

/// Result of a successful driver login.
class DriverLoginResult {
  final String userId;
  final String fullName;

  const DriverLoginResult({required this.userId, required this.fullName});
}

class AuthApi {
  /// Only users carrying this Frappe role are allowed into the driver app.
  static const String _driverRole = 'Driver';

  /// Authenticates against the Frappe site and verifies the user holds the
  /// "Driver" role.
  ///
  /// Throws an [AppException] with a short, user-friendly message when the
  /// credentials are wrong or the account is not a driver — the caller surfaces
  /// `message` directly in a toast.
  Future<DriverLoginResult> login({
    required String usr,
    required String pwd,
  }) async {
    // 1) Authenticate. Frappe's login endpoint expects form-encoded fields.
    Response loginRes;
    try {
      loginRes = await DioClient.dio.post(
        '/api/method/login',
        data: {'usr': usr, 'pwd': pwd},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
    } on DioException catch (e) {
      throw _loginError(e);
    }

    final fullName = loginRes.data is Map
        ? (loginRes.data['full_name'] as String? ?? '')
        : '';

    // 2) Resolve the actual logged-in user id (handles email vs username).
    final userId = await _loggedInUser();

    // 3) Gate on the Driver role.
    final roles = await _rolesFor(userId);
    if (!roles.contains(_driverRole)) {
      DioClient.cookieStore.clear(); // drop the non-driver session
      throw const AppException(
        message: 'Access denied. This app is for drivers only.',
        code: 403,
      );
    }

    return DriverLoginResult(userId: userId, fullName: fullName);
  }

  Future<String> _loggedInUser() async {
    try {
      final res = await DioClient.dio.get(
        '/api/method/frappe.auth.get_logged_user',
      );
      final userId = (res.data['message'] as String?) ?? '';
      if (userId.isEmpty) {
        throw const AppException(message: 'Could not resolve logged-in user.');
      }
      return userId;
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      debugPrint('[AuthApi] _loggedInUser error: type=${e.type} status=${e.response?.statusCode}');
      throw AppException(
        message: 'Session error. Please try again.',
        code: e.response?.statusCode,
      );
    }
  }

  Future<List<String>> _rolesFor(String user) async {
    try {
      final res = await DioClient.dio.get(
        '/api/resource/User/${Uri.encodeComponent(user)}',
      );
      final data = res.data['data'] as Map<String, dynamic>;
      final roles = (data['roles'] as List?) ?? const [];
      return roles
          .map((r) => (r as Map)['role'] as String)
          .toList(growable: false);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      debugPrint('[AuthApi] _rolesFor error: type=${e.type} status=${e.response?.statusCode}');
      throw AppException(
        message: 'Could not verify driver role. Please try again.',
        code: e.response?.statusCode,
      );
    }
  }

  Future<Response> register({
    required String name,
    required String number,
    required String email,
    required String password,
  }) async {
    try {
      return await DioClient.dio.post(
        '/api/method/frappe.client.save',
        data: {
          'doc': {
            'doctype': 'User',
            'first_name': name,
            'mobile_no': number,
            'email': email,
            'new_password': password,
            'send_welcome_email': 0,
          },
        },
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final msg = (data is Map && data['message'] is String)
          ? data['message'] as String
          : 'Registration failed. Please try again.';
      throw AppException(message: msg, code: status);
    }
  }

  AppException _loginError(DioException e) {
    debugPrint('[AuthApi] login error: type=${e.type} status=${e.response?.statusCode} data=${e.response?.data}');
    final status = e.response?.statusCode;

    // Wrong driver id / password.
    if (status == 401) {
      return const AppException(
        message: 'Invalid Driver ID or password',
        code: 401,
      );
    }

    // No / poor connectivity or SSL failure.
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.badCertificate) {
      return const AppException(
        message: 'Network error. Please check your connection.',
      );
    }

    final data = e.response?.data;
    final serverMsg =
        (data is Map && data['message'] is String) ? data['message'] as String : null;
    return AppException(
      message: serverMsg ?? 'Login failed. Please try again.',
      code: status,
    );
  }
}
