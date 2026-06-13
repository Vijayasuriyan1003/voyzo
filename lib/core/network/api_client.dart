import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../storage/secure_store.dart';
import 'api_exception.dart';

/// Frappe-aware Dio wrapper:
/// - Attaches `Authorization: token <api_key:api_secret>` on authenticated
///   requests, or `Cookie: sid=<sid>` for session-based auth.
/// - Unwraps the Frappe `{ message: ... }` response envelope.
/// - Normalises Frappe error formats (_server_messages, exception, message)
///   into [ApiException].
class ApiClient {
  ApiClient(this._store) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
      // Frappe returns non-2xx for application-level errors; handle manually.
      validateStatus: (s) => s != null && s < 500,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final tok = await _store.token;
        if (tok != null) {
          // Tokens stored with a "sid:" prefix indicate a Frappe session cookie;
          // all others are API key:secret pairs.
          if (tok.startsWith('sid:')) {
            options.headers['Cookie'] = 'sid=${tok.substring(4)}';
          } else {
            options.headers['Authorization'] = 'token $tok';
          }
        }
        handler.next(options);
      },
    ));
  }

  final SecureStore _store;
  late final Dio _dio;

  /// Invoked when the server returns 401 (expired / invalid token).
  void Function()? onUnauthorized;

  Future<dynamic> post(String path, {Map<String, dynamic>? data}) =>
      _send(() => _dio.post(path, data: data));

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _dio.get(path, queryParameters: query));

  /// Posts to the Frappe built-in session login endpoint.
  /// Returns the full response body (not just the `message` field) and the
  /// session ID (sid) extracted from the `Set-Cookie` response header.
  Future<({Map<String, dynamic> body, String? sid})> sessionLogin(
      String path, Map<String, dynamic> data) async {
    try {
      final res = await _dio.post(path, data: data);
      if ((res.statusCode ?? 0) >= 400) throw _mapError(res);
      final body = (res.data as Map?)?.cast<String, dynamic>() ?? {};
      return (body: body, sid: _extractSid(res));
    } on DioException catch (e) {
      if (e.response != null) throw _mapError(e.response!);
      throw const ApiException('Network error. Please check your connection.');
    }
  }

  /// GET with an explicit session cookie rather than the persisted credentials.
  /// Used during login to fetch user data before the session is stored.
  Future<dynamic> getWithCookie(
      String path, String sid, {Map<String, dynamic>? query}) {
    return _send(() => _dio.get(
          path,
          queryParameters: query,
          options: Options(headers: {'Cookie': 'sid=$sid'}),
        ));
  }

  /// Uploads a local file to Frappe's `/api/method/upload_file`.
  Future<String> uploadFile(
    String filePath, {
    bool isPrivate = false,
    String? doctype,
    String? docname,
    String? fieldname,
  }) async {
    final fileName = filePath.split('/').last;
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'is_private': isPrivate ? 1 : 0,
      'folder': 'Home/Attachments',
      if (doctype != null) 'doctype': doctype,
      if (docname != null) 'docname': docname,
      if (fieldname != null) 'fieldname': fieldname,
    });
    final res = await _send(() => _dio.post(ApiConfig.uploadFile, data: form));
    if (res is Map) return res['file_url']?.toString() ?? '';
    return '';
  }

  Future<dynamic> _send(Future<Response> Function() run) async {
    try {
      final res = await run();
      final status = res.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        final body = res.data;
        if (body is Map && body.containsKey('message')) return body['message'];
        return body;
      }
      throw _mapError(res);
    } on DioException catch (e) {
      if (e.response != null) throw _mapError(e.response!);
      throw const ApiException('Network error. Please check your connection.');
    }
  }

  /// Extracts the Frappe session ID from a `Set-Cookie` response header.
  String? _extractSid(Response res) {
    final cookies = res.headers['set-cookie'];
    if (cookies == null) return null;
    for (final cookie in cookies) {
      final m = RegExp(r'sid=([^;]+)').firstMatch(cookie);
      if (m != null) {
        final s = m.group(1)?.trim();
        if (s != null && s.isNotEmpty && s != 'Guest') return s;
      }
    }
    return null;
  }

  ApiException _mapError(Response res) {
    final status = res.statusCode ?? 0;
    String message = 'Something went wrong. Please try again.';
    String? code;

    final data = res.data;
    if (data is Map) {
      // Frappe packs throw() messages in _server_messages (JSON-encoded list).
      final sm = data['_server_messages'];
      if (sm is String && sm.isNotEmpty) {
        try {
          final list = jsonDecode(sm) as List;
          if (list.isNotEmpty) {
            final first = jsonDecode(list.first as String);
            message = (first is Map ? first['message'] : first).toString();
          }
        } catch (_) {/* fall through */}
      } else if (data['exception'] is String) {
        message = (data['exception'] as String).split(':').last.trim();
      } else if (data['message'] is String) {
        message = data['message'] as String;
      }
    }

    if (status == 401) onUnauthorized?.call();
    if (status == 429) message = 'Too many attempts. Please try again later.';

    return ApiException(message, code: code, status: status);
  }
}
