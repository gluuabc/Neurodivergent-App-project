import 'package:flutter/material.dart';
import 'timer2.dart';
import 'bar.dart';

void main() => runApp(const MyApp());

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
          backgroundColor: const Color.fromARGB(255, 76, 111, 104),
          selectedItemColor: const Color.fromARGB(255, 255, 244, 216),
          unselectedItemColor: const Color.fromARGB(255, 255, 244, 216),
        ),
      ),
      home: const FirstRoute(appTitle: appTitle, name: 'Timer Track'),
    );
  }
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key, required this.appTitle, required this.name});

  final String appTitle;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: BodyContent(appTitle: appTitle, name: name),
      bottomNavigationBar: CustomBottomBar(currentIndex: 0),
    );
  }
}


class BodyContent extends StatelessWidget {
  const BodyContent({super.key, required this.appTitle, required this.name});

  final String appTitle;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TitleSection(
            name: name,
            input1: 'Work Time',
            input2: 'Break Time',
          ),
          StartTimerButton(appTitle: appTitle, name: name),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.input1,
    required this.input2,
  });

  final String name;
  final String input1;
  final String input2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 76, 111, 104),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            input1,
            style: const TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 76, 111, 104),
            ),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter work time',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            input2,
            style: const TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 76, 111, 104),
            ),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter break time',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class StartTimerButton extends StatelessWidget {
  const StartTimerButton({super.key, required this.appTitle, required this.name});

  final String appTitle;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Route2(appTitle: appTitle, name: name),
            ),
          );
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 76, 111, 104),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        child: const Text(
          'Start your timer!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

