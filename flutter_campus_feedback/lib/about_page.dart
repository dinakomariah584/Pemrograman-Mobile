// lib/about_page.dart
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Aplikasi / Tentang Kami'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView( // Ganti Center dengan SingleChildScrollView
       child: Center( // Pertahankan Center jika Anda ingin konten berada di tengah saat ruang tersedia
         child: Padding(
          padding: const EdgeInsets.all(20.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Placeholder: Logo UIN STS Jambi 
              Image.asset(
                'assets/logo_uin.png', 
                height: 100, // Sesuaikan tinggi sesuai kebutuhan
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Aplikasi Kuesioner Kepuasan Mahasiswa',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Nama dosen pengampu & mata kuliah 
              const Text('Dosen Pengampu:', style: TextStyle(fontSize: 16)),
              const Text('Ahmad Nasukha, S.Hum., M.S.I', style: TextStyle(fontSize: 16)),
              const Text('Mata Kuliah: Pemrograman Mobile', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              
              // Nama pengembang (mahasiswa) & Tahun akademik 
              const Divider(),
              const Text('Dikembangkan oleh:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Text('Dina Komariah (701230065)', style: TextStyle(fontSize: 16)),
              const Text('Program Studi Sistem Informasi', style: TextStyle(fontSize: 16)),
              const Text('UIN Sulthan Thaha Saifuddin Jambi', style: TextStyle(fontSize: 16)),
              const Text('2025', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 40),

              // Tombol kembali ke beranda 
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
            )
          ),
        ),
      ),
    );
  }
}