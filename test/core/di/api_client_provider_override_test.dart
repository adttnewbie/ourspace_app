import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/network/api_client.dart';
import 'package:ourspace_app/core/network/network_providers.dart';

/// Minimal stand-in used only to prove [apiClientProvider] is overridable.
class _RecordingApiClient extends ApiClient {
  _RecordingApiClient() : super(Dio());

  int postActionCalls = 0;

  @override
  Future<Map<String, dynamic>> postAction({
    required String action,
    Map<String, dynamic>? payload,
    String? memberId,
    String? sessionToken,
    CancelToken? cancelToken,
  }) async {
    postActionCalls++;
    return <String, dynamic>{'action': action, 'ok': true};
  }
}

void main() {
  group('apiClientProvider overrides (step 1.9 DoD)', () {
    test('ProviderContainer_canOverride_apiClientProvider', () async {
      final fake = _RecordingApiClient();
      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      final client = container.read(apiClientProvider);
      expect(identical(client, fake), isTrue);

      final data = await client.postAction(action: 'health.check');
      expect(fake.postActionCalls, 1);
      expect(data['action'], 'health.check');
    });

    test('override_doesNotUseDefaultDioBackedClient', () {
      final fake = _RecordingApiClient();
      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      // Default tree would create ApiClient(dioProvider); override must win.
      expect(container.read(apiClientProvider), same(fake));
    });
  });
}
