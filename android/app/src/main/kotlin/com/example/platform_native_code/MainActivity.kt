// In MainActivity.kt (Android host) - register the MethodChannel and respond to 'getDeviceInfo'
package com.example.platform_native_code // <- replace with your actual package

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "platformchannel.companyname.com/deviceinfo"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceInfo") {
                val info = "Manufacturer: ${Build.MANUFACTURER}, Model: ${Build.MODEL}, SDK: ${Build.VERSION.SDK_INT}"
                result.success(info)
            } else {
                result.notImplemented()
            }
        }
    }
}
