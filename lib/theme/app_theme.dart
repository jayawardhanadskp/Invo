import 'package:flutter/material.dart';

class AppTheme {
  
  static ThemeData get lightTheme {
    return ThemeData(
      // brightness: Brightness.light,
      fontFamily: 'Inter_18pt-Regular',
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFB39CD0),),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      // brightness: Brightness.dark,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: Color(0xFF01031A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFB39CD0),),
      
    );
  }
}