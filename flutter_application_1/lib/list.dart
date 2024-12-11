import 'package:flutter/material.dart';
import 'bar.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: const Center(
        child: Text(
          'To do list',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 1),
    );
  }
}
