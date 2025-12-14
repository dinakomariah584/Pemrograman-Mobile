import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    // Beri jeda sedikit agar logo terlihat (estetika)
    await Future.delayed(const Duration(seconds: 2));

    // PERBAIKAN 1: Cek mounted setelah await pertama
    if (!mounted) return;

    // Ambil referensi provider
    final provider = Provider.of<AppProvider>(context, listen: false);
    
    // Cek status login (Async)
    bool isLoggedIn = await provider.checkLoginStatus();

    // PERBAIKAN 2: Cek mounted LAGI setelah await kedua sebelum menggunakan context untuk navigasi
    // Ini menghilangkan warning "use_build_context_synchronously"
    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animasi Sederhana
            Container(
              height: 120, 
              width: 120, 
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    // Menggunakan withValues (Flutter modern) atau withOpacity (Lama)
                    color: const Color(0xFF00897B).withValues(alpha: 0.3), 
                    blurRadius: 20, 
                    offset: const Offset(0, 10)
                  )
                ]
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.png', // Logo Anda
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const Icon(Icons.school, size: 60, color: Color(0xFF00897B)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Color(0xFF00897B)),
            const SizedBox(height: 20),
            const Text("Memuat Data Kampus...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}