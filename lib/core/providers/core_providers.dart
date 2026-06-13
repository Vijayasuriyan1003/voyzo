import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../storage/secure_store.dart';

final secureStoreProvider = Provider<SecureStore>((ref) => SecureStore());

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(ref.read(secureStoreProvider));
  // Wire up the 401 → logout callback after auth controller is available.
  // The auth controller sets this in its constructor.
  return client;
});
