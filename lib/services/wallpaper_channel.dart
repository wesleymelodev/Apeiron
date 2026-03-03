import 'package:flutter/services.dart';

class WallpaperChannel {
  // O nome do canal deve ser único e coincidir com o Kotlin
  static const _platform = MethodChannel('com.ancrolyn.apeiron.apeiron/wallpaper');

  static Future<void> sendImagePaths(List<String> paths) async {
    try {
      await _platform.invokeMethod('updateImages', {'paths': paths});
    } on PlatformException catch (e) {
      print("Erro ao enviar caminhos: ${e.message}");
    }
  }

  static Future<void> openWallpaperSettings() async {
    try {
      await _platform.invokeMethod('openSettings');
    } on PlatformException catch (e) {
      print("Erro ao abrir configurações: ${e.message}");
    }
  }
}