// for pushing alarm data into other files

import 'package:flutter/material.dart';
import 'pomodoro.dart';
import 'alarm_storage.dart';
import 'dart:async';

class AlarmProvider extends ChangeNotifier {
  List<Alarm> _alarms = [];
  List<Alarm> get alarms => _alarms;

  Duration _remaining = Duration.zero;
  bool _isRunning = false;

  Duration get remaining => _remaining;
  bool get isRunning => _isRunning;

  Alarm? _currentAlarm;
  int _segIndex = 0;
  SubAlarm? _currentSub;

  Alarm? get currentAlarm => _currentAlarm;
  int get segIndex => _segIndex;
  SubAlarm? get currentSub => _currentSub;
  
  // storing + accessing memory
  Future<void> loadAlarms() async {
    _alarms = await AlarmStorage.loadAlarms();
    notifyListeners();
  }

  Future<void> saveAlarms() async {
    await AlarmStorage.saveAlarms(_alarms);
  }

  // defining key functions in centralized area

  // ------- for alarm list ---------
  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    saveAlarms();
    notifyListeners();
  }

  void updateAlarm(int index, Alarm updatedAlarm) {
    _alarms[index] = updatedAlarm;
    saveAlarms();
    notifyListeners();
  }

  void deleteAlarm(int index) {
    _alarms.removeAt(index);
    saveAlarms();
    notifyListeners();
  }

  // ------- for timer ---------
  void setCurrentAlarm(Alarm alarm) {
    _currentAlarm = alarm;
    _segIndex = 0;
    _currentSub = alarm.subAlarms.isNotEmpty ? alarm.subAlarms.first : null;
    _remaining = _currentSub?.duration ?? Duration.zero;
    _isRunning = false; // Ensure it’s not running when alarm is selected
    notifyListeners();
  }

  void pause() {
    _isRunning = false;
    notifyListeners();
  }

  void start() {
    _isRunning = true;
    notifyListeners();
  }

  // timer goes down
  void decrementRemaining(Duration by) {
    _remaining -= by;
    notifyListeners();
  }

  // switch from works to breaks
  void advanceSegment() {
    if (_currentAlarm == null) return;

    if (_segIndex < _currentAlarm!.subAlarms.length - 1) {
      _segIndex++;
      _currentSub = _currentAlarm!.subAlarms[_segIndex];
      _remaining = _currentSub!.duration;
      notifyListeners();
    }
  }
}
