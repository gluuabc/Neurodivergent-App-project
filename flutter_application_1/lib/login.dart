import 'package:flutter/material.dart';
// import 'home.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     const String appTitle = 'Sign In';
    
//     return MaterialApp(
//       title: appTitle,
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color.fromARGB(255, 255, 244, 216), // Set background color for the whole app
//         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//           backgroundColor: Color.fromARGB(255, 76, 111, 104), // Properly set the bottom bar color
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.white,
//         ),
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text(appTitle),
//         ),
//         body: const BodyContent(),
//       ),
//     );
//   }
// }

class BodyContent extends StatelessWidget {
  const BodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          TitleSection(
            name: 'Sign In',
            input1: 'Username',
            input2: 'Password'
          ),
          LogInButton(),
          ForgotButton(),
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
              hintText: 'Enter username here',
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
              hintText: 'Enter password here',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}


class LogInButton extends StatelessWidget {
  const LogInButton({super.key});

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
          'Sign in',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ForgotButton extends StatelessWidget {
  const ForgotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: TextButton(
        onPressed: () {
          // ...
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 76, 111, 104),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        child: const Text(
          'Forgot password',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
