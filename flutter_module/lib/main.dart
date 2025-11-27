import 'package:flutter/material.dart';
import 'package:flutter_module/models/app_config.dart';
import 'package:flutter_module/services/api_service.dart';
import 'package:flutter_module/services/native_bridge.dart';
import 'package:flutter_module/pages/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppConfig? _config;
  ApiService? _apiService;
  bool _isLoading = true;
  String? _error;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final config = await NativeBridge.getAppConfig();
      final apiService = ApiService(config.uuid);

      setState(() {
        _config = config;
        _apiService = apiService;
        _themeMode = config.themeMode;
        _isLoading = false;
      });

      print('Config loaded: UUID=${config.uuid.substring(0, 8)}...');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Error loading config: $e');
    }
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_error != null || _config == null || _apiService == null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${_error ?? "Failed to load config"}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadConfig,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Module',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: _config!.colors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _config!.colors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: _config!.colors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _config!.colors.primary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: ProductListPage(
        apiService: _apiService!,
        onThemeToggle: _toggleTheme,
        currentThemeMode: _themeMode,
      ),
    );
  }
}
