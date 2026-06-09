import 'package:dio/dio.dart';

/// In-memory store for the Frappe session cookies (notably `sid`).
///
/// Frappe authenticates subsequent requests via the session cookie set by
/// `/api/method/login`. Dio does not persist cookies on its own, so we capture
/// them from every response and replay them on every request for the lifetime
/// of the app session.
class SessionCookieStore {
  final Map<String, String> _cookies = {};

  void saveFromHeaders(Headers headers) {
    final setCookies = headers['set-cookie'];
    if (setCookies == null) return;
    for (final raw in setCookies) {
      final pair = raw.split(';').first.trim();
      final eq = pair.indexOf('=');
      if (eq <= 0) continue;
      _cookies[pair.substring(0, eq)] = pair.substring(eq + 1);
    }
  }

  String get cookieHeader =>
      _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');

  bool get hasSession => _cookies.containsKey('sid');

  void clear() => _cookies.clear();
}

class DioClient {
  static final SessionCookieStore cookieStore = SessionCookieStore();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://dev-taxi.m.frappe.cloud',
      headers: {'Accept': 'application/json'},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final cookie = cookieStore.cookieHeader;
          if (cookie.isNotEmpty) options.headers['Cookie'] = cookie;
          handler.next(options);
        },
        onResponse: (response, handler) {
          cookieStore.saveFromHeaders(response.headers);
          handler.next(response);
        },
        onError: (error, handler) {
          final res = error.response;
          if (res != null) cookieStore.saveFromHeaders(res.headers);
          handler.next(error);
        },
      ),
    );
}
