import 'package:flutter/material.dart';

class AppConfig {
  final String uuid;
  final ThemeMode themeMode;
  final Color primaryColor;

  AppConfig({
    required this.uuid,
    required this.themeMode,
    required this.primaryColor,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      uuid: json['uuid'] as String? ?? '',
      themeMode: _parseThemeMode(json['themeMode'] as String?),
      primaryColor: _parseColor(json['primaryColor'] as String?),
    );
  }

  static ThemeMode _parseThemeMode(String? mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  static Color _parseColor(String? colorHex) {
    if (colorHex == null) return Colors.blue;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.blue;
    }
  }
}
