import 'package:apeiron/screens/image_selector_screen.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

void main() {
  runApp(const ApeironApp());
}

class ApeironApp extends StatelessWidget {
  const ApeironApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apeiron',
      theme: AppTheme.darkTheme,
      // Remova a linha 'home:' e use estas duas abaixo:
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}