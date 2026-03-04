import 'package:flutter/material.dart';

class AppTheme {
  static const Color goldColor = Color(0xFFFFD700); // Dourado clássico

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),

    // Configuração da AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: goldColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: goldColor),
    ),

    // Cor do botão de adicionar (FAB)
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: goldColor,
      foregroundColor: Colors.black,
    ),

    // Cor dos botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: goldColor,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}