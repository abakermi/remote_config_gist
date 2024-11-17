/// A generic wrapper for remote config values.
///
/// This class provides type-safe access to remote configuration values.
/// It wraps the actual value and ensures type safety when accessing it.
///
/// Example:
/// ```dart
/// final value = RemoteConfigValue<String>('Hello');
/// print(value.value); // Outputs: Hello
/// ```
class RemoteConfigValue<T> {
  /// The actual value of the remote config parameter.
  final T value;

  /// Creates a new [RemoteConfigValue] instance.
  /// 
  /// The [value] parameter is the actual value to be wrapped.
  RemoteConfigValue(this.value);
} 