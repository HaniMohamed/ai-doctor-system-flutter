import 'dart:convert';
import 'local_storage.dart';

class CacheManager {
  late LocalStorage _localStorage;
  final Map<String, CacheEntry> _memoryCache = {};

  CacheManager() {
    _localStorage = LocalStorage();
  }

  Future<void> initialize() async {
    await _localStorage.initialize();
  }

  Future<T?> get<T>(String key, {Duration? maxAge}) async {
    // Check memory cache first
    final memoryEntry = _memoryCache[key];
    if (memoryEntry != null && !memoryEntry.isExpired(maxAge)) {
      return memoryEntry.data as T;
    }

    // Check local storage
    final cachedData = _localStorage.getString(key);
    if (cachedData != null) {
      final data = jsonDecode(cachedData) as T;
      _memoryCache[key] = CacheEntry(data, DateTime.now());
      return data;
    }

    return null;
  }

  Future<void> set<T>(String key, T data, {Duration? ttl}) async {
    _memoryCache[key] = CacheEntry(data, DateTime.now());
    await _localStorage.setString(key, jsonEncode(data));
  }

  Future<void> remove(String key) async {
    _memoryCache.remove(key);
    await _localStorage.remove(key);
  }

  Future<void> clear() async {
    _memoryCache.clear();
    await _localStorage.clear();
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime timestamp;

  CacheEntry(this.data, this.timestamp);

  bool isExpired(Duration? maxAge) {
    if (maxAge == null) return false;
    return DateTime.now().difference(timestamp) > maxAge;
  }
}
