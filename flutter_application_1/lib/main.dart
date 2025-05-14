import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'alarm_provider.dart';
import 'start.dart';
import 'package:firebase_core/firebase_core.dart';

// initialize/run entire app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // include firebase for later use
  runApp(
    MultiProvider( // wrap entire app in providers
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskProvider()..loadTasks(),
        ),
        ChangeNotifierProvider(
          create: (context) => AlarmProvider()..loadAlarms(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Atypical App'; // name bar at top of every page

    // establish color scheme/appearance for entire app
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
      home: const StartPage(), // opens to start screen
    );
  }
}
