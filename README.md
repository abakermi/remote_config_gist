# Remote Config Gist 🚀

[![pub package](https://img.shields.io/pub/v/remote_config_gist.svg)](https://pub.dartlang.org/packages/remote_config_gist)
[![likes](https://img.shields.io/pub/likes/remote_config_gist)](https://pub.dev/packages/remote_config_gist/score)
[![popularity](https://img.shields.io/pub/popularity/remote_config_gist)](https://pub.dev/packages/remote_config_gist/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A lightweight and easy-to-use Flutter package for remote configuration using GitHub Gists. Perfect for small to medium-sized apps that need remote configuration without the complexity of Firebase.

## Features ✨

- 🔄 Dynamic configuration updates
- 🔒 Type-safe configuration access
- ⚡️ Automatic caching mechanism
- ⏱️ Configurable fetch intervals
- 🌐 Offline support with fallback values
- 🎯 Zero external dependencies (except http)
- 📱 Cross-platform support

## Installation 📦

Add to your `pubspec.yaml`:

```yaml
dependencies:
  remote_config_gist: ^1.0.0
```

## Quick Start 🚀

1. Create a GitHub Gist with your config:

```json
{
  "welcome_message": "👋 Welcome to My App!",
  "is_feature_enabled": true,
  "theme_color": "#2196F3"
}
```

2. Initialize in your app:

```dart
final config = RemoteConfigGist(
  gistId: 'your_gist_id_here',
  filename: 'config.json',
  defaultConfig: {
    'welcome_message': 'Welcome!',
    'is_feature_enabled': false,
    'theme_color': '#000000',
  },
);

// Fetch and activate
await config.fetchConfig();
await config.activate();
```

3. Use the config values:

```dart
String message = config.getValue<String>('welcome_message', 'Default');
bool isEnabled = config.getValue<bool>('is_feature_enabled', false);
```

## Advanced Usage 🔥

### Type-Safe Config Keys

```dart
class AppConfig {
  static const String welcomeMessage = 'welcome_message';
  static const String isFeatureEnabled = 'is_feature_enabled';
  static const String themeColor = 'theme_color';
}
```

### Fetch with Options

```dart
final config = RemoteConfigGist(
  gistId: 'your_gist_id',
  filename: 'config.json',
  fetchInterval: Duration(hours: 12),
  timeout: Duration(seconds: 5),
);

// Force refresh
await config.fetchConfig(forceRefresh: true);
```

### Status Tracking

```dart
RemoteConfigStatus status = config.lastFetchStatus;
DateTime? lastFetch = config.lastFetchTime;
```

### Cache Management

```dart
// Clear cache
await config.clearCache();
```

## Best Practices 💡

1. Always provide default values
2. Handle fetch failures gracefully
3. Use type-safe config keys
4. Set appropriate fetch intervals
5. Monitor fetch status

## Configuration Structure 📝

Example of a well-structured config:

```json
{
  "app_config": {
    "version": "1.0.0",
    "maintenance_mode": false
  },
  "feature_flags": {
    "show_beta_features": false,
    "enable_analytics": true
  },
  "ui_config": {
    "theme_color": "#2196F3",
    "font_size": 16
  }
}
```

## Error Handling ⚠️

```dart
try {
  await config.fetchConfig();
  await config.activate();
} catch (e) {
  print('Config fetch failed: $e');
  // Handle error - will use cached/default values
}
```

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support ❤️

If you find this package helpful, please give it a ⭐️ on [GitHub](https://github.com/abakermi/remote_config_gist)!

## Alternatives 🔄

- Firebase Remote Config: More features, but requires Firebase setup
- AppConfig: Local-only configuration
- Feature Flags services: More complex feature flag management