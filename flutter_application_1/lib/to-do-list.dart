import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ToDoPage(),
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
      appBar: AppBar(
        title: const Text(
          'To-Do List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 76, 111, 104),
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
        backgroundColor: Color.fromARGB(255, 76, 111, 104),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomBottomBar(), // Add CustomBottomBar here
      backgroundColor: Colors.white, // Set your custom background color here
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
  bool isExpanded = false; // To expand or collapse the task
  bool isRenaming = false; // To toggle renaming state
  bool isEditingSubtask = false; // For editing subtasks
  final TextEditingController renameController = TextEditingController();
  final TextEditingController subtaskController = TextEditingController();

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

  void editSubtask(int index) {
    setState(() {
      isEditingSubtask = true;
      subtaskController.text = widget.task.subtasks[index].name;
    });
  }

  void saveSubtask(int index) {
    setState(() {
      widget.task.subtasks[index].name = subtaskController.text;
      isEditingSubtask = false;
    });
    widget.onUpdate();
  }

  void renameSubtask(int index) {
    setState(() {
      widget.task.subtasks[index].isRenaming = true;
      subtaskController.text = widget.task.subtasks[index].name;
    });
  }

  void saveSubtaskRename(int index) {
    setState(() {
      widget.task.subtasks[index].name = subtaskController.text;
      widget.task.subtasks[index].isRenaming = false;
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
                      onChanged: (value) {
                        setState(() {
                          widget.task.subtasks[index].isChecked =
                              value ?? false;
                        });
                        widget.onUpdate();
                      },
                    ),
                    title: widget.task.subtasks[index].isRenaming
                        ? TextField(
                            controller: subtaskController,
                            onSubmitted: (_) => saveSubtaskRename(index),
                            decoration: const InputDecoration(
                              hintText: 'Edit Subtask',
                            ),
                          )
                        : Text(widget.task.subtasks[index].name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.task.subtasks[index].isRenaming)
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => saveSubtaskRename(index),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => renameSubtask(index),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteSubtask(index),
                        ),
                      ],
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
  bool isRenaming;

  Task({required this.name, this.isChecked = false})
      : subtasks = [],
        isRenaming = false;
}

class Subtask {
  String name;
  bool isChecked;
  bool isRenaming;

  Subtask(
      {required this.name, this.isChecked = false, this.isRenaming = false});
}

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color.fromARGB(255, 76, 111, 104),
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
