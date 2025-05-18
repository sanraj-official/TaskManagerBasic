import 'package:flutter/material.dart';
import 'package:task_manager_basic/Utils/custom_decoration.dart';
import '../services/user_preferences.dart';
import 'name_entry_screen.dart';
import 'task_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), checkUser);
  }

  void checkUser() {
    final name = UserPreferences.getUserName();
    if (name == null || name.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NameEntryScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TaskListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: CustomDecoration.customBackgroundDecoration(),
          child: const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("lib/assets/appIcon.png"),
                height: 150,
                width: 150,
              ),
              Text("Welcome to Task Manager", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color:Colors.indigo),),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: LinearProgressIndicator(color: Colors.white70,),
              ),
            ],
          ))
      ),
    );
  }
}
