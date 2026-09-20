import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ChakshuApp());
}

class ChakshuApp extends StatelessWidget {
  const ChakshuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHAKSHU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}