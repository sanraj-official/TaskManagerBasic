import 'package:flutter/material.dart';
import '../services/user_preferences.dart';
import 'task_list_screen.dart';

class NameEntryScreen extends StatefulWidget {
  const NameEntryScreen({super.key});

  @override
  State<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends State<NameEntryScreen> {
  final TextEditingController _controller = TextEditingController();

  void _submitName() async {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      await UserPreferences.setUserName(name);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TaskListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Enter your name:', style: TextStyle(fontSize: 18)),
            TextField(controller: _controller),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submitName, child: const Text('Continue')),
          ],
        ),
      ),
    );
  }
}
