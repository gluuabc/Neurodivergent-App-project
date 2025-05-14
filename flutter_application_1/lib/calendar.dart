import 'package:flutter/material.dart';
import 'bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'list.dart';

class FourthRoute extends StatefulWidget {
  const FourthRoute({super.key, required this.appTitle});
  final String appTitle;

  @override
  State<FourthRoute> createState() => _FourthRouteState();
}

class _FourthRouteState extends State<FourthRoute> {
  DateTime _focusedDay = DateTime.now(); // auto updates to current date
  DateTime? _selectedDay; // optional

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks; // access task data

    // get list of tasks due on selected day
    List<Task> getTasksForDay(DateTime? day) {
      return tasks.where((task) {
        if (task.dueDate == null) return false;
        return isSameDay(task.dueDate!, day);
      }).toList();
    }
    final tasksForSelectedDay = getTasksForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      body: Column(
        children: [
          TableCalendar<Task>(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 1, 1), // allowed range
            lastDay: DateTime.utc(2030, 12, 31),

            // set selected day when user clicks on a date
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: getTasksForDay,
            
            // mark selected date with dot
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Color.fromARGB(255, 243, 166, 33),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // check whether or not there are tasks to display
          if (tasksForSelectedDay.isNotEmpty)  
            Expanded(
              child: ListView(
                children: tasksForSelectedDay.map((task) {
                  return TaskTile(
                    task: task,
                    onUpdate: () {
                      // code for task update
                    },
                    onRemove: () {
                      // code for task removal
                    },
                  );
                }).toList(),
              ),
            )
          else
            const Padding(
              // for dates w empty task list
              padding: EdgeInsets.all(16.0),
              child: Text("No tasks for this day."),
            ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 3),
    );
  }
}
