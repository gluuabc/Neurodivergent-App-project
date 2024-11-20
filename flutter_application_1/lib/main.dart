import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Neurodivergent App';
    
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 244, 216), // Set background color for the whole app
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 76, 111, 104), // Properly set the bottom bar color
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const BodyContent(),
        bottomNavigationBar: const CustomBottomBar(),
      ),
    );
  }
}

class BodyContent extends StatelessWidget {
  const BodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          TitleSection(
            name: 'Timer Track',
            input1: 'Work Time',
            input2: 'Break Time',
          ),
          StartTimerButton(),
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
              fontSize: 36, // Larger than appTitle
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 76, 111, 104),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            input1,
            style: const TextStyle(
              fontSize: 24, // Larger than default but smaller than name
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
              fontSize: 24, // Larger than default but smaller than name
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
  const StartTimerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: TextButton(
        onPressed: () {
          // Add your functionality for the button here
          print('Timer started!');
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 76, 111, 104),
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

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Ensures all icons are evenly spaced
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: 'Alarm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outlined),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
