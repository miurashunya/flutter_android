package com.example.flutter_android

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.flutter_android/bridge"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openNativeScreen" -> {
                    val intent = Intent(this, NativeActivity::class.java)
                    startActivity(intent)
                    result.success(null)
                }
                "saveCount" -> {
                    val count = call.argument<Int>("count") ?: 0
                    val prefs = getSharedPreferences("flutter_state", MODE_PRIVATE)
                    prefs.edit().putInt("count", count).apply()
                    result.success(null)
                }
                "getCount" -> {
                    val prefs = getSharedPreferences("flutter_state", MODE_PRIVATE)
                    val count = prefs.getInt("count", 0)
                    result.success(count)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
