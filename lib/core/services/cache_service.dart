import 'dart:convert';

/// Simple in-memory cache service for API responses
/// Reduces database calls and improves performance
class CacheService {
  static final CacheService instance = CacheService._();
  CacheService._();

  final Map<String, _CacheEntry> _cache = {};
  
  // Default cache duration: 5 minutes
  final Duration _defaultDuration = const Duration(minutes: 5);

  /// Get cached data
  /// Returns null if not found or expired
  T? get<T>(String key) {
    final entry = _cache[key];
    
    if (entry == null) {
      return null;
    }
    
    // Check if expired
    if (DateTime.now().isAfter(entry.expiry)) {
      _cache.remove(key);
      return null;
    }
    
    return entry.data as T;
  }

  /// Set cache data
  void set<T>(String key, T data, {Duration? duration}) {
    final expiry = DateTime.now().add(duration ?? _defaultDuration);
    _cache[key] = _CacheEntry(data: data, expiry: expiry);
  }

  /// Check if key exists and is valid
  bool has(String key) {
    final entry = _cache[key];
    
    if (entry == null) {
      return false;
    }
    
    if (DateTime.now().isAfter(entry.expiry)) {
      _cache.remove(key);
      return false;
    }
    
    return true;
  }

  /// Remove specific key
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
  }

  /// Clear expired entries
  void clearExpired() {
    final now = DateTime.now();
    _cache.removeWhere((key, entry) => now.isAfter(entry.expiry));
  }

  /// Get cache stats
  Map<String, dynamic> getStats() {
    final now = DateTime.now();
    final valid = _cache.values.where((e) => now.isBefore(e.expiry)).length;
    final expired = _cache.length - valid;
    
    return {
      'total': _cache.length,
      'valid': valid,
      'expired': expired,
    };
  }

  /// Generate cache key from endpoint and params
  String generateKey(String endpoint, [Map<String, dynamic>? params]) {
    if (params == null || params.isEmpty) {
      return endpoint;
    }
    
    final sortedKeys = params.keys.toList()..sort();
    final paramsStr = sortedKeys.map((k) => '$k=${params[k]}').join('&');
    return '$endpoint?$paramsStr';
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiry;

  _CacheEntry({
    required this.data,
    required this.expiry,
  });
}
