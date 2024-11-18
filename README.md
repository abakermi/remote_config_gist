# Remote Config Gist

[![pub package](https://img.shields.io/pub/v/remote_config_gist.svg)](https://pub.dartlang.org/packages/remote_config_gist)

A Flutter Package that use github gist for remote config

## Installing

```yaml
dependencies:
  remote_config_gist: ^1.0.0
```

## ⚡️ Import

```dart
import 'package:remote_config_gist/remote_config_gist.dart'
```

## 🎮 How To Use

```dart
// Example config type for type safety
class AppConfig {
static const String welcomeMessage = 'welcome_message';
static const String isFeatureEnabled = 'is_feature_enabled';
static const String themeColor = 'theme_color';
}
final config = RemoteConfigGist(
gistId: '8472c3ccd8d90471672eeefc123cd054',
filename: 'config.json',
defaultConfig: {
AppConfig.welcomeMessage: 'Welcome to the app!',
AppConfig.isFeatureEnabled: false,
AppConfig.themeColor: '#FF0000',
},
fetchInterval: const Duration(minutes: 30),
timeout: const Duration(seconds: 5),
);
// Initial fetch and activate
await config.fetchConfig();
await config.activate();
// Get values
String message = config.getValue<String>(AppConfig.welcomeMessage, 'Default Welcome');
bool isEnabled = config.getValue<bool>(AppConfig.isFeatureEnabled, false);
```

## 🚀 Features

- Dynamic welcome message updates
- Feature flag management  
- Remote configuration refresh
- Cross-platform support

## 🐛 Bugs/Requests

If you encounter any problems feel free to open an issue. If you feel the library is missing a feature, please raise a ticket on Github and I'll look into it. Pull requests are also welcome.

## ⭐️ License

MIT License