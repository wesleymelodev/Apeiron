import 'package:flutter/material.dart';
import 'screens/image_selector_screen.dart';
import 'screens/about_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/about';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const ImageSelectorScreen(),
    about: (context) => const AboutScreen(),
  };
}