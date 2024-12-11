import 'package:flutter/material.dart';
import 'setting.dart';
import 'timer1.dart';
import 'home.dart';
import 'calander.dart';
import 'list.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key, required this.currentIndex});

  final int currentIndex;

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // Do nothing if already on the selected page

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FirstRoute(
              appTitle: 'Neurodivergent App',
              name: 'Timer Track',
            ),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SecondRoute(appTitle: 'Neurodivergent App'),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ThirdRoute(appTitle: 'Neurodivergent App'),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FourthRoute(appTitle: 'Neurodivergent App'),
          ),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FifthRoute(appTitle: 'Neurodivergent App'),
          ),
        );
        break;
    }
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
