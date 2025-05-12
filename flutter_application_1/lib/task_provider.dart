import 'package:flutter/material.dart';
import 'list.dart';
import 'task_storage.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await TaskStorage.loadTasks();
    notifyListeners();
  }

  Future<void> saveTasks() async {
    await TaskStorage.saveTasks(_tasks);
  }

  void addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  void updateTask(int index, Task updatedTask) {
    _tasks[index] = updatedTask;
    saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }
}