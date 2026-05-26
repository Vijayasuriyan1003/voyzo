class AppException implements Exception {
  const AppException({required this.message, this.code});

  final String message;
  final int? code;

  @override
  String toString() => 'AppException($code): $message';
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.code});
}

class ServerException extends AppException {
  const ServerException({required super.message, super.code});
}

class CacheException extends AppException {
  const CacheException({required super.message});
}
