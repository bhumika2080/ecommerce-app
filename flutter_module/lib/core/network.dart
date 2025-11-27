import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(BaseOptions(
    baseUrl: 'https://fakestoreapi.com',
    headers: {
      'X-App-UUID': config.uuid,
    },
  ));

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
});
