import 'package:flutter/material.dart';

void main() {
  runApp(const BiodataApp());
}

class BiodataApp extends StatelessWidget {
  const BiodataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biodata App',
      debugShowCheckedModeBanner: false,
      home: const BiodataPage(),
    );
  }
}

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // warna latar belakang
      appBar: AppBar(
        title: const Text('Biodata Saya'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama: Dina Komariah',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('NIM: 701230065'),
              SizedBox(height: 10),
              Text('Program Studi: Sistem Informasi'),
              SizedBox(height: 10),
              Text('Alamat: Jambi'),
            ],
          ),
        ),
      ),
    );
  }
}
