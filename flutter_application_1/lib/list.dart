import 'package:flutter/material.dart';
import 'bar.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';

class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  final List<Task> tasks = [];

  /// Add a new Task to the list
  void addTask() {
    setState(() {
      tasks.add(Task(name: 'New Task'));
    });
  }

  /// Remove a Task from the list
  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.read<TaskProvider>().tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appTitle, // Fix: Use widget.appTitle
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskTile(
            task: tasks[index],
            onUpdate: () => setState(() {}),
            onRemove: () => removeTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        backgroundColor: const Color.fromARGB(255, 76, 111, 104),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
      backgroundColor: const Color.fromARGB(255, 255, 244, 216),
    );
  }
}


/// Individual Task Tile
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
  bool isExpanded = false; // Expand or collapse subtasks
  bool isRenaming = false; // Toggle renaming state
  final TextEditingController renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    renameController.text = widget.task.name;
  }

  /// Begin renaming the task
  void renameTask() {
    setState(() {
      isRenaming = true;
      renameController.text = widget.task.name;
    });
  }

  /// Save the renamed task
  void saveRename() {
    setState(() {
      widget.task.name = renameController.text;
      isRenaming = false;
    });
    widget.onUpdate();
  }

  /// Add a new Subtask
  void addSubtask() {
    setState(() {
      widget.task.subtasks.add(Subtask(name: 'New Subtask'));
    });
    widget.onUpdate();
  }

  /// Remove a Subtask
  void deleteSubtask(int index) {
    setState(() {
      widget.task.subtasks.removeAt(index);
    });
    widget.onUpdate();
  }

  /// Toggle expansion
  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  /// Pick a due date/time for the **entire Task**
  Future<void> pickTaskDueDate() async {
    // 1) Pick a date
    final date = await showDatePicker(
      context: context,
      initialDate: widget.task.dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    // 2) Pick a time
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(widget.task.dueDate ?? DateTime.now()),
    );
    if (timeOfDay == null) return;

    // Combine into a DateTime
    final newDueDate = DateTime(
        date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);

    setState(() {
      widget.task.dueDate = newDueDate;
    });
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          // Main Task Row
          ListTile(
            title: isRenaming
                ? TextField(
                    controller: renameController,
                    onSubmitted: (_) => saveRename(),
                    decoration: const InputDecoration(hintText: 'Rename Task'),
                  )
                : Text(
                    task.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: task.status == TaskStatus.finished
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
            subtitle: task.dueDate == null
                ? null
                : Text(
                    'Due: ${task.dueDate}',
                    style: const TextStyle(fontSize: 12),
                  ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown for Task Status with custom colored items
                DropdownButton<TaskStatus>(
                  value: task.status,
                  onChanged: (newStatus) {
                    if (newStatus == null) return;
                    setState(() {
                      task.status = newStatus;
                    });
                    widget.onUpdate();
                  },
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status.name,
                          style: TextStyle(color: getStatusTextColor(status)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 8),
                // Rename / Save button
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
                // Delete Task button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ),
          // Row for picking a due date/time
          if (!isRenaming)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickTaskDueDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 76, 111, 104),
                    ),
                    icon: const Icon(Icons.calendar_month, color: Colors.white),
                    label: const Text('Pick Due Date',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          // Subtasks Section
          if (isExpanded)
            Column(
              children: [
                for (int i = 0; i < task.subtasks.length; i++)
                  SubtaskTile(
                    subtask: task.subtasks[i],
                    onUpdate: widget.onUpdate,
                    onDelete: () => deleteSubtask(i),
                  ),
                TextButton.icon(
                  onPressed: addSubtask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subtask'),
                ),
              ],
            ),
          // Expand / Collapse button
          TextButton(
            onPressed: toggleExpanded,
            child: Text(isExpanded ? 'Collapse' : 'Expand'),
          ),
        ],
      ),
    );
  }
}

/// Subtask tile extracted to reduce complexity
class SubtaskTile extends StatefulWidget {
  final Subtask subtask;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const SubtaskTile({
    super.key,
    required this.subtask,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<SubtaskTile> createState() => _SubtaskTileState();
}

class _SubtaskTileState extends State<SubtaskTile> {
  final TextEditingController subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    subtaskController.text = widget.subtask.name;
  }

  /// Start renaming the subtask
  void renameSubtask() {
    setState(() {
      widget.subtask.isRenaming = true;
      subtaskController.text = widget.subtask.name;
    });
  }

  /// Save the subtask rename
  void saveSubtaskRename() {
    setState(() {
      widget.subtask.name = subtaskController.text;
      widget.subtask.isRenaming = false;
    });
    widget.onUpdate();
  }

  /// Pick a due date/time for this Subtask
  Future<void> pickSubtaskDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: widget.subtask.dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final timeOfDay = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(widget.subtask.dueDate ?? DateTime.now()),
    );
    if (timeOfDay == null) return;

    final newDueDate = DateTime(
        date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);

    setState(() {
      widget.subtask.dueDate = newDueDate;
    });
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final subtask = widget.subtask;
    return ListTile(
      // Dropdown for subtask status with custom colors
      leading: DropdownButton<TaskStatus>(
        value: subtask.status,
        onChanged: (newStatus) {
          if (newStatus == null) return;
          setState(() {
            subtask.status = newStatus;
          });
          widget.onUpdate();
        },
        items: TaskStatus.values.map((status) {
          return DropdownMenuItem(
            value: status,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor(status),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status.name,
                style:
                    TextStyle(color: getStatusTextColor(status), fontSize: 12),
              ),
            ),
          );
        }).toList(),
      ),
      title: subtask.isRenaming
          ? TextField(
              controller: subtaskController,
              onSubmitted: (_) => saveSubtaskRename(),
              decoration: const InputDecoration(hintText: 'Edit Subtask'),
            )
          : Text(
              subtask.name,
              style: TextStyle(
                decoration: subtask.status == TaskStatus.finished
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
      subtitle: subtask.dueDate == null
          ? null
          : Text(
              'Due: ${subtask.dueDate}',
              style: const TextStyle(fontSize: 12),
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtask.isRenaming)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: saveSubtaskRename,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: renameSubtask,
            ),
          // Calendar option for subtask with updated styling
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 76, 111, 104),
              borderRadius: BorderRadius.circular(4),
            ),
            child: IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: pickSubtaskDueDate,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}

//
// -------------- Data Models: Task, Subtask, & Status --------------
//

/// Possible statuses for a task or subtask
enum TaskStatus { unstarted, inProgress, finished }

extension TaskStatusName on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.unstarted:
        return 'Unstarted';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.finished:
        return 'Finished';
    }
  }
}

/// Returns the background color for a given status.
Color getStatusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.unstarted:
      return Colors.grey;
    case TaskStatus.inProgress:
      return Colors.yellow;
    case TaskStatus.finished:
      return Colors.green;
  }
}

/// Returns the text color for a given status.
Color getStatusTextColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.unstarted:
      return Colors.white;
    case TaskStatus.inProgress:
      return Colors.black;
    case TaskStatus.finished:
      return Colors.white;
  }
}

/// A main Task object
class Task {
  String name;
  TaskStatus status;
  DateTime? dueDate; // optional due date/time
  bool isRenaming;
  List<Subtask> subtasks;

  Task({
    required this.name,
    this.status = TaskStatus.unstarted,
    this.dueDate,
    this.subtasks = const [],
  })  : isRenaming = false;
  
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json['name'],
        dueDate:
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        status: TaskStatus.values[json['status']],
        subtasks: (json['subtasks'] as List<dynamic>)
            .map((e) => Subtask.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'dueDate': dueDate?.toIso8601String(),
        'status': status.index,
        'subtasks': subtasks.map((e) => e.toJson()).toList(),
      };
}

/// A Subtask object
class Subtask {
  String name;
  TaskStatus status;
  DateTime? dueDate; // optional due date/time
  bool isRenaming;

  Subtask({
    required this.name,
    this.status = TaskStatus.unstarted,
    this.dueDate,
    this.isRenaming = false,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
        name: json['name'],
        dueDate:
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        status: TaskStatus.values[json['status']],
        isRenaming: json['isRenaming'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'dueDate': dueDate?.toIso8601String(),
        'status': status.index,
        'isRenaming': isRenaming,
      };
}
