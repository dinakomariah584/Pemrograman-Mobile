// lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  static const routeName = '/detail';

  // Menerima Data Objek Task melalui konstruktor
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deskripsi Tugas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 30),
            Row(
              children: [
                const Text(
                  'Status:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  task.isCompleted ? 'SELESAI' : 'BELUM SELESAI',
                  style: TextStyle(
                    fontSize: 18,
                    color: task.isCompleted ? Colors.green : Colors.deepOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                // Mengubah status task
                onPressed: () {
                  // Membuat salinan Task dengan status yang dibalik
                  final updatedTask = task.copyWith(
                    isCompleted: !task.isCompleted,
                  );

                  // Menggunakan Navigator.pop() untuk Mengirim Data Balik (Callback)
                  // Mengirim objek updatedTask kembali ke HomeScreen
                  Navigator.pop(context, updatedTask);
                },
                icon: Icon(
                  task.isCompleted ? Icons.undo : Icons.check_circle_outline,
                ),
                label: Text(
                  task.isCompleted ? 'Tandai Belum Selesai' : 'Tandai Selesai',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: task.isCompleted ? Colors.deepOrange : Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}