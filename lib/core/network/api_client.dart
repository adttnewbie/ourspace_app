import 'package:dio/dio.dart';

import '../error/app_failure.dart';

/// Apps Script action client: single POST JSON envelope (api-contract.md).
///
/// Body shape:
/// `{ action, memberId, sessionToken, payload }`
/// Success: `{ ok: true, data }` → returns [data].
/// Failure: throws [AppFailure].
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  /// POST action JSON to [API_BASE_URL] (Dio baseUrl).
  ///
  /// [memberId] / [sessionToken] optional overrides; otherwise [AuthInterceptor]
  /// fills from secure storage (empty string if absent).
  Future<Map<String, dynamic>> postAction({
    required String action,
    Map<String, dynamic>? payload,
    String? memberId,
    String? sessionToken,
    CancelToken? cancelToken,
  }) async {
    final body = <String, dynamic>{
      'action': action,
      'payload': payload ?? <String, dynamic>{},
    };
    if (memberId != null) {
      body['memberId'] = memberId;
    }
    if (sessionToken != null) {
      body['sessionToken'] = sessionToken;
    }

    try {
      // baseUrl is full `/exec` URL — post relative empty path.
      final response = await _dio.post<dynamic>(
        '',
        data: body,
        cancelToken: cancelToken,
      );

      return _parseSuccess(response);
    } on DioException catch (e) {
      throw AppFailureMapper.fromDioException(e);
    } on AppFailure {
      rethrow;
    } catch (e) {
      throw AppFailureMapper.fromParse(e.toString());
    }
  }

  Map<String, dynamic> _parseSuccess(Response<dynamic> response) {
    final raw = response.data;

    if (raw is! Map) {
      throw const ParseFailure(message: 'Response is not a JSON object');
    }

    final map = Map<String, dynamic>.from(raw);

    if (map['ok'] == false) {
      throw AppFailureMapper.fromApiErrorBody(map);
    }

    if (map['ok'] != true) {
      throw const ParseFailure(message: 'Missing ok:true in response');
    }

    final data = map['data'];
    if (data == null) {
      return <String, dynamic>{};
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    // Non-map data (rare) — wrap for callers that only expect maps.
    return <String, dynamic>{'value': data};
  }
}
