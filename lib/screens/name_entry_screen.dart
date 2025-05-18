import 'package:flutter/material.dart';
import 'package:task_manager_basic/Utils/custom_decoration.dart';
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
      appBar: AppBar(title: const Text('Welcome'),backgroundColor: CustomDecoration.appBarColor,),
      body: Container(
        decoration: CustomDecoration.customBackgroundDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Enter your name :', style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500, color: Colors.white )),
              const SizedBox(height: 20),
              TextField(controller: _controller,
              decoration: CustomDecoration.customInputDecoration()),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submitName,
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all(const Color(0XFF007BFF)), ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
