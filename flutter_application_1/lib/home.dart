import 'package:flutter/material.dart';
import 'bar.dart';

class ThirdRoute extends StatelessWidget {
  const ThirdRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: const TextStyle(fontSize: 28), // Larger title
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome, NAME!',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold), // Bigger header
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'You have 5 tasks coming up this week. You’ve got this!',
              style: TextStyle(fontSize: 28), // Bigger text
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Task List & Progress Section in a Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task buttons on the left
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50), // Bigger button
                        textStyle: const TextStyle(fontSize: 24), // Bigger text
                      ),
                      child: const Text('Task name'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                        textStyle: const TextStyle(fontSize: 24),
                      ),
                      child: const Text('Task name'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                        textStyle: const TextStyle(fontSize: 24),
                      ),
                      child: const Text('View all tasks'),
                    ),
                  ],
                ),

                const SizedBox(width: 60), // Increased space between sections

                // Task Completion on the right
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160, // Larger progress circle
                          height: 160,
                          child: CircularProgressIndicator(
                            value: 3 / 5,
                            backgroundColor: Colors.grey[300],
                            strokeWidth: 12, // Thicker progress ring
                          ),
                        ),
                        const Column(
                          children: [
                            Text(
                              '3/5',
                              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold), // Bigger number
                            ),
                            Text(
                              'tasks completed',
                              style: TextStyle(fontSize: 22), // Bigger text
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40), // Bigger button
                        textStyle: const TextStyle(fontSize: 24), // Bigger text
                      ),
                      child: const Text('Adjust weekly goal'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }
}
