import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';

/// Root widget.

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
class Route3 extends StatefulWidget {
  const Route3({super.key});

  @override
  State<Route3> createState() => _Route3State();
}

class _Route3State extends State<Route3> {
  // In-memory list of tasks.
  // final List<Task> _tasks = [];

  // Controllers for new task input.
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskTimeLengthController =
      TextEditingController();
  final TaskStatus _newTaskStatus = TaskStatus.unfinished;

  // Selected time range for the chart.
  TimeRange _timeRange = TimeRange.week;

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskTimeLengthController.dispose();
    super.dispose();
  }

  /// Computes chart data (number of finished tasks per day) based on selected time range.
  List<_ChartData> getChartData(BuildContext context) {
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
    final tasks = context.watch<TaskProvider>().tasks;
    for (final task in tasks) {
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
    // Build list of chart data from oldest to newest.
    final chartData = getChartData(context);
    
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
          ],
        ),
      ),
      
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

