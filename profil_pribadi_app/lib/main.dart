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
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      home: const ProfilPage(),
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Pribadi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Header dengan gradasi warna
            Container(
              width: double.infinity,
              height: 230,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage("assets/images/profil.jpg"),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Dina Komariah",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Mahasiswa Sistem Informasi",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Card Info Profil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Tentang Saya",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Halo! Aku Dina Komariah 😊 "
                        "Seorang mahasiswa Sistem Informasi di UIN Sulthan Thaha Saifuddin Jambi "
                        "yang tertarik dengan pengembangan aplikasi, desain UI/UX, dan teknologi digital modern.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Card Kontak
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.email,
                      title: "Email",
                      subtitle: "dinakomariah@email.com",
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.phone,
                      title: "No. Telepon",
                      subtitle: "+62 812-3456-7890",
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.location_on,
                      title: "Alamat",
                      subtitle: "Jambi, Indonesia",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol interaktif
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Senang bisa kenalan! Yuk, eksplor lebih jauh 😄"),
                    duration: Duration(seconds: 4),
                  ),
                );
              },
              icon: const Icon(Icons.favorite, color: Colors.white),
              label: const Text(
                "Kenalan Yuk!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 4,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget kecil untuk baris info kontak
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent.withValues(alpha: 0.15), // ✅ fix deprecated
        child: Icon(icon, color: Colors.blueAccent),
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
