import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
            home:  SplashScreen(),
      debugShowCheckedModeBanner: false, // Optional: Hides the debug banner
    );
  }
}
