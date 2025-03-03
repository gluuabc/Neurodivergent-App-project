import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'bar.dart';

class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  List<Task> tasks = [];
  int _currentIndex = 1;  // Set initial index for this screen

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> taskList = json.decode(tasksJson);
      setState(() {
        tasks = taskList.map((task) => Task.fromJson(task)).toList();
      });
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  void addTask() {
    setState(() {
      tasks.add(Task(name: 'New Task'));
    });
    saveTasks();
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appTitle)),
      body: ToDoPage(
        tasks: tasks,
        onTaskAdded: addTask,
        onTaskRemoved: removeTask,
        onUpdate: saveTasks,
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: _currentIndex),  // Pass the current index here
    );
  }
}

class ToDoPage extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback onTaskAdded;
  final Function(int) onTaskRemoved;
  final VoidCallback onUpdate;

  const ToDoPage({
    super.key,
    required this.tasks,
    required this.onTaskAdded,
    required this.onTaskRemoved,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskTile(
            task: tasks[index],
            onUpdate: onUpdate,
            onRemove: () => onTaskRemoved(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onTaskAdded,
        backgroundColor: const Color.fromARGB(255, 76, 111, 104),
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 244, 216),
    );
  }
}

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onUpdate;
  final VoidCallback onRemove;

  const TaskTile({
    super.key,
    required this.task,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isExpanded = false;
  bool isRenaming = false;
  final TextEditingController renameController = TextEditingController();

  void renameTask() {
    setState(() {
      isRenaming = true;
      renameController.text = widget.task.name;
    });
  }

  void saveRename() {
    setState(() {
      widget.task.name = renameController.text;
      isRenaming = false;
    });
    widget.onUpdate();
  }

  void addSubtask() {
    setState(() {
      widget.task.subtasks.add(Subtask(name: 'New Subtask'));
    });
    widget.onUpdate();
  }

  void deleteSubtask(int index) {
    setState(() {
      widget.task.subtasks.removeAt(index);
    });
    widget.onUpdate();
  }

  void toggleSubtask(int index) {
    setState(() {
      widget.task.subtasks[index].isChecked = !widget.task.subtasks[index].isChecked;
    });
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: widget.task.isChecked,
              onChanged: (value) {
                setState(() {
                  widget.task.isChecked = value ?? false;
                });
                widget.onUpdate();
              },
            ),
            title: isRenaming
                ? TextField(
                    controller: renameController,
                    onSubmitted: (_) => saveRename(),
                    decoration: const InputDecoration(hintText: 'Rename Task'),
                  )
                : Text(
                    widget.task.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: widget.task.isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isRenaming)
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: saveRename,
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: renameTask,
                  ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ),
          if (isExpanded)
            Column(
              children: [
                ...List.generate(widget.task.subtasks.length, (index) {
                  return ListTile(
                    leading: Checkbox(
                      value: widget.task.subtasks[index].isChecked,
                      onChanged: (_) => toggleSubtask(index),
                    ),
                    title: Text(widget.task.subtasks[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteSubtask(index),
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: addSubtask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subtask'),
                ),
              ],
            ),
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(isExpanded ? 'Collapse' : 'Expand'),
          ),
        ],
      ),
    );
  }
}

class Task {
  String name;
  bool isChecked;
  List<Subtask> subtasks;

  Task({required this.name, this.isChecked = false}) : subtasks = [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'isChecked': isChecked,
        'subtasks': subtasks.map((s) => s.toJson()).toList(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json['name'],
        isChecked: json['isChecked'],
      )..subtasks = (json['subtasks'] as List)
          .map((s) => Subtask.fromJson(s))
          .toList();
}

class Subtask {
  String name;
  bool isChecked;

  Subtask({required this.name, this.isChecked = false});

  Map<String, dynamic> toJson() => {
        'name': name,
        'isChecked': isChecked,
      };

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
        name: json['name'],
        isChecked: json['isChecked'],
      );
}
