import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/error/app_failure.dart';
import 'package:ourspace_app/core/network/api_client.dart';
import 'package:ourspace_app/core/storage/secure_storage.dart';
import 'package:ourspace_app/features/settings/data/settings_repository_impl.dart';

class _MemSecure implements SecureStorage {
  final map = <String, String>{};

  @override
  Future<void> delete(String key) async => map.remove(key);

  @override
  Future<void> deleteAll() async => map.clear();

  @override
  Future<String?> read(String key) async => map[key];

  @override
  Future<void> write(String key, String value) async => map[key] = value;
}

void main() {
  group('SettingsRepositoryImpl (step 2.5)', () {
    late Dio dio;
    late SettingsRepositoryImpl repo;
    var healthCalls = 0;

    setUp(() {
      healthCalls = 0;
      dio = Dio(BaseOptions(baseUrl: 'https://example.test/exec'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final data = options.data;
            final action = data is Map ? data['action'] : null;
            if (action == 'health.check') {
              healthCalls++;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: <String, dynamic>{
                    'ok': true,
                    'data': <String, dynamic>{'status': 'up'},
                  },
                ),
              );
              return;
            }
            handler.reject(
              DioException(
                requestOptions: options,
                error: 'unexpected action $action',
              ),
            );
          },
        ),
      );
      // Auth interceptor not required for health — ApiClient posts bare action.
      repo = SettingsRepositoryImpl(apiClient: ApiClient(dio));
    });

    test('checkHealth_postsHealthCheck', () async {
      await repo.checkHealth();
      expect(healthCalls, 1);
    });

    test('checkHealth_apiError_throwsApiFailure', () async {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: <String, dynamic>{
                  'ok': false,
                  'error': <String, dynamic>{
                    'code': 'INTERNAL_ERROR',
                    'message': 'boom',
                  },
                },
              ),
            );
          },
        ),
      );
      final failing = SettingsRepositoryImpl(apiClient: ApiClient(dio));
      expect(
        () => failing.checkHealth(),
        throwsA(
          isA<ApiFailure>().having((e) => e.code, 'code', 'INTERNAL_ERROR'),
        ),
      );
    });
  });
}
