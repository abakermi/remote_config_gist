import 'package:flutter/material.dart';
import 'package:remote_config_gist/remote_config_gist.dart';

// Example config type for type safety
class AppConfig {
  static const String welcomeMessage = 'welcome_message';
  static const String isFeatureEnabled = 'is_feature_enabled';
  static const String themeColor = 'theme_color';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(MyApp(remoteConfig: config));
}

class MyApp extends StatefulWidget {
  final RemoteConfigGist remoteConfig;

  const MyApp({super.key, required this.remoteConfig});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConfigDemoScreen(remoteConfig: widget.remoteConfig),
    );
  }
}

class ConfigDemoScreen extends StatefulWidget {
  final RemoteConfigGist remoteConfig;

  const ConfigDemoScreen({super.key, required this.remoteConfig});

  @override
  State<ConfigDemoScreen> createState() => _ConfigDemoScreenState();
}

class _ConfigDemoScreenState extends State<ConfigDemoScreen> {
  String _welcomeMessage = '';
  bool _isFeatureEnabled = false;
  String _lastFetchStatus = '';

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() {
    setState(() {
      _welcomeMessage = widget.remoteConfig.getValue<String>(
        AppConfig.welcomeMessage,
        'Default Welcome',
      );
      _isFeatureEnabled = widget.remoteConfig.getValue<bool>(
        AppConfig.isFeatureEnabled,
        false,
      );
      _lastFetchStatus = widget.remoteConfig.lastFetchStatus.name;
    });
    return Future.value();
  }

  Future<void> _refreshConfig() async {
    try {
      await widget.remoteConfig.fetchConfig(forceRefresh: true);
      await widget.remoteConfig.activate();
      await _loadConfig();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Config refreshed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error refreshing config: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Config Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Message: $_welcomeMessage',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Feature Enabled: $_isFeatureEnabled',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Last Fetch Status: $_lastFetchStatus',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _refreshConfig,
                child: const Text('Refresh Config'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
