import 'package:flutter/material.dart';
import 'bar.dart';

class FourthRoute extends StatelessWidget {
  const FourthRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: const Center(
        child: Text(
          'CALANDER',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 3),
    );
  }
}
