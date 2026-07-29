import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/features/pairing/data/pairing_dto.dart';
import 'package:ourspace_app/features/pairing/domain/pairing_result.dart';

void main() {
  group('PairingDto', () {
    test('fromStartData_waiting_mapsFields', () {
      final result = PairingDto.fromStartData(<String, dynamic>{
        'pairingSessionId': 'pair_123',
        'status': 'waiting',
        'expiresAt': '2026-07-02T08:00:30.000Z',
      });
      expect(result, isA<PairingWaiting>());
      final waiting = result as PairingWaiting;
      expect(waiting.pairingSessionId, 'pair_123');
      expect(
        waiting.expiresAt.toUtc().toIso8601String(),
        '2026-07-02T08:00:30.000Z',
      );
    });

    test('fromSignalOrStatusData_waiting_usesKeepId', () {
      final result = PairingDto.fromSignalOrStatusData(
        <String, dynamic>{
          'status': 'waiting',
          'expiresAt': '2026-07-02T08:00:30.000Z',
        },
        pairingSessionId: 'pair_keep',
      );
      expect(result, isA<PairingWaiting>());
      expect((result as PairingWaiting).pairingSessionId, 'pair_keep');
    });

    test('fromSignalOrStatusData_paired_mapsSession', () {
      final result = PairingDto.fromSignalOrStatusData(<String, dynamic>{
        'status': 'paired',
        'memberId': 'member_a',
        'sessionToken': 'session_test_token',
        'anniversaryDate': '2026-07-02T08:00:12.000Z',
        'members': [
          {'id': 'member_a', 'nickname': 'Nama Kamu'},
          {'id': 'member_b', 'nickname': 'Nama Pasangan'},
        ],
      });
      expect(result, isA<PairingPaired>());
      final paired = result as PairingPaired;
      expect(paired.memberId, 'member_a');
      expect(paired.sessionToken, 'session_test_token');
      expect(paired.members.length, 2);
      expect(paired.members.first.nickname, 'Nama Kamu');
    });

    test('fromSignalOrStatusData_expired_status', () {
      final result = PairingDto.fromSignalOrStatusData(<String, dynamic>{
        'status': 'expired',
      });
      expect(result, isA<PairingExpiredResult>());
    });
  });
}
