import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/secure_store.dart';
import '../data/auth_repository.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.roles = const [],
    this.fullName,
  });

  final AuthStatus status;
  final String? user;
  final List<String> roles;
  final String? fullName;

  bool get isDriver => roles.contains('Driver');
  bool get isCustomer => roles.contains('Customer');

  /// Returns the two-letter initials derived from [fullName].
  String get initials {
    if (fullName == null || fullName!.isEmpty) return '??';
    final parts = fullName!.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  AuthState copyWith({
    AuthStatus? status,
    String? user,
    List<String>? roles,
    String? fullName,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        roles: roles ?? this.roles,
        fullName: fullName ?? this.fullName,
      );
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repo, this._store, this._api) : super(const AuthState()) {
    // Propagate 401 errors to logout automatically.
    _api.onUnauthorized = logout;
  }

  final AuthRepository _repo;
  final SecureStore _store;
  final ApiClient _api;

  /// Restores session from encrypted storage on cold start.
  Future<void> restore() async {
    if (!await _store.hasSession) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }
    // Optimistic: mark authenticated immediately so routing is instant.
    state = AuthState(
      status: AuthStatus.authenticated,
      user: await _store.user,
      roles: await _store.roles,
      fullName: await _store.fullName,
    );
    // Then validate against server and refresh profile; a 401 triggers logout.
    try {
      final me = await _repo.currentUser();
      await _store.updateRolesAndName(roles: me.roles, fullName: me.fullName);
      if (state.status == AuthStatus.authenticated) {
        state = state.copyWith(roles: me.roles, fullName: me.fullName);
      }
    } on ApiException {
      // Offline or token still valid — keep cached state.
    }
  }

  Future<void> login({required String email, required String password}) async {
    final r = await _repo.login(email: email, password: password);
    await _applySession(r);
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? mobile,
  }) async {
    final r = await _repo.register(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
      mobile: mobile,
    );
    await _applySession(r);
  }

  Future<void> _applySession(AuthResult r) async {
    if (r.hasToken) {
      await _store.saveSession(
        apiKey: r.apiKey!,
        apiSecret: r.apiSecret!,
        user: r.user,
        roles: r.roles,
        fullName: r.fullName,
      );
    } else if (r.sid != null) {
      await _store.saveSessionWithSid(
        sid: r.sid!,
        user: r.user,
        roles: r.roles,
        fullName: r.fullName,
      );
    }
    state = AuthState(
      status: AuthStatus.authenticated,
      user: r.user,
      roles: r.roles,
      fullName: r.fullName,
    );
  }

  /// Authenticates via Frappe's built-in login and enforces the Driver role.
  /// Throws [ApiException] with a user-facing message if the account does not
  /// have the Driver role so the login screen can show it as a toast.
  Future<void> loginDriver({
    required String email,
    required String password,
  }) async {
    final r = await _repo.loginDriver(email: email, password: password);
    if (!r.roles.contains('Driver')) {
      throw const ApiException(
        'This is a Driver Login. Please use the appropriate login portal.',
      );
    }
    await _applySession(r);
  }

  Future<void> refreshProfile() async {
    state = state.copyWith(
      roles: await _store.roles,
      fullName: await _store.fullName,
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    await _store.clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    ref.read(authRepositoryProvider),
    ref.read(secureStoreProvider),
    ref.read(apiClientProvider),
  );
});
