import '../../../core/error/app_failure.dart';
import '../../../core/network/api_client.dart';
import '../domain/pairing_repository.dart';
import '../domain/pairing_result.dart';
import 'pairing_dto.dart';

/// [PairingRepository] via ApiClient (api-contract.md Pairing).
class PairingRepositoryImpl implements PairingRepository {
  PairingRepositoryImpl({required this._apiClient});

  final ApiClient _apiClient;

  @override
  Future<PairingResult> start({required String nickname}) async {
    try {
      final data = await _apiClient.postAction(
        action: 'pairing.start',
        payload: <String, dynamic>{'nickname': nickname},
        memberId: '',
        sessionToken: '',
      );
      return PairingDto.fromStartData(data);
    } on AppFailure {
      rethrow;
    } on FormatException catch (e) {
      throw ParseFailure(message: e.message);
    } catch (e) {
      throw ParseFailure(message: e.toString());
    }
  }

  @override
  Future<PairingResult> signal({
    required String pairingSessionId,
    required String nickname,
  }) async {
    try {
      final data = await _apiClient.postAction(
        action: 'pairing.signal',
        payload: <String, dynamic>{
          'pairingSessionId': pairingSessionId,
          'nickname': nickname,
        },
        memberId: '',
        sessionToken: '',
      );
      return PairingDto.fromSignalOrStatusData(
        data,
        pairingSessionId: pairingSessionId,
      );
    } on AppFailure {
      rethrow;
    } on FormatException catch (e) {
      throw ParseFailure(message: e.message);
    } catch (e) {
      throw ParseFailure(message: e.toString());
    }
  }

  @override
  Future<PairingResult> status({required String pairingSessionId}) async {
    try {
      final data = await _apiClient.postAction(
        action: 'pairing.status',
        payload: <String, dynamic>{'pairingSessionId': pairingSessionId},
        memberId: '',
        sessionToken: '',
      );
      return PairingDto.fromSignalOrStatusData(
        data,
        pairingSessionId: pairingSessionId,
      );
    } on AppFailure {
      rethrow;
    } on FormatException catch (e) {
      throw ParseFailure(message: e.message);
    } catch (e) {
      throw ParseFailure(message: e.toString());
    }
  }
}
