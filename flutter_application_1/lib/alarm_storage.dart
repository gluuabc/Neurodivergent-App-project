// for storing alarm data

import 'dart:convert';
import 'pomodoro.dart'; // json methods
import 'package:shared_preferences/shared_preferences.dart';

class AlarmStorage {
  static const String _key = 'alarm_list';

  static Future<void> saveAlarms(List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(alarms.map((t) => t.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<List<Alarm>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => Alarm.fromJson(e)).toList();
  }
}
