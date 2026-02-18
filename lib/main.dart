// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/about_screen.dart'; // <-- Import baru
import 'models/task.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Task Keren',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        AboutScreen.routeName: (context) => const AboutScreen(), // <-- Route baru
      },
      onGenerateRoute: (settings) {
        if (settings.name == TaskDetailScreen.routeName) {
          final args = settings.arguments as Task; 

          return MaterialPageRoute(
            builder: (context) {
              return TaskDetailScreen(task: args);
            },
          );
        }
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      },
      debugShowCheckedModeBanner: false,
    );
  }
}