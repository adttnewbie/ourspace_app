import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/core/error/app_log.dart';
import 'package:ourspace_app/core/network/api_client.dart';
import 'package:ourspace_app/core/network/auth_interceptor.dart';
import 'package:ourspace_app/core/network/logging_interceptor.dart';
import 'package:ourspace_app/core/storage/secure_storage.dart';
import 'package:ourspace_app/core/storage/storage_keys.dart';

/// Mock adapter for Dio unit tests (docs/testing.md, implementation-order 1.6).
class _ScriptMockAdapter implements HttpClientAdapter {
  _ScriptMockAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonBody(Map<String, dynamic> json, {int status = 200}) {
  return ResponseBody.fromString(
    jsonEncode(json),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  group('AppLog.redact', () {
    test('redact_sessionToken_and_nestedMaps', () {
      final redacted = AppLog.redact({
        'action': 'notes.list',
        'sessionToken': 'secret_should_not_appear',
        'memberId': 'member_1',
        'payload': {'token': 'also_secret', 'body': 'ok text'},
      }) as Map;

      expect(redacted['sessionToken'], '***');
      expect(redacted['action'], 'notes.list');
      expect(redacted['memberId'], 'member_1');
      final payload = redacted['payload'] as Map;
      expect(payload['token'], '***');
      expect(payload['body'], 'ok text');
      expect(jsonEncode(redacted), isNot(contains('secret_should_not_appear')));
      expect(jsonEncode(redacted), isNot(contains('also_secret')));
    });
  });

  group('AppFailureMapper', () {
    test('mapDioException_connectionError_returnsNetworkOffline', () {
      final failure = AppFailureMapper.fromDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.code, 'NETWORK_OFFLINE');
    });

    test('mapDioException_receiveTimeout_returnsNetworkTimeout', () {
      final failure = AppFailureMapper.fromDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.receiveTimeout,
        ),
      );
      expect(failure.code, 'NETWORK_TIMEOUT');
    });

    test('fromApiErrorBody_unauthorized', () {
      final failure = AppFailureMapper.fromApiErrorBody({
        'ok': false,
        'error': {'code': 'UNAUTHORIZED', 'message': 'Invalid token'},
      });
      expect(failure, isA<ApiFailure>());
      expect(failure.code, 'UNAUTHORIZED');
      expect(failure.message, 'Invalid token');
    });
  });

  group('ApiClient mock adapter', () {
    late FakeSecureStorage storage;
    late Dio dio;
    late ApiClient client;
    late List<String> capturedBodies;

    setUp(() {
      storage = FakeSecureStorage();
      capturedBodies = <String>[];
      dio = Dio(
        BaseOptions(
          baseUrl: 'https://example.test/exec',
          headers: const {'Content-Type': 'application/json'},
        ),
      );
      dio.interceptors.addAll([AuthInterceptor(storage), LoggingInterceptor()]);
      client = ApiClient(dio);
    });

    test('postAction_okJson_returnsData', () async {
      dio.httpClientAdapter = _ScriptMockAdapter((options) async {
        capturedBodies.add(jsonEncode(options.data));
        return _jsonBody({
          'ok': true,
          'data': {'hello': 'world'},
        });
      });

      final data = await client.postAction(action: 'health.check');
      expect(data['hello'], 'world');
      expect(capturedBodies.single, contains('health.check'));
      expect(capturedBodies.single, contains('memberId'));
      expect(capturedBodies.single, contains('sessionToken'));
    });

    test('postAction_errorJson_throwsApiFailure', () async {
      dio.httpClientAdapter = _ScriptMockAdapter((options) async {
        return _jsonBody({
          'ok': false,
          'error': {'code': 'UNAUTHORIZED', 'message': 'Invalid token'},
        });
      });

      expect(
        () => client.postAction(action: 'session.resume'),
        throwsA(
          isA<ApiFailure>()
              .having((e) => e.code, 'code', 'UNAUTHORIZED')
              .having((e) => e.message, 'message', 'Invalid token'),
        ),
      );
    });

    test('authInterceptor_attachesStoredCredentials', () async {
      await storage.write(StorageKeys.memberId, 'member_abc');
      await storage.write(StorageKeys.sessionToken, 'session_xyz');

      Map<String, dynamic>? sent;
      dio.httpClientAdapter = _ScriptMockAdapter((options) async {
        sent = Map<String, dynamic>.from(options.data as Map);
        return _jsonBody({'ok': true, 'data': {}});
      });

      await client.postAction(action: 'home.get');

      expect(sent?['memberId'], 'member_abc');
      expect(sent?['sessionToken'], 'session_xyz');
      expect(sent?['action'], 'home.get');
      expect(sent?['payload'], isA<Map>());
    });

    test('postAction_connectionError_throwsNetworkOffline', () async {
      dio.httpClientAdapter = _ScriptMockAdapter((options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );
      });

      expect(
        () => client.postAction(action: 'notes.list'),
        throwsA(
          isA<NetworkFailure>().having(
            (e) => e.code,
            'code',
            'NETWORK_OFFLINE',
          ),
        ),
      );
    });

    test('logging_and_redact_neverExposeSessionTokenInRedactedMaps', () {
      final redacted = AppLog.redact({
        'sessionToken': 'session_xyz_real',
        'action': 'notes.list',
      });
      final encoded = jsonEncode(redacted);
      expect(encoded, isNot(contains('session_xyz_real')));
      expect(encoded, contains('***'));
    });
  });
}
