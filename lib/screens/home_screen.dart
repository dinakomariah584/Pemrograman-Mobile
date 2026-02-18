// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_detail_screen.dart';
import 'about_screen.dart'; // Import untuk AboutScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Data dummy daftar tugas
  List<Task> tasks = [
    Task(title: 'Belajar Flutter Lanjutan', description: 'Pelajari navigasi dan state management.', isCompleted: false),
    Task(title: 'Siapkan Presentasi', description: 'Buat slide untuk pertemuan besok.', isCompleted: true),
    Task(title: 'Proyek Tugas Akhir', description: 'Kembangkan modul autentikasi.', isCompleted: false),
  ];

  // Function untuk memperbarui status task dari halaman detail
  void _updateTaskStatus(Task updatedTask) {
    setState(() {
      // Mencari index task berdasarkan title untuk diperbarui
      final index = tasks.indexWhere((task) => task.title == updatedTask.title);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Keren'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      
      // --- Menggunakan Drawer Navigation ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                // Menggunakan warna tema utama (Primary)
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menu Aplikasi',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            
            // Menu Home
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Hanya menutup drawer karena ini sudah halaman utama
                Navigator.pop(context); 
              },
            ),
            
            // Menu Tentang Aplikasi (Telah diperbaiki)
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                // 1. Tutup drawer
                Navigator.pop(context); 
                // 2. Navigasi ke AboutScreen menggunakan Named Route
                Navigator.pushNamed(context, AboutScreen.routeName); 
              },
            ),
          ],
        ),
      ),
      
      // --- Bagian Body (Daftar Tugas) ---
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: task.isCompleted ? Colors.green.shade50 : Colors.white,
            child: ListTile(
              leading: Icon(
                task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(task.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                // 1. Mengirim objek Task menggunakan Named Route
                // 2. Menunggu hasil (Callback) dari halaman detail
                final result = await Navigator.pushNamed(
                  context,
                  TaskDetailScreen.routeName,
                  arguments: task,
                );

                // 3. Memproses Data Balik (Task yang statusnya telah diubah)
                if (result != null && result is Task) {
                  _updateTaskStatus(result);
                }
              },
            ),
          );
        },
      ),
    );
  }
}