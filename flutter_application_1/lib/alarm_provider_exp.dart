import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'pomodoro.dart';
import 'alarm_storage.dart';
import 'dart:async';

class AlarmProvider extends ChangeNotifier {
  List<Alarm> _alarms = [];
  List<Alarm> get alarms => _alarms;

  Timer? _timer;
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
  
  Future<void> loadAlarms() async {
    _alarms = await AlarmStorage.loadAlarms();
    notifyListeners();
  }

  Future<void> saveAlarms() async {
    await AlarmStorage.saveAlarms(_alarms);
  }

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

  void setCurrentAlarm(Alarm alarm) {
    _currentAlarm = alarm;
    _segIndex = 0;
    _currentSub = alarm.subAlarms.isNotEmpty ? alarm.subAlarms.first : null;
    _remaining = _currentSub?.duration ?? Duration.zero;
    _isRunning = false; // Ensure it’s not running when alarm is selected
    notifyListeners();
  }
  
  void startTimer(Duration initial) {
    _remaining = initial;
    print(remaining);
    _isRunning = true;
    AudioPlayer player = AudioPlayer();

    // _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_remaining > Duration.zero) {
        print(_remaining);
        _remaining -= Duration(seconds: 1);
        notifyListeners();
      } else {
        print("done");
        _timer?.cancel();
        _isRunning = false;
        notifyListeners();
        player
            .setAsset(_currentAlarm!.audioFile)
            .then((_) => player.play())
            .catchError((_) {}); // swallow errors
      }
      
      print(_segIndex);
      print(_currentAlarm);
      print(_currentAlarm!.subAlarms);

      if (_segIndex < _currentAlarm!.subAlarms.length - 1) {
        print("hi");
        _segIndex++;
        _currentSub = _currentAlarm!.subAlarms[_segIndex];
        _remaining = _currentSub!.duration;
      }
    });

    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resumeTimer() {
    print("resuming");
    print(_remaining);
    if (!_isRunning && _remaining > Duration.zero) {
      startTimer(_remaining);
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _remaining = Duration.zero;
    _isRunning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
