// lib/screens/about_screen.dart

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.task_alt,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              const Text(
                'Aplikasi Task Keren',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Versi 1.0.0 (Flutter Demo)',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const Text(
                'Aplikasi ini dibuat sebagai studi kasus untuk mempraktikkan konsep navigasi, pengiriman data antar halaman (termasuk objek), dan penggunaan Drawer serta Named Routes di Flutter.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // Menggunakan Navigator.pop() untuk kembali ke halaman sebelumnya (HomeScreen)
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Menu Utama'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}