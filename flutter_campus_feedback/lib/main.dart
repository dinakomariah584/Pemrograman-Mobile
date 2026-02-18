// lib/main.dart
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'model/feedback_item.dart';

// List global untuk menyimpan semua data feedback (State Management Sederhana)
final List<FeedbackItem> feedbackList = [];

void main() {
  runApp(const CampusFeedbackApp());
}

class CampusFeedbackApp extends StatelessWidget {
  const CampusFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_campus_feedback',
      // Menghilangkan banner DEBUG
      debugShowCheckedModeBanner: false, 
      // Menggunakan Material 3 Design
      theme: ThemeData(
        useMaterial3: true,
        // Latar belakang default putih
        scaffoldBackgroundColor: Colors.white, 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}