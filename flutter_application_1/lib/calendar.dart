import 'package:flutter/material.dart';
import 'bar.dart';
import 'dart:ui';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';

class FourthRoute extends StatelessWidget {
  @override
  const FourthRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    final tasks = context.read<TaskProvider>().tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Center(
        child: TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14)), 
           ),
           bottomNavigationBar: const CustomBottomBar(currentIndex: 3),
      );
      
  }
}


class _MyAppState extends State<MyApp> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weclcome")),
      body: content(),
    );
  }

  Widget content() {
    return Column(
      children: [
       const Text("123"),
       Container(
        child: TableCalendar(
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14)), 
        ),
     ],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
