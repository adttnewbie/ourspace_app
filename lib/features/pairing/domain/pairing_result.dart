import '../../session/domain/member.dart';

/// Outcome of pairing.start / signal / status (api-contract.md Pairing).
sealed class PairingResult {
  const PairingResult();
}

/// Waiting for partner within the pairing window.
final class PairingWaiting extends PairingResult {
  const PairingWaiting({
    required this.pairingSessionId,
    required this.expiresAt,
  });

  final String pairingSessionId;
  final DateTime expiresAt;
}

/// Both devices paired; client must persist session.
final class PairingPaired extends PairingResult {
  const PairingPaired({
    required this.memberId,
    required this.sessionToken,
    required this.anniversaryDate,
    required this.members,
  });

  final String memberId;
  final String sessionToken;
  final DateTime anniversaryDate;
  final List<Member> members;
}

/// Server reported pairing session expired (status field).
final class PairingExpiredResult extends PairingResult {
  const PairingExpiredResult();
}
