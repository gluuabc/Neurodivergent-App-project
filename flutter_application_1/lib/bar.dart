import 'package:flutter/material.dart';
import 'settings.dart';
import 'pomodoro.dart';
import 'home.dart';
import 'calendar.dart';
import 'list.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key, required this.currentIndex});

  final int currentIndex;

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    // creates list of all pages in bar
    // navigates based on index in list (0-4)
    final pages = [
      const PomodoroRoute(appTitle: 'Atypical App'),
      const SecondRoute(appTitle: 'Atypical App'),
      const ThirdRoute(appTitle: 'Atypical App'),
      const FourthRoute(appTitle: 'Atypical App'),
      const FifthRoute(appTitle: 'Atypical App'),
    ];

    // prevent edge cases (index out of range)
    if (index < 0 || index >= pages.length) return;

    // select page based on index
    final newPage = pages[index];

    // go to selected page
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
      // create bar w icons for each page
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      // responds when each icon is selected
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.alarm,
            color: currentIndex == 0 ? const Color.fromARGB(255, 243, 166, 33) : Colors.white,
            // color of each icon changes when selected
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
