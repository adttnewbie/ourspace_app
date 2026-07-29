import 'dart:io';

import 'package:dio/dio.dart';

/// Unified failure type for UI/notifiers (docs/coding-standard.md §11, error-handling.md).
sealed class AppFailure implements Exception {
  const AppFailure({required this.code, this.message});

  /// Contract / client-normalized code (e.g. `UNAUTHORIZED`, `NETWORK_OFFLINE`).
  final String code;

  /// Optional server or technical message — never show raw platform strings to users.
  final String? message;

  @override
  String toString() =>
      'AppFailure($code${message != null ? ': $message' : ''})';
}

/// Dio connection / timeout / offline (error-handling.md §1–2).
final class NetworkFailure extends AppFailure {
  const NetworkFailure({required super.code, super.message});

  static const offline = NetworkFailure(code: 'NETWORK_OFFLINE');
  static const timeout = NetworkFailure(code: 'NETWORK_TIMEOUT');
  static const unknown = NetworkFailure(code: 'NETWORK_UNKNOWN');
}

/// API body `{ ok: false, error: { code, message } }` (api-contract.md).
final class ApiFailure extends AppFailure {
  const ApiFailure({required super.code, super.message});
}

/// Client form / guard validation (error-handling.md).
final class ValidationFailure extends AppFailure {
  const ValidationFailure({super.code = 'VALIDATION', super.message});
}

/// Invalid JSON / unexpected shape (error-handling.md `PARSE_ERROR`).
final class ParseFailure extends AppFailure {
  const ParseFailure({super.code = 'PARSE_ERROR', super.message});
}

/// Maps [DioException] / response bodies → [AppFailure] (error-handling.md §2).
abstract final class AppFailureMapper {
  static AppFailure fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const NetworkFailure(code: 'NETWORK_TIMEOUT');
      case DioExceptionType.connectionError:
        return const NetworkFailure(code: 'NETWORK_OFFLINE');
      case DioExceptionType.badCertificate:
        return const NetworkFailure(
          code: 'NETWORK_UNKNOWN',
          message: 'TLS certificate error',
        );
      case DioExceptionType.cancel:
        return const NetworkFailure(
          code: 'NETWORK_UNKNOWN',
          message: 'Request cancelled',
        );
      case DioExceptionType.badResponse:
        return fromHttpResponse(error.response);
      case DioExceptionType.unknown:
        final inner = error.error;
        if (inner is SocketException) {
          return const NetworkFailure(code: 'NETWORK_OFFLINE');
        }
        return const NetworkFailure(code: 'NETWORK_UNKNOWN');
    }
  }

  /// HTTP response (any status) body mapping.
  static AppFailure fromHttpResponse(Response<dynamic>? response) {
    if (response == null) {
      return const NetworkFailure(code: 'NETWORK_UNKNOWN');
    }

    final data = response.data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      if (map['ok'] == false) {
        return fromApiErrorBody(map);
      }
    }

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return const ParseFailure(message: 'Unexpected success body');
    }

    return const ApiFailure(code: 'INTERNAL_ERROR');
  }

  /// `{ ok: false, error: { code, message } }`.
  static AppFailure fromApiErrorBody(Map<String, dynamic> body) {
    final error = body['error'];
    if (error is Map) {
      final code = error['code']?.toString();
      final message = error['message']?.toString();
      if (code != null && code.isNotEmpty) {
        return ApiFailure(code: code, message: message);
      }
    }
    return const ApiFailure(code: 'INTERNAL_ERROR');
  }

  static AppFailure fromParse([String? detail]) {
    return ParseFailure(message: detail);
  }
}
