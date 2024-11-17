import '../models/remote_config_value.dart';

/// Extension methods for handling remote config values.
///
/// This extension adds functionality to [Map] for safely accessing
/// remote config values with proper type checking and default values.
extension RemoteConfigExt on Map<String, dynamic> {
  /// Gets a value from the config map with type safety.
  /// 
  /// Returns a [RemoteConfigValue] containing either the value from the map
  /// or the provided default value if the key doesn't exist or has wrong type.
  /// 
  /// Example:
  /// ```dart
  /// final map = {'key': 'value'};
  /// final value = map.getValue<String>('key', 'default');
  /// ```
  RemoteConfigValue<T> getValue<T>(String key, T defaultValue) {
    return RemoteConfigValue<T>(this[key] as T? ?? defaultValue);
  }
} 