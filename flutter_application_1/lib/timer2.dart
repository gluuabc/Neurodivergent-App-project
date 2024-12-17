import 'dart:async';
import 'package:flutter/material.dart';
import 'bar.dart';

class Route2 extends StatefulWidget {
  const Route2({
    super.key,
    required this.appTitle,
    required this.name,
    required this.workTime,
    required this.breakTime,
  });

  final String appTitle;
  final String name;
  final int workTime; // in minutes
  final int breakTime; // in minutes

  @override
  State<Route2> createState() => _Route2State();
}

class _Route2State extends State<Route2> {
  late int _remainingTime; // Time in seconds
  late Timer _timer;
  bool _isRunning = false;
  bool _isWorkTime = true;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.workTime * 60;
    _startTimer();
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isWorkTime = !_isWorkTime; // Toggle between work and break
          _remainingTime = (_isWorkTime ? widget.workTime : widget.breakTime) * 60;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() => _isRunning = false);
  }

  void _resumeTimer() {
    if (!_isRunning) _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isWorkTime ? 'Work Time' : 'Break Time',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _formatTime(_remainingTime),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRunning ? _pauseTimer : _resumeTimer,
              child: Text(_isRunning ? 'Pause' : 'Resume'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
    );
  }
}
