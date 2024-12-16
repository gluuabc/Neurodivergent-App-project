import 'package:flutter/material.dart';
import 'bar.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: const ToDoPage(),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
    );
  }
}

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final List<Task> tasks = []; // Main list of tasks

  void addTask() {
    setState(() {
      tasks.add(Task(name: 'New Task'));
    });
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: const Color.fromARGB(255, 255, 244, 216), // Light yellow background
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
                    decoration: const InputDecoration(
                      hintText: 'Rename Task',
                    ),
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
}

class Subtask {
  String name;
  bool isChecked;

  Subtask({required this.name, this.isChecked = false});
}
