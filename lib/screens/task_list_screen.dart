import 'dart:developer';

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
  Filter _filter = Filter.all;
  String message = 'No tasks available';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      List<Task> tasks = await TaskDatabase.instance.getTasks();
      setState(() => _tasks = tasks);
    }
    catch (e) {
      // Handle error
      log('Error loading tasks: $e');
      setState(() {
        message = 'Failed to load tasks';
      });
    }
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
      updatedAt: task.updatedAt,
      completedAt: !task.isCompleted?DateTime.now():null,
    );
    await TaskDatabase.instance.updateTask(updated);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final userName = UserPreferences.getUserName() ?? '';
    List<Task> filteredTasks ;
    try {
      filteredTasks = _filter == Filter.completed
          ? _tasks.where((t) => t.isCompleted).toList()
          : _filter == Filter.incomplete
          ? _tasks.where((t) => !t.isCompleted).toList()
          : _tasks;

      if(filteredTasks.isEmpty && _filter != Filter.all) {
        message = 'No ${_filter.name} tasks available';
      } else {
        message = 'No tasks available';
      }
    }
    catch (e) {
      // Handle error
      log('Error filtering tasks: $e');
      message = 'Failed to load ${_filter.name} tasks';
      filteredTasks = [];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor:CustomDecoration.appBarColor,
        title: Text('Welcome back, $userName!'),
        actions: [
          PopupMenuButton<Filter>(
            onSelected: (value) {
              setState(() => _filter = value);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: Filter.all, child: Text('All')),
              PopupMenuItem(value: Filter.completed, child: Text('Completed')),
              PopupMenuItem(value: Filter.incomplete, child: Text('Incomplete')),
            ],
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: CustomDecoration.customBackgroundDecoration(),
        child: filteredTasks.isEmpty?Center(child: Text(message)):ListView.builder(
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

enum Filter{
  all,
  completed,
  incomplete,
}
