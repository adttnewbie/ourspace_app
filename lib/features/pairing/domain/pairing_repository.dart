import 'pairing_result.dart';

/// Pairing aggregate access (docs/state-management.md §12).
abstract class PairingRepository {
  /// `pairing.start` — first need with nickname (api-contract.md).
  Future<PairingResult> start({required String nickname});

  /// `pairing.signal` — after 3s hold (api-contract.md).
  Future<PairingResult> signal({
    required String pairingSessionId,
    required String nickname,
  });

  /// `pairing.status` — poll while waiting (api-contract.md).
  Future<PairingResult> status({required String pairingSessionId});
}
