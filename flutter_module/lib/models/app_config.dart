import 'package:flutter/material.dart';

class AppConfig {
  final String uuid;
  final ThemeMode themeMode;
  final AppColors colors;
  final AppSpacing spacing;
  final AppTypography typography;

  AppConfig({
    required this.uuid,
    required this.themeMode,
    required this.colors,
    required this.spacing,
    required this.typography,
  });

  factory AppConfig.fromMap(Map<dynamic, dynamic> map) {
    return AppConfig(
      uuid: map['uuid'] as String? ?? '',
      themeMode: _parseThemeMode(map['themeMode'] as String?),
      colors: AppColors.fromMap(map['colors'] as Map? ?? {}),
      spacing: AppSpacing.fromMap(map['spacing'] as Map? ?? {}),
      typography: AppTypography.fromMap(map['typography'] as Map? ?? {}),
    );
  }

  static ThemeMode _parseThemeMode(String? mode) {
    switch (mode?.toLowerCase()) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}

class AppColors {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;

  AppColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
  });

  factory AppColors.fromMap(Map<dynamic, dynamic> map) {
    return AppColors(
      primary: Color(map['primary'] as int? ?? 0xFF6200EE),
      secondary: Color(map['secondary'] as int? ?? 0xFF03DAC6),
      background: Color(map['background'] as int? ?? 0xFFFFFFFF),
      surface: Color(map['surface'] as int? ?? 0xFFFFFFFF),
      error: Color(map['error'] as int? ?? 0xFFB00020),
    );
  }
}

class AppSpacing {
  final double small;
  final double medium;
  final double large;
  final double extraLarge;

  AppSpacing({
    required this.small,
    required this.medium,
    required this.large,
    required this.extraLarge,
  });

  factory AppSpacing.fromMap(Map<dynamic, dynamic> map) {
    return AppSpacing(
      small: (map['small'] as num?)?.toDouble() ?? 8.0,
      medium: (map['medium'] as num?)?.toDouble() ?? 16.0,
      large: (map['large'] as num?)?.toDouble() ?? 24.0,
      extraLarge: (map['extraLarge'] as num?)?.toDouble() ?? 32.0,
    );
  }
}

class AppTypography {
  final double headlineSize;
  final double titleSize;
  final double bodySize;
  final double captionSize;
  final String fontFamily;

  AppTypography({
    required this.headlineSize,
    required this.titleSize,
    required this.bodySize,
    required this.captionSize,
    required this.fontFamily,
  });

  factory AppTypography.fromMap(Map<dynamic, dynamic> map) {
    return AppTypography(
      headlineSize: (map['headlineSize'] as num?)?.toDouble() ?? 24.0,
      titleSize: (map['titleSize'] as num?)?.toDouble() ?? 20.0,
      bodySize: (map['bodySize'] as num?)?.toDouble() ?? 16.0,
      captionSize: (map['captionSize'] as num?)?.toDouble() ?? 12.0,
      fontFamily: map['fontFamily'] as String? ?? 'Roboto',
    );
  }
}
