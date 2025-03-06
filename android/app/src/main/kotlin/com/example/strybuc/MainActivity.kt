package com.example.strybuc

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "ar_measurement"
    private val REQUEST_AR_MEASUREMENT = 1001
    private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "startAR") {
                val screenshotSize = call.arguments<Int>()
                Log.d("ARMeasurementActivity MainActivity", "Screenshot Count From MainActivity arguments: ${call.arguments}")
                val intent = Intent(this, ARMeasurementActivity::class.java)
                intent.putExtra("screenshotCount", screenshotSize)
                startActivityForResult(intent, REQUEST_AR_MEASUREMENT)
                result.success("AR Activity Started")
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_AR_MEASUREMENT && resultCode == Activity.RESULT_OK) {
            Log.d("MainActivity screenshots", data?.getStringArrayListExtra("screenshots").toString())
            val screenshotPaths = data?.getStringArrayListExtra("screenshots") ?: arrayListOf()

            // Send screenshots list to Flutter
            methodChannel.invokeMethod("screenshotsCaptured", screenshotPaths)
        }
    }
}