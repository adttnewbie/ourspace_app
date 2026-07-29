import 'package:dio/dio.dart';

import '../error/app_log.dart';

/// Debug request/response logging without secrets (error-handling.md §8, security.md §7).
///
/// May log: action name, error code, duration, success, HTTP status.
/// Must not log: sessionToken, auth headers, full credential bodies.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final action = _actionOf(options.data);
    AppLog.d('HTTP → ${options.method} action=$action');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final action = _actionOf(response.requestOptions.data);
    final ok = _okFlag(response.data);
    AppLog.d('HTTP ← status=${response.statusCode} action=$action ok=$ok');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final action = _actionOf(err.requestOptions.data);
    AppLog.w(
      'HTTP ✕ type=${err.type.name} action=$action status=${err.response?.statusCode}',
    );
    handler.next(err);
  }

  static String _actionOf(Object? data) {
    if (data is Map && data['action'] != null) {
      return data['action'].toString();
    }
    return '-';
  }

  static bool? _okFlag(Object? data) {
    if (data is Map && data.containsKey('ok')) {
      return data['ok'] == true;
    }
    return null;
  }
}
