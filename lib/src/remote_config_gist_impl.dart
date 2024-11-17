import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'enums/remote_config_status.dart';
import 'extensions/remote_config_extensions.dart';

/// A class that manages remote configuration using GitHub Gists.
///
/// This class provides functionality to:
/// * Fetch remote configuration from a GitHub Gist
/// * Cache configuration locally
/// * Manage fetch intervals and timeouts
/// * Handle fetch failures with fallback to cached or default values
/// 
/// Example usage:
/// ```dart
/// final config = RemoteConfigGist(
///   gistId: 'your_gist_id',
///   filename: 'config.json',
///   defaultConfig: {'welcome_message': 'Hello'},
/// );
/// 
/// final configValues = await config.fetchConfig();
/// await config.activate();
/// 
/// final message = config.getValue<String>('welcome_message', 'Default');
/// ```
class RemoteConfigGist {
  final String gistId;
  final String filename;
  final Map<String, dynamic> defaultConfig;
  final Duration fetchInterval;
  final Duration timeout;

  RemoteConfigStatus _lastFetchStatus = RemoteConfigStatus.notFetched;
  DateTime? _lastFetchTime;
  Map<String, dynamic> _activeConfig = {};

  static const String _cacheKey = 'remote_config_cache';
  static const String _lastFetchTimeKey = 'remote_config_last_fetch_time';

  RemoteConfigStatus get lastFetchStatus => _lastFetchStatus;
  DateTime? get lastFetchTime => _lastFetchTime;

  RemoteConfigGist({
    required this.gistId,
    required this.filename,
    this.defaultConfig = const {},
    this.fetchInterval = const Duration(hours: 1),
    this.timeout = const Duration(seconds: 10),
  });

  Future<Map<String, dynamic>> fetchConfig({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final lastFetchTime = prefs.getInt(_lastFetchTimeKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    if (!forceRefresh && now - lastFetchTime < fetchInterval.inMilliseconds) {
      final cachedConfig = prefs.getString(_cacheKey);
      if (cachedConfig != null) {
        _lastFetchStatus = RemoteConfigStatus.throttled;
        return json.decode(cachedConfig);
      }
    }

    try {
      final response = await http
          .get(Uri.parse('https://gist.githubusercontent.com/raw/$gistId/$filename'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final config = json.decode(response.body) as Map<String, dynamic>;
        prefs.setString(_cacheKey, response.body);
        prefs.setInt(_lastFetchTimeKey, now);
        _lastFetchStatus = RemoteConfigStatus.success;
        _lastFetchTime = DateTime.now();
        return config;
      } else {
        _lastFetchStatus = RemoteConfigStatus.failure;
        final cachedConfig = prefs.getString(_cacheKey);
        if (cachedConfig != null) return json.decode(cachedConfig);
        return defaultConfig;
      }
    } catch (e) {
      _lastFetchStatus = RemoteConfigStatus.failure;
      final cachedConfig = prefs.getString(_cacheKey);
      if (cachedConfig != null) return json.decode(cachedConfig);
      return defaultConfig;
    }
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_lastFetchTimeKey);
    _activeConfig = {};
  }

  Future<bool> activate() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedConfig = prefs.getString(_cacheKey);
    if (cachedConfig != null) {
      _activeConfig = json.decode(cachedConfig);
      return true;
    }
    return false;
  }

  T getValue<T>(String key, T defaultValue) {
    return _activeConfig.getValue<T>(key, defaultValue).value;
  }
} 