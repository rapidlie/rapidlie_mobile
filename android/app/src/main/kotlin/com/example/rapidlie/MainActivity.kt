package com.example.rapidlie

import io.flutter.embedding.android.FlutterActivity
import com.baseflow.permissionhandler.PermissionHandlerPlugin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine.plugins.add(PermissionHandlerPlugin())
    }
}
