package com.example.strybuc

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.strybuc/ar_measurement"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startAR") {
                val intent = Intent(this, ARMeasurementActivity::class.java)
                startActivity(intent)
                result.success("AR Activity Started")
            } else {
                result.notImplemented()
            }
        }
    }
}