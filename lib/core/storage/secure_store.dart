import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encrypted storage for the Frappe API token (api_key:api_secret) and user
/// session metadata.  Android uses EncryptedSharedPreferences; iOS uses the
/// system Keychain.
class SecureStore {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _kToken = 'voyzo_token';
  static const _kUser = 'voyzo_user';
  static const _kRoles = 'voyzo_roles';
  static const _kName = 'voyzo_name';

  Future<void> saveSession({
    required String apiKey,
    required String apiSecret,
    required String user,
    required List<String> roles,
    String? fullName,
  }) async {
    await _storage.write(key: _kToken, value: '$apiKey:$apiSecret');
    await _storage.write(key: _kUser, value: user);
    await _storage.write(key: _kRoles, value: roles.join(','));
    if (fullName != null) await _storage.write(key: _kName, value: fullName);
  }

  /// Saves a session established via Frappe's built-in /api/method/login.
  /// The sid is stored with a "sid:" prefix so [ApiClient] can distinguish it
  /// from an API token (api_key:api_secret).
  Future<void> saveSessionWithSid({
    required String sid,
    required String user,
    required List<String> roles,
    String? fullName,
  }) async {
    await _storage.write(key: _kToken, value: 'sid:$sid');
    await _storage.write(key: _kUser, value: user);
    await _storage.write(key: _kRoles, value: roles.join(','));
    if (fullName != null) await _storage.write(key: _kName, value: fullName);
  }

  Future<void> updateRolesAndName({
    required List<String> roles,
    String? fullName,
  }) async {
    await _storage.write(key: _kRoles, value: roles.join(','));
    if (fullName != null) await _storage.write(key: _kName, value: fullName);
  }

  Future<String?> get token => _storage.read(key: _kToken);
  Future<String?> get user => _storage.read(key: _kUser);
  Future<String?> get fullName => _storage.read(key: _kName);

  Future<List<String>> get roles async {
    final r = await _storage.read(key: _kRoles);
    if (r == null || r.isEmpty) return [];
    return r.split(',');
  }

  Future<bool> get hasSession async => (await token) != null;

  Future<void> clear() => _storage.deleteAll();
}
