import 'package:flutter/material.dart';
import 'settings.dart';
import 'pomodoro.dart';
// import 'timer1.dart';
import 'home.dart';
import 'calendar.dart';
import 'list.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key, required this.currentIndex});

  final int currentIndex;

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    final pages = [
      const PomodoroRoute(appTitle: 'Neurodivergent App'),
      const SecondRoute(appTitle: 'Neurodivergent App'),
      const ThirdRoute(appTitle: 'Neurodivergent App'),
      const FourthRoute(appTitle: 'Neurodivergent App'),
      const FifthRoute(appTitle: 'Neurodivergent App'),
    ];
    // const FirstRoute(appTitle: 'Neurodivergent App', name: 'Timer Track'),

    if (index < 0 || index >= pages.length) return;

    final newPage = pages[index];

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => newPage,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.alarm,
            color: currentIndex == 0 ? const Color.fromARGB(255, 243, 166, 33) : Colors.white,
          ),
          label: 'Alarm',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle_outlined,
            color: currentIndex == 1 ? const Color.fromARGB(255, 243, 166, 33): Colors.white,
          ),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: currentIndex == 2 ? const Color.fromARGB(255, 243, 166, 33) : Colors.white,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month_outlined,
            color: currentIndex == 3 ? const Color.fromARGB(255, 243, 166, 33) : Colors.white,
          ),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_outlined,
            color: currentIndex == 4 ? const Color.fromARGB(255, 243, 166, 33) : Colors.white,
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}
