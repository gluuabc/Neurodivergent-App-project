import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Achievements Page',
      debugShowCheckedModeBanner: false,
      home: AchievementsPage(),
    );
  }
}

/// Enum for task statuses.
enum TaskStatus { unfinished, inProgress, finished }

extension TaskStatusLabel on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.unfinished:
        return "Unfinished";
      case TaskStatus.inProgress:
        return "In Progress";
      case TaskStatus.finished:
        return "Finished";
    }
  }
}

/// Simple task model.
class Task {
  String name;
  String timeLength; // e.g. "2 hours"
  TaskStatus status;
  DateTime? finishedAt; // Set when marked as finished.

  Task({
    required this.name,
    required this.timeLength,
    this.status = TaskStatus.unfinished,
    this.finishedAt,
  });
}

/// Enum for selecting chart time range.
enum TimeRange { week, month, year }

extension TimeRangeLabel on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.week:
        return "Past Week";
      case TimeRange.month:
        return "Past Month";
      case TimeRange.year:
        return "Past Year";
    }
  }
}

/// Achievements page with interactive task controls and a custom-drawn line graph.
class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  // In-memory list of tasks.
  final List<Task> _tasks = [];

  // Controllers for new task input.
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskTimeLengthController =
      TextEditingController();
  TaskStatus _newTaskStatus = TaskStatus.unfinished;

  // Selected time range for the chart.
  TimeRange _timeRange = TimeRange.week;

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskTimeLengthController.dispose();
    super.dispose();
  }

  /// Adds a new task based on input fields.
  void _addTask() {
    final name = _taskNameController.text.trim();
    final timeLen = _taskTimeLengthController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _tasks.add(Task(
        name: name,
        timeLength: timeLen.isEmpty ? "Unknown" : timeLen,
        status: _newTaskStatus,
        finishedAt:
            _newTaskStatus == TaskStatus.finished ? DateTime.now() : null,
      ));
      _taskNameController.clear();
      _taskTimeLengthController.clear();
      _newTaskStatus = TaskStatus.unfinished;
    });
  }

  /// Updates a task's status and records finish time if needed.
  void _updateTaskStatus(int index, TaskStatus newStatus) {
    setState(() {
      _tasks[index].status = newStatus;
      _tasks[index].finishedAt =
          newStatus == TaskStatus.finished ? DateTime.now() : null;
    });
  }

  /// Removes a task from the list.
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  /// Computes chart data (number of finished tasks per day) based on selected time range.
  List<_ChartData> get _chartData {
    int daysBack;
    switch (_timeRange) {
      case TimeRange.week:
        daysBack = 7;
        break;
      case TimeRange.month:
        daysBack = 30;
        break;
      case TimeRange.year:
        daysBack = 365;
        break;
    }
    final now = DateTime.now();
    // Initialize counts for each day offset (0 = today, 1 = yesterday, etc.)
    final Map<int, int> counts = {for (var i = 0; i < daysBack; i++) i: 0};
    for (final task in _tasks) {
      if (task.finishedAt != null) {
        final diff = now.difference(task.finishedAt!).inDays;
        if (diff >= 0 && diff < daysBack) {
          counts[diff] = (counts[diff] ?? 0) + 1;
        }
      }
    }
    // Build list of chart data from oldest to newest.
    final List<_ChartData> data = [];
    for (int i = daysBack - 1; i >= 0; i--) {
      String label = i == 0 ? "Today" : "${i}d";
      data.add(_ChartData(label: label, value: counts[i] ?? 0));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _chartData;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 76, 111, 104),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introductory text.
            const Text(
              "Interactive Achievements",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add tasks and update their status to see the progress chart update.\nSelect a time range to view daily completions.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Time Range Dropdown.
            Row(
              children: [
                const Text("Time Range: ",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<TimeRange>(
                  value: _timeRange,
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      _timeRange = val;
                    });
                  },
                  items: TimeRange.values.map((range) {
                    return DropdownMenuItem(
                        value: range, child: Text(range.label));
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Line Chart.
            Text(
              "Tasks Finished (${_timeRange.label})",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 76, 111, 104)),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: CustomPaint(
                painter: _LineChartPainter(chartData),
                child: Container(),
              ),
            ),
            const SizedBox(height: 24),

            // Add Task Form.
            const Text("Add a New Task",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(labelText: "Task Name"),
            ),
            TextField(
              controller: _taskTimeLengthController,
              decoration: const InputDecoration(
                  labelText: "Time Length (e.g. 2 hours)"),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Status: "),
                DropdownButton<TaskStatus>(
                  value: _newTaskStatus,
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      _newTaskStatus = val;
                    });
                  },
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem(
                        value: status, child: Text(status.label));
                  }).toList(),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
                  ),
                  child: const Text("Add Task",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Existing Tasks List.
            const Text("Existing Tasks",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _tasks.isEmpty
                ? const Text("No tasks yet.")
                : Column(
                    children: List.generate(_tasks.length, (index) {
                      final task = _tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            "${task.name} (${task.timeLength})",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: task.status == TaskStatus.finished
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text("Status: ${task.status.label}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButton<TaskStatus>(
                                value: task.status,
                                onChanged: (val) =>
                                    _updateTaskStatus(index, val!),
                                items: TaskStatus.values.map((s) {
                                  return DropdownMenuItem(
                                      value: s, child: Text(s.label));
                                }).toList(),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeTask(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}

/// Simple data class for chart points.
class _ChartData {
  final String label;
  final int value;
  _ChartData({required this.label, required this.value});
}

/// CustomPainter to draw a polished line chart.
class _LineChartPainter extends CustomPainter {
  final List<_ChartData> data;
  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    // Define chart margins.
    double marginLeft = 40;
    double marginRight = 10;
    double marginBottom = 30;
    double marginTop = 10;
    double chartWidth = size.width - marginLeft - marginRight;
    double chartHeight = size.height - marginTop - marginBottom;

    // Draw X and Y axes.
    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    // Y-axis.
    canvas.drawLine(Offset(marginLeft, marginTop),
        Offset(marginLeft, size.height - marginBottom), axisPaint);
    // X-axis.
    canvas.drawLine(
        Offset(marginLeft, size.height - marginBottom),
        Offset(size.width - marginRight, size.height - marginBottom),
        axisPaint);

    // Determine maximum value in data (with headroom).
    double maxValue = 1;
    for (var d in data) {
      if (d.value > maxValue) maxValue = d.value.toDouble();
    }
    maxValue += 1;

    // Calculate horizontal spacing.
    int count = data.length;
    double xStep = count > 1 ? chartWidth / (count - 1) : chartWidth;

    // Generate points for the chart.
    List<Offset> points = [];
    for (int i = 0; i < count; i++) {
      double x = marginLeft + i * xStep;
      double y =
          size.height - marginBottom - (data[i].value / maxValue) * chartHeight;
      points.add(Offset(x, y));
    }

    // Draw the line graph.
    final linePaint = Paint()
      ..color = const Color.fromARGB(255, 76, 111, 104)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    Path path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (var pt in points) {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(path, linePaint);

    // Draw data points.
    final dotPaint = Paint()..color = const Color.fromARGB(255, 76, 111, 104);
    for (var pt in points) {
      canvas.drawCircle(pt, 3, dotPaint);
    }

    // Draw x-axis labels.
    for (int i = 0; i < count; i++) {
      final label = data[i].label;
      final textSpan = TextSpan(
          text: label,
          style: const TextStyle(color: Colors.black, fontSize: 10));
      final textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(points[i].dx - textPainter.width / 2,
              size.height - marginBottom + 4));
    }

    // (Optional) You can add y-axis labels similarly.
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Simple bottom navigation bar.
class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 76, 111, 104),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: 'Alarm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outlined),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
