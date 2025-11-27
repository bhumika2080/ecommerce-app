import 'package:flutter/services.dart';
import 'package:flutter_module/models/app_config.dart';
import 'package:flutter_module/models/product.dart';

class NativeBridge {
  static const platform = MethodChannel('com.kotlin.kotlinapp/flutter_bridge');

  static Future<AppConfig> getAppConfig() async {
    try {
      final Map<dynamic, dynamic> result =
          await platform.invokeMethod('getAppConfig');
      return AppConfig.fromMap(result);
    } catch (e) {
      print('Error getting app config: $e');
      rethrow;
    }
  }

  static Future<void> sendPaymentPayload(Product product) async {
    try {
      await platform.invokeMethod('onPaymentSelected', {
        'productId': product.id,
        'productTitle': product.title,
        'price': product.price,
        'category': product.category,
      });
      print('Payment payload sent to native');
    } catch (e) {
      print('Error sending payment payload: $e');
    }
  }
}
