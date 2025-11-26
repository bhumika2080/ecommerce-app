package com.kotlin.kotlinapp

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class FlutterFragment : Fragment() {

    private var flutterView: FlutterView? = null
    private var flutterEngine: FlutterEngine? = null
    private var methodChannel: MethodChannel? = null

    companion object {
        private const val ENGINE_ID = "flutter_engine"
        private const val CHANNEL_NAME = "com.kotlin.kotlinapp/flutter"
        
        fun newInstance(uuid: String): FlutterFragment {
            val fragment = FlutterFragment()
            val args = Bundle()
            args.putString("uuid", uuid)
            fragment.arguments = args
            return fragment
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Get or create Flutter engine
        flutterEngine = FlutterEngineCache.getInstance().get(ENGINE_ID)
        
        if (flutterEngine == null) {
            flutterEngine = FlutterEngine(requireContext())
            
            // Start executing Dart code
            flutterEngine!!.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            
            // Cache the engine
            FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine!!)
        }

        // Create FlutterView
        flutterView = FlutterView(requireContext())
        flutterView!!.attachToFlutterEngine(flutterEngine!!)

        // Setup MethodChannel
        setupMethodChannel()

        // Pass initial data to Flutter
        passInitialDataToFlutter()

        return flutterView
    }

    private fun setupMethodChannel() {
        methodChannel = MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            CHANNEL_NAME
        )

        methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "pay" -> {
                    // Handle payment callback from Flutter
                    val productData = call.arguments as? Map<String, Any>
                    handlePayment(productData)
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun passInitialDataToFlutter() {
        val uuid = arguments?.getString("uuid") ?: ""
        
        // Get app configurations from SharedPreferences or use defaults
        val sharedPref = requireActivity().getSharedPreferences("AppPrefs", Context.MODE_PRIVATE)
        
        val config = mapOf(
            "uuid" to uuid,
            "themeMode" to "light",
            "primaryColor" to "#6200EE",
            "secondaryColor" to "#03DAC6",
            "spacing" to 16,
            "fontFamily" to "Roboto"
        )

        // Send config to Flutter
        methodChannel?.invokeMethod("initialize", config)
    }

    private fun handlePayment(productData: Map<String, Any>?) {
        if (productData != null) {
            val productId = productData["id"]
            val title = productData["title"]
            val price = productData["price"]
            
            // Show toast with product info
            Toast.makeText(
                requireContext(),
                "Payment initiated for: $title ($$price)",
                Toast.LENGTH_LONG
            ).show()

            // Here you can:
            // 1. Navigate back to native screens
            // 2. Process the payment
            // 3. Save the order
            // etc.
            
            // For now, just log the data
            android.util.Log.d("FlutterFragment", "Payment data: $productData")
        }
    }

    override fun onStart() {
        super.onStart()
        flutterView?.attachToFlutterEngine(flutterEngine!!)
    }

    override fun onResume() {
        super.onResume()
        flutterEngine?.lifecycleChannel?.appIsResumed()
    }

    override fun onPause() {
        super.onPause()
        flutterEngine?.lifecycleChannel?.appIsInactive()
    }

    override fun onStop() {
        super.onStop()
        flutterEngine?.lifecycleChannel?.appIsPaused()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        flutterView?.detachFromFlutterEngine()
        flutterView = null
    }

    override fun onDestroy() {
        super.onDestroy()
        // Don't destroy the engine here as it's cached for reuse
        // Only destroy when the app is truly closing
    }
}
