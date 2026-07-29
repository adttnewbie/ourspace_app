import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';

/// Attaches `memberId` + `sessionToken` from secure storage into POST JSON body.
///
/// Domain-agnostic: only reads [StorageKeys] via [SecureStorage]
/// (docs/api-contract.md, security.md §12, state-management.md).
/// Empty values allowed for pre-pairing calls (api-contract.md).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorage _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final memberId = await _secureStorage.read(StorageKeys.memberId) ?? '';
    final sessionToken =
        await _secureStorage.read(StorageKeys.sessionToken) ?? '';

    final data = options.data;
    if (data is Map) {
      final body = Map<String, dynamic>.from(data);
      body.putIfAbsent('memberId', () => memberId);
      body.putIfAbsent('sessionToken', () => sessionToken);
      body.putIfAbsent('payload', () => <String, dynamic>{});
      options.data = body;
    }

    handler.next(options);
  }
}
