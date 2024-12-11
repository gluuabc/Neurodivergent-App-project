import 'package:flutter/material.dart';
import 'bar.dart';

class ThirdRoute extends StatelessWidget {
  const ThirdRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: const Center(
        child: Text(
          'HOME',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 2),
    );
  }
}
