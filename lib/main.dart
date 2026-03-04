import 'package:apeiron/screens/image_selector_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ApeironApp());
}

class ApeironApp extends StatelessWidget {
  const ApeironApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ImageSelectorScreen(),
    );
  }
}