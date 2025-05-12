import 'dart:convert';
import 'list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskStorage {
  static const String _key = 'task_list';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => Task.fromJson(e)).toList();
  }
}
