import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import '../storage/storage_providers.dart';
import 'api_client.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

/// Timeouts for Apps Script / proxy (docs/security.md §12, environment.md §6).
/// Cold start can be slow; bounds stay finite (fail closed on hang).
const Duration kConnectTimeout = Duration(seconds: 15);
const Duration kReceiveTimeout = Duration(seconds: 30);
const Duration kSendTimeout = Duration(seconds: 30);

/// Builds a configured [Dio] for OurSpace API POSTs.
Dio createDio({
  required SecureStorage secureStorage,
  String? baseUrl,
  List<Interceptor>? extraInterceptors,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
      connectTimeout: kConnectTimeout,
      receiveTimeout: kReceiveTimeout,
      sendTimeout: kSendTimeout,
      headers: const <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(secureStorage),
    LoggingInterceptor(),
    ...?extraInterceptors,
  ]);

  return dio;
}

/// Documented dependency (docs/state-management.md, coding-standard.md).
final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return createDio(secureStorage: storage);
});

/// Documented dependency (docs/state-management.md).
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});
