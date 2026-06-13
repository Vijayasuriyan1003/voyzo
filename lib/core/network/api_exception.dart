class ApiException implements Exception {
  const ApiException(this.message, {this.code, this.status});

  final String message;

  /// Machine-readable code embedded in the server message (e.g. INVALID_OTP).
  final String? code;

  /// HTTP status code.
  final int? status;

  @override
  String toString() => 'ApiException[$status]: $message';
}
