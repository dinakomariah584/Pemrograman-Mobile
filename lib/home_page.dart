// lib/home_page.dart
import 'package:flutter/material.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';
import 'about_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Menerapkan SingleChildScrollView untuk mencegah overflow pada layar pendek
      body: SingleChildScrollView( 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40), // Tambahkan ruang di atas agar tidak terlalu mepet

              const Text(
                'flutter_campus_feedback',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Nama aplikasi dan logo Flutter 
              Image.asset(
                'assets/logo_flutter.png', 
                height: 90, 
              ),
              const SizedBox(height: 40),

              // Tombol Formulir Feedback Mahasiswa
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigasi antar halaman menggunakan Navigator.push() 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackFormPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: const Text('Formulir Feedback Mahasiswa'),
                ),
              ),

              // Tombol Daftar Feedback
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackListPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: const Text('Daftar Feedback'),
                ),
              ),

              // Tombol Profil Aplikasi / Tentang Kami
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: const Text('Profil Aplikasi / Tentang Kami'),
                ),
              ),

              // Teks motivasi di bagian bawah
              // Catatan: Spacer() dihapus karena kita menggunakan SingleChildScrollView.
              // Jika Anda ingin teks berada di bawah, Anda harus mengatur tinggi Column-nya.
              const SizedBox(height: 40), 
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Coding adalah seni memecahkan masalah dengan logika dan kreativitas.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ), // Penutup SingleChildScrollView
    );
  }
}