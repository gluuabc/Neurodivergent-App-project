import 'package:flutter/material.dart';
import 'bar.dart';

class FifthRoute extends StatelessWidget {
  const FifthRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: const Center(
        child: Text(
          'SETTING',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 4),
    );
  }
}
