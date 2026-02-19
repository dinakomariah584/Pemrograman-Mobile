import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/splash_screen.dart'; // Pastikan arahnya ke Splash Screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider wajib membungkus aplikasi agar state bisa diakses di mana saja
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      // Consumer digunakan agar saat Tema berubah, aplikasi langsung update
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CampusBoard',
            
            // --- TEMA TERANG (LIGHT) ---
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00897B), // Warna Hijau Teal Khas CampusBoard
                primary: const Color(0xFF00897B),
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF00897B),
                foregroundColor: Colors.white,
                centerTitle: true,
                elevation: 0,
              ),
              scaffoldBackgroundColor: const Color(0xFFF5F7F8), // Latar belakang abu sangat muda
            ),
            
            // --- TEMA GELAP (DARK) ---
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00897B),
                brightness: Brightness.dark,
              ),
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
            ),
            
            // Logika ganti tema otomatis dari Provider
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            
            // HALAMAN PERTAMA: Splash Screen (Untuk Cek Login Otomatis)
            home: const SplashScreen(), 
          );
        },
      ),
    );
  }
}