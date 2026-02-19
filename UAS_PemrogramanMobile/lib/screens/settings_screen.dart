import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Foto Profil
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF00897B),
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              
              // Nama User
              Text(
                provider.username, 
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              // Email User
              Text(
                provider.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              
              // Badge Peran (Admin / Mahasiswa)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: provider.isAdmin ? Colors.orange : const Color(0xFF00897B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  provider.isAdmin ? "ADMINISTRATOR" : "MAHASISWA",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 40),
              
              // Kartu Menu Pengaturan
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    // Switch Dark Mode
                    SwitchListTile(
                      secondary: Icon(
                        provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: provider.isDarkMode ? Colors.yellow : Colors.orange,
                      ),
                      title: const Text("Mode Gelap"),
                      subtitle: Text(provider.isDarkMode ? "Aktif" : "Non-aktif"),
                      value: provider.isDarkMode,
                      onChanged: (val) {
                        provider.toggleTheme(val);
                      },
                    ),
                    const Divider(),
                    // Info Versi
                    const ListTile(
                      leading: Icon(Icons.info_outline, color: Color(0xFF00897B)),
                      title: Text("Versi Aplikasi"),
                      trailing: Text("1.0.0", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),
                    // Tombol Logout
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text("Keluar Akun", style: TextStyle(color: Colors.red)),
                      onTap: () {
                        // Proses Logout
                        provider.logout();
                        
                        // Kembali ke Halaman Login & Hapus history navigasi sebelumnya
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text("Berhasil keluar. Silakan login kembali."))
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}