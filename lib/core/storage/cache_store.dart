import 'package:shared_preferences/shared_preferences.dart';

/// Primitive non-sensitive string cache (docs/architecture.md, packages.md).
///
/// No TTL / invalidation policy here — repositories own that later.
abstract class CacheStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<void> clear();
}

/// [SharedPreferences]-backed cache for non-secret JSON/flags.
class SharedPreferencesCacheStore implements CacheStore {
  SharedPreferencesCacheStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<SharedPreferencesCacheStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesCacheStore(prefs);
  }

  @override
  Future<String?> read(String key) async => _prefs.getString(key);

  @override
  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}

/// In-memory [CacheStore] for tests and pure memory use.
class InMemoryCacheStore implements CacheStore {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> clear() async {
    _values.clear();
  }
}
