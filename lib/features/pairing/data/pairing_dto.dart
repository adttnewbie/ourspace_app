import '../../session/domain/member.dart';
import '../domain/pairing_result.dart';

/// Parses documented pairing response data only (api-contract.md).
abstract final class PairingDto {
  /// `pairing.start` data → waiting (+ session id).
  static PairingResult fromStartData(Map<String, dynamic> data) {
    final pairingSessionId = data['pairingSessionId'];
    if (pairingSessionId is! String || pairingSessionId.isEmpty) {
      throw const FormatException('pairing.start missing pairingSessionId');
    }
    final expiresAt = _parseExpiresAt(data['expiresAt']);
    final status = data['status']?.toString();
    if (status == 'expired') {
      return const PairingExpiredResult();
    }
    return PairingWaiting(
      pairingSessionId: pairingSessionId,
      expiresAt: expiresAt,
    );
  }

  /// `pairing.signal` / `pairing.status` data (api-contract.md).
  static PairingResult fromSignalOrStatusData(
    Map<String, dynamic> data, {
    String? pairingSessionId,
  }) {
    final status = data['status']?.toString();
    if (status == 'expired') {
      return const PairingExpiredResult();
    }
    if (status == 'paired') {
      return _pairedFromData(data);
    }
    if (status == 'waiting') {
      final id = pairingSessionId;
      if (id == null || id.isEmpty) {
        final fromData = data['pairingSessionId'];
        if (fromData is! String || fromData.isEmpty) {
          throw const FormatException(
            'pairing waiting response missing pairingSessionId',
          );
        }
        return PairingWaiting(
          pairingSessionId: fromData,
          expiresAt: _parseExpiresAt(data['expiresAt']),
        );
      }
      return PairingWaiting(
        pairingSessionId: id,
        expiresAt: _parseExpiresAt(data['expiresAt']),
      );
    }
    throw FormatException('pairing unexpected status: $status');
  }

  static PairingPaired _pairedFromData(Map<String, dynamic> data) {
    final memberId = data['memberId'];
    final sessionToken = data['sessionToken'];
    final anniversaryRaw = data['anniversaryDate'];
    if (memberId is! String || memberId.isEmpty) {
      throw const FormatException('pairing.paired missing memberId');
    }
    if (sessionToken is! String || sessionToken.isEmpty) {
      throw const FormatException('pairing.paired missing sessionToken');
    }
    if (anniversaryRaw is! String || anniversaryRaw.isEmpty) {
      throw const FormatException('pairing.paired missing anniversaryDate');
    }

    final membersRaw = data['members'];
    final members = <Member>[];
    if (membersRaw is List) {
      for (final item in membersRaw) {
        if (item is Map) {
          members.add(_memberFromMap(Map<String, dynamic>.from(item)));
        }
      }
    }

    return PairingPaired(
      memberId: memberId,
      sessionToken: sessionToken,
      anniversaryDate: DateTime.parse(anniversaryRaw),
      members: members,
    );
  }

  static DateTime _parseExpiresAt(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      throw const FormatException('pairing missing expiresAt');
    }
    return DateTime.parse(raw);
  }

  static Member _memberFromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final nickname = map['nickname'];
    if (id is! String || id.isEmpty) {
      throw const FormatException('member.id required');
    }
    if (nickname is! String) {
      throw const FormatException('member.nickname required');
    }
    return Member(id: id, nickname: nickname);
  }
}
