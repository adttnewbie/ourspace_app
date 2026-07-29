import 'package:flutter/foundation.dart';

/// Tiny logger with secret redaction (docs/security.md §7, error-handling.md §8).
abstract final class AppLog {
  static final RegExp _sensitiveKey = RegExp(
    r'(token|session|authorization|password|base64)',
    caseSensitive: false,
  );

  static void d(String message, [Object? data]) {
    if (kDebugMode) {
      debugPrint('[OurSpace][D] $message${_suffix(data)}');
    }
  }

  static void w(String message, [Object? data]) {
    debugPrint('[OurSpace][W] $message${_suffix(data)}');
  }

  static void e(String message, [Object? data]) {
    debugPrint('[OurSpace][E] $message${_suffix(data)}');
  }

  static String _suffix(Object? data) {
    if (data == null) return '';
    return ' ${redact(data)}';
  }

  /// Redacts map/list values whose keys match token/session/base64 patterns.
  static Object? redact(Object? value) {
    if (value == null) return null;
    if (value is Map) {
      return value.map((key, v) {
        final k = key.toString();
        if (_sensitiveKey.hasMatch(k)) {
          return MapEntry(k, '***');
        }
        return MapEntry(k, redact(v));
      });
    }
    if (value is List) {
      return value.map(redact).toList();
    }
    if (value is String) {
      return value;
    }
    return value;
  }
}
