import 'package:flutter/material.dart';
import 'timer2.dart';
import 'bar.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const String appTitle = 'Neurodivergent App';

//     return MaterialApp(
//       title: appTitle,
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color.fromARGB(255, 255, 244, 216),
//         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//           backgroundColor: Color.fromARGB(255, 76, 111, 104),
//           selectedItemColor: Color.fromARGB(255, 255, 244, 216),
//           unselectedItemColor: Color.fromARGB(255, 255, 244, 216),
//         ),
//       ),
//       home: const FirstRoute(appTitle: appTitle, name: 'Timer Track'),
//     );
//   }
// }

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key, required this.appTitle, required this.name});

  final String appTitle;
  final String name;

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  final TextEditingController workTimeController = TextEditingController();
  final TextEditingController breakTimeController = TextEditingController();

  @override
  void dispose() {
    workTimeController.dispose();
    breakTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TitleSection(
              name: widget.name,
              workTimeController: workTimeController,
              breakTimeController: breakTimeController,
            ),
            StartTimerButton(
              appTitle: widget.appTitle,
              name: widget.name,
              workTimeController: workTimeController,
              breakTimeController: breakTimeController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.workTimeController,
    required this.breakTimeController,
  });

  final String name;
  final TextEditingController workTimeController;
  final TextEditingController breakTimeController;

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
          const Text(
            'Work Time (minutes)',
            style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 76, 111, 104)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: workTimeController,
            decoration: const InputDecoration(
              hintText: 'Enter work time',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          const Text(
            'Break Time (minutes)',
            style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 76, 111, 104)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: breakTimeController,
            decoration: const InputDecoration(
              hintText: 'Enter break time',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class StartTimerButton extends StatelessWidget {
  const StartTimerButton({
    super.key,
    required this.appTitle,
    required this.name,
    required this.workTimeController,
    required this.breakTimeController,
  });

  final String appTitle;
  final String name;
  final TextEditingController workTimeController;
  final TextEditingController breakTimeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: ElevatedButton(
        onPressed: () {
          final int workTime = int.tryParse(workTimeController.text) ?? 0;
          final int breakTime = int.tryParse(breakTimeController.text) ?? 0;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Route2(
                appTitle: appTitle,
                name: name,
                workTime: workTime,
                breakTime: breakTime,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 76, 111, 104),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        child: const Text(
          'Start your timer!',
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
