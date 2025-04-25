import 'package:flutter/material.dart';

class Home2Page extends StatelessWidget {
  const Home2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: const [
            Text(
              'Your Task List',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TaskCard(title: 'task 1'),
            TaskCard(title: 'task 2'),
            TaskCard(title: 'task 3'),
            TaskCard(title: 'task 4'),
            TaskCard(title: 'task 5'),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;

  const TaskCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
