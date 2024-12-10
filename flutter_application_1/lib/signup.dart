import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Sign Up';
    
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
      ),
    );
  }
}

class BodyContent extends StatelessWidget {
  const BodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          TitleSection(
            name: 'Sign Up',
            input1: 'Email',
            input2: 'Username',
            input3: 'Password',
          ),
          SignUpButton(),
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
    required this.input3,
  });

  final String name;
  final String input1;
  final String input2;
  final String input3;

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
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter email here',
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
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter username here',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            input3,
            style: const TextStyle(
              fontSize: 24, // Larger than default but smaller than name
              color: Color.fromARGB(255, 76, 111, 104),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Enter password here',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: TextButton(
        onPressed: () {
          // ...
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 76, 111, 104),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        child: const Text(
          'Create account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
