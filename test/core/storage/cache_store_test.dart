import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/storage/cache_store.dart';

void main() {
  group('InMemoryCacheStore', () {
    late InMemoryCacheStore store;

    setUp(() {
      store = InMemoryCacheStore();
    });

    test('write_read_delete_clear_stringValues', () async {
      await store.write('cache.sample', '{"ok":true}');
      expect(await store.read('cache.sample'), '{"ok":true}');

      await store.delete('cache.sample');
      expect(await store.read('cache.sample'), isNull);

      await store.write('a', '1');
      await store.write('b', '2');
      await store.clear();
      expect(await store.read('a'), isNull);
      expect(await store.read('b'), isNull);
    });
  });
}
