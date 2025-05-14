import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bar.dart';
import 'achievements.dart' hide TaskStatus; // since status is defined twice
import 'task_provider.dart';
import 'list.dart';

class ThirdRoute extends StatelessWidget {
  const ThirdRoute({super.key, required this.appTitle});

  final String appTitle;
  
  @override
  Widget build(BuildContext context) {
    // uses provider for task storage
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;
    final completedTasks = tasks.where((task) => task.status == TaskStatus.finished).length;
    final totalTasks = tasks.length;
    final taskNames = tasks.map((task) => task.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome, Mr. Fawcett!', // will replace with variable
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              // text changes with task data
              'You have $totalTasks ${totalTasks == 1 ? 'task' : 'tasks'} coming up this week. You’ve got this!',
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ // define each task on button linking to task page
                        for (int i = 0; i < (taskNames.length < 2 ? taskNames.length : 2); i++) ...[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SecondRoute(appTitle: 'Atypical App')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                              textStyle: const TextStyle(fontSize: 24),
                            ),
                            child: Text(taskNames[i]),
                          ),
                          const SizedBox(height: 20),
                        ],
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SecondRoute(appTitle: 'Atypical App')),
                              );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                            textStyle: const TextStyle(fontSize: 24),
                          ),
                          child: const Text('View all tasks'),
                        ),
                      ],
                    ),

                    const SizedBox(width: 60),

                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 160,
                              // circular bar adjusts with task data
                              child: CircularProgressIndicator(
                                value: totalTasks > 0 ? completedTasks / totalTasks : 0.0,
                                backgroundColor: Colors.grey[300],
                                strokeWidth: 12,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  // text adjusts with task data
                                  '$completedTasks/$totalTasks',
                                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'tasks completed',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {         Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Route3(
                                      // moves to task page
                                      ),
                                    ),
                                  );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                            textStyle: const TextStyle(fontSize: 24),
                          ),
                          child: const Text('Achievement Page'), // go to achievement page
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
