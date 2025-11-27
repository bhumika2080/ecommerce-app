import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config.dart';
import 'package:flutter/material.dart';

final appConfigProvider = StateProvider<AppConfig>((ref) {
  return AppConfig(
    uuid: '',
    themeMode: ThemeMode.system,
    primaryColor: Colors.blue,
  );
});
