import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/storage/secure_storage.dart';
import 'package:ourspace_app/core/storage/storage_keys.dart';

void main() {
  group('FakeSecureStorage session keys', () {
    late FakeSecureStorage storage;

    setUp(() {
      storage = FakeSecureStorage();
    });

    test('write_read_returnsStoredMemberIdAndSessionToken', () async {
      await storage.write(StorageKeys.memberId, 'member_test_1');
      await storage.write(StorageKeys.sessionToken, 'session_test_token');

      expect(await storage.read(StorageKeys.memberId), 'member_test_1');
      expect(
        await storage.read(StorageKeys.sessionToken),
        'session_test_token',
      );
    });

    test('delete_removesOnlyTargetKey', () async {
      await storage.write(StorageKeys.memberId, 'member_test_1');
      await storage.write(StorageKeys.sessionToken, 'session_test_token');

      await storage.delete(StorageKeys.sessionToken);

      expect(await storage.read(StorageKeys.memberId), 'member_test_1');
      expect(await storage.read(StorageKeys.sessionToken), isNull);
    });

    test('deleteAll_clearsMemberIdAndSessionToken', () async {
      await storage.write(StorageKeys.memberId, 'member_test_1');
      await storage.write(StorageKeys.sessionToken, 'session_test_token');

      await storage.deleteAll();

      expect(await storage.read(StorageKeys.memberId), isNull);
      expect(await storage.read(StorageKeys.sessionToken), isNull);
    });

    test('read_missingKey_returnsNull', () async {
      expect(await storage.read(StorageKeys.memberId), isNull);
      expect(await storage.read(StorageKeys.sessionToken), isNull);
    });
  });
}
