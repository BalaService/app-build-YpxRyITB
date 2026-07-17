import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterwebapp/screen/webview_screen.dart';

class AppConfig {
  final String appName;
  final String url;
  final String packageName;
  final String themeColor;
  final bool toolbar;
  final bool pullToRefresh;

  AppConfig({
    required this.appName,
    required this.url,
    required this.packageName,
    required this.themeColor,
    required this.toolbar,
    required this.pullToRefresh,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['appName'] as String? ?? 'My Web App',
      url: json['url'] as String? ?? 'https://example.com',
      packageName: json['packageName'] as String? ?? 'com.example.app',
      themeColor: json['themeColor'] as String? ?? '#0099FF',
      toolbar: json['toolbar'] as bool? ?? true,
      pullToRefresh: json['pullToRefresh'] as bool? ?? true,
    );
  }
}

Future<AppConfig> loadConfig() async {
  final jsonString = await rootBundle.loadString('assets/config.json');
  final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
  return AppConfig.fromJson(jsonMap);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await loadConfig();
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final AppConfig config;
  const MyApp({super.key, required this.config});

  Color _parseHexColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      theme: ThemeData(
        colorSchemeSeed: _parseHexColor(config.themeColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: WebViewerScreen(
        url: config.url,
        config: config,
      ),
    );
  }
}
