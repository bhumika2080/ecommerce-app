package com.kotlin.kotlinapp

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class FlutterBridgeActivity : FlutterActivity() {
    private val CHANNEL = "com.kotlin.kotlinapp/flutter_bridge"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAppConfig" -> {
                    val config = getAppConfiguration()
                    result.success(config)
                }
                "onPaymentSelected" -> {
                    val payload = call.arguments as? Map<*, *>
                    handlePaymentPayload(payload)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getAppConfiguration(): Map<String, Any> {
        val sharedPref = getSharedPreferences("AppPrefs", MODE_PRIVATE)
        val uuid = sharedPref.getString("cached_uuid", "") ?: ""

        return mapOf(
            "uuid" to uuid,
            "themeMode" to "light",
            "colors" to mapOf(
                "primary" to 0xFF6200EE.toInt(),
                "secondary" to 0xFF03DAC6.toInt(),
                "background" to 0xFFFFFFFF.toInt(),
                "surface" to 0xFFFFFFFF.toInt(),
                "error" to 0xFFB00020.toInt()
            ),
            "spacing" to mapOf(
                "small" to 8.0,
                "medium" to 16.0,
                "large" to 24.0,
                "extraLarge" to 32.0
            ),
            "typography" to mapOf(
                "headlineSize" to 24.0,
                "titleSize" to 20.0,
                "bodySize" to 16.0,
                "captionSize" to 12.0,
                "fontFamily" to "Roboto"
            )
        )
    }

    private fun handlePaymentPayload(payload: Map<*, *>?) {
        if (payload != null) {
            val productId = payload["productId"] as? Int
            val productTitle = payload["productTitle"] as? String
            val price = payload["price"] as? Double
            val category = payload["category"] as? String

            println("💰 Payment received:")
            println("   Product ID: $productId")
            println("   Product: $productTitle")
            println("   Price: $$price")
            println("   Category: $category")

            // Finish and return to native
            finish()
        }
    }
}
