package com.ancrolyn.apeiron.apeiron

import android.app.WallpaperManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.ancrolyn.apeiron.apeiron/wallpaper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "updateImages" -> {
                    val paths = call.argument<List<String>>("paths")
                    savePathsToPrefs(paths)
                    result.success(null)
                }
                "openSettings" -> {
                    openWallpaperPicker()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun savePathsToPrefs(paths: List<String>?) {
        val sharedPref = this.getSharedPreferences("ApeironPrefs", Context.MODE_PRIVATE)
        val editor = sharedPref.edit()
        editor.putStringSet("image_paths", paths?.toSet())
        editor.apply()
    }

    private fun openWallpaperPicker() {
        try {
            val intent = Intent(WallpaperManager.ACTION_CHANGE_LIVE_WALLPAPER)
            intent.putExtra(WallpaperManager.EXTRA_LIVE_WALLPAPER_COMPONENT,
                ComponentName(this, ApeironWallpaperService::class.java))
            startActivity(intent)
        } catch (e: Exception) {
            // Fallback para dispositivos onde a Intent direta falha
            val intent = Intent(WallpaperManager.ACTION_LIVE_WALLPAPER_CHOOSER)
            startActivity(intent)
        }
    }
}