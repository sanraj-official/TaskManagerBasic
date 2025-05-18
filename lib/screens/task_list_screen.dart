import 'package:flutter/material.dart';
import 'package:task_manager_basic/Utils/custom_decoration.dart';
import '../services/user_preferences.dart';
import '../services/task_database.dart';
import '../models/task_model.dart';
import '../widgets/task_form.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await TaskDatabase.instance.getTasks();
    setState(() => _tasks = tasks);
  }

  Future<void> _addOrEditTask([Task? task]) async {
    final result = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      builder: (_) => TaskForm(task: task),
    );

    if (result != null) {
      if (task == null) {
        await TaskDatabase.instance.insertTask(result);
      } else {
        await TaskDatabase.instance.updateTask(result);
      }
      _loadTasks();
    }
  }

  void _deleteTask(Task task) async {
    await TaskDatabase.instance.deleteTask(task.id!);
    _loadTasks();
  }

  void _toggleComplete(Task task) async {
    final updated = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      isCompleted: !task.isCompleted,
    );
    await TaskDatabase.instance.updateTask(updated);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final userName = UserPreferences.getUserName() ?? '';
    final filteredTasks = _filter == 'completed'
        ? _tasks.where((t) => t.isCompleted).toList()
        : _filter == 'incomplete'
            ? _tasks.where((t) => !t.isCompleted).toList()
            : _tasks;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xffBF78FA),
        title: Text('Welcome back, $userName!'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _filter = value);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'all', child: Text('All')),
              PopupMenuItem(value: 'completed', child: Text('Completed')),
              PopupMenuItem(value: 'incomplete', child: Text('Incomplete')),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: CustomDecoration.customBackgroundDecoration(),
        child: ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (_, i) => TaskTile(
            task: filteredTasks[i],
            onEdit: () => _addOrEditTask(filteredTasks[i]),
            onDelete: () => _deleteTask(filteredTasks[i]),
            onToggle: () => _toggleComplete(filteredTasks[i]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        backgroundColor: const Color(0xffBF78FA),
        child: const Icon(Icons.add),
      ),
    );
  }
}
