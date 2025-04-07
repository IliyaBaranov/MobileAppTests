package com.example.currency_exchange

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.channel.api.data"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getCurrencyApiKey" -> {
                    try {
                        val apiKey = packageManager
                            .getApplicationInfo(packageName, PackageManager.GET_META_DATA)
                            .metaData
                            .getString("com.example.CURRENCY_API_KEY") ?: ""
                        result.success(apiKey)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to get API key", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}