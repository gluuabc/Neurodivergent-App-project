import 'package:flutter/material.dart';
import 'timer1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Neurodivergent App';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 244, 216),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 76, 111, 104),
          selectedItemColor: Color.fromARGB(255, 255, 244, 216),
          unselectedItemColor: Color.fromARGB(255, 255, 244, 216),
        ),
      ),
      home: const FirstRoute(appTitle: appTitle, name: 'Timer Track'),
    );
  }
}
