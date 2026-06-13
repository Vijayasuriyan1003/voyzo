import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/core_providers.dart';

class AuthResult {
  const AuthResult({
    required this.user,
    required this.roles,
    this.apiKey,
    this.apiSecret,
    this.sid,
    this.fullName,
  });

  final String user;
  final List<String> roles;
  final String? apiKey;
  final String? apiSecret;

  /// Set when authenticated via Frappe's built-in /api/method/login.
  final String? sid;
  final String? fullName;

  bool get hasToken =>
      apiKey != null &&
      apiKey!.isNotEmpty &&
      apiSecret != null &&
      apiSecret!.isNotEmpty;

  factory AuthResult.fromJson(Map m) => AuthResult(
        user: m['user']?.toString() ?? '',
        roles: (m['roles'] as List?)?.map((e) => e.toString()).toList() ?? [],
        apiKey: m['api_key']?.toString(),
        apiSecret: m['api_secret']?.toString(),
        fullName: m['full_name']?.toString(),
      );
}

class AuthRepository {
  AuthRepository(this._api);
  final ApiClient _api;

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final m = await _api.post(
      ApiConfig.login,
      data: {'email': email, 'password': password},
    );
    return AuthResult.fromJson(m as Map);
  }

  /// Authenticates via Frappe's built-in session login endpoint and returns
  /// the user's roles. The caller is responsible for enforcing role-based access.
  Future<AuthResult> loginDriver({
    required String email,
    required String password,
  }) async {
    final (:body, :sid) = await _api.sessionLogin(
      ApiConfig.driverLogin,
      {'usr': email, 'pwd': password},
    );

    if (body['message']?.toString() != 'Logged In') {
      throw ApiException(
          body['message']?.toString() ?? 'Login failed. Please try again.');
    }
    if (sid == null) throw const ApiException('Could not establish session.');

    final fullName = body['full_name']?.toString();

    // Fetch the User document to retrieve the roles child table.
    // GET /api/resource/User/{email} → {"data": {..., "roles": [{role: "..."}]}}
    // _send returns the body as-is since the outer key is "data", not "message".
    final resp = await _api.getWithCookie(
          '/api/resource/User/${Uri.encodeComponent(email)}',
          sid,
        ) as Map? ??
        {};

    final userDoc = resp['data'] as Map? ?? {};
    final rolesRaw = userDoc['roles'] as List? ?? [];
    final roles = rolesRaw
        .map((r) => (r as Map)['role']?.toString())
        .whereType<String>()
        .toList();

    return AuthResult(
      user: email,
      roles: roles,
      sid: sid,
      fullName: fullName ?? userDoc['full_name']?.toString(),
    );
  }

  Future<AuthResult> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? mobile,
  }) async {
    final m = await _api.post(ApiConfig.register, data: {
      'email': email,
      'password': password,
      'full_name': fullName,
      'role': role,
      if (mobile != null && mobile.isNotEmpty) 'mobile': mobile,
    });
    return AuthResult.fromJson(m as Map);
  }

  /// Validates the stored token against the server; returns live profile data.
  Future<({String email, String? fullName, List<String> roles})>
      currentUser() async {
    final m = await _api.post(ApiConfig.currentUser);
    final map = (m as Map?) ?? const {};
    return (
      email: map['email']?.toString() ?? '',
      fullName: map['full_name']?.toString(),
      roles: (map['roles'] as List?)?.map((e) => e.toString()).toList() ??
          const <String>[],
    );
  }

  Future<String> requestPasswordReset(String email) async {
    final m = await _api.post(
      ApiConfig.requestPasswordReset,
      data: {'email': email},
    );
    if (m is Map) {
      return m['message']?.toString() ?? 'Password reset link sent to your email.';
    }
    return 'Password reset link sent to your email.';
  }

  Future<void> logout() async {
    try {
      await _api.post(ApiConfig.logout);
    } catch (_) {
      // Token auth: local credential wipe is authoritative for logout.
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(apiClientProvider)),
);
