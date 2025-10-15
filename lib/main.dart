import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilPribadiApp());
}

class ProfilPribadiApp extends StatelessWidget {
  const ProfilPribadiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Pribadi App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Profil Pribadi',
            style: TextStyle(
            color: Colors.white, // teks putih
            fontWeight: FontWeight.w600,
            fontSize: 20,
            ),
          )
        ),
        body: const ProfilPage(),
      ),
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/profil.jpg"),
          ),
          const SizedBox(height: 20),
          const Text(
            "Dina Komariah",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Mahasiswa Sistem Informasi\nUIN Sulthan Thaha Saifuddin Jambi",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: () {
              // Menampilkan pesan snackbar di layar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Senang bisa kenalan! Ini sekilas tentang aku 😄"),
                  duration: Duration(seconds: 7),
                ),
              );

              // Menampilkan pesan di konsol
              debugPrint("Tombol profil ditekan!");
            },
            icon: const Icon(Icons.person, color: Colors.white, size: 18),
              label: const Text('Lihat Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // tombol biru
                foregroundColor: Colors.white, // teks putih
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
              )
          ),
        ],
      ),
    );
  }
}
