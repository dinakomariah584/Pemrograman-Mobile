// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(const FormFeedbackApp());
}

class FormFeedbackApp extends StatelessWidget {
  const FormFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback App',
      theme: ThemeData(
        // Tema Warna Biru-Ungu
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, primary: Colors.deepPurple.shade700),
        useMaterial3: true,
        fontFamily: 'Roboto', 
      ),
      initialRoute: '/',
      routes: {
        // Halaman Formulir
        '/': (context) => const FeedbackFormPage(), 
        // Halaman Hasil
        '/result': (context) => const FeedbackResultPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- Kelas Data Model Feedback ---
class FeedbackData {
  final String nama;
  final String komentar;
  final int rating;

  FeedbackData({
    required this.nama,
    required this.komentar,
    required this.rating,
  });
}

// -----------------------------------------------------------------------------
// --- Halaman 1: Formulir Feedback (FeedbackFormPage) ---
// -----------------------------------------------------------------------------

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>(); 
  // Controllers akan otomatis dibuat baru saat halaman dibuat ulang
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _komentarController = TextEditingController();
  int? _currentRating; // State rating (null di awal)

  // FUNGSI _resetForm DIHAPUS karena tidak lagi dipanggil, mengandalkan navigasi.

  void _submitFeedback() {
    final isFormValid = _formKey.currentState!.validate();
    final isRatingSelected = _currentRating != null;

    if (isFormValid && isRatingSelected) {
      final data = FeedbackData(
        nama: _namaController.text,
        komentar: _komentarController.text,
        rating: _currentRating!,
      );

      // Navigasi ke halaman hasil
      Navigator.pushNamed( 
        context,
        '/result',
        arguments: data,
      );
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validasi Gagal: Semua field wajib diisi.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _komentarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Feedback', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form( 
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Berikan Pendapat Anda 📝',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(height: 30, color: Colors.grey),
                      
                      // Input Nama
                      TextFormField( 
                        controller: _namaController,
                        decoration: _buildInputDecoration(labelText: 'Nama Anda', icon: Icons.person, context: context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Input Komentar
                      TextFormField(
                        controller: _komentarController,
                        decoration: _buildInputDecoration(labelText: 'Komentar/Saran', icon: Icons.comment, context: context),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Komentar wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Input Rating (Radio Buttons)
                      const Text(
                        '⭐ Pilih Rating (1-5):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      if (_currentRating == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            '* Wajib dipilih',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                        
                      // Container untuk menata RadioListTile
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: List.generate(5, (index) {
                            final ratingValue = index + 1;
                            final int selectedRating = _currentRating ?? 0;

                            return RadioListTile<int>(
                              title: Text(
                                'Rating $ratingValue',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              secondary: Icon(
                                Icons.star, 
                                color: ratingValue <= selectedRating ? Colors.amber : Colors.grey
                              ),
                              value: ratingValue,
                              groupValue: _currentRating,
                              onChanged: (int? value) {
                                setState(() {
                                  _currentRating = value;
                                });
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Tombol Kirim
                      ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text('Kirim Feedback', style: TextStyle(fontSize: 18)),
                        onPressed: _submitFeedback, 
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk dekorasi input
  InputDecoration _buildInputDecoration({required String labelText, required IconData icon, required BuildContext context}) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}


// -----------------------------------------------------------------------------
// --- Halaman 2: Hasil Feedback (FeedbackResultPage) ---
// -----------------------------------------------------------------------------

class FeedbackResultPage extends StatelessWidget {
  const FeedbackResultPage({super.key});

  // Widget pembantu untuk menampilkan setiap baris hasil
  Widget _buildResultRow(String label, String value, {bool isComment = false, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ),
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontStyle: isComment ? FontStyle.italic : FontStyle.normal, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as FeedbackData;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Feedback', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Terima Kasih Atas Feedback Anda! 🎉',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(height: 30, color: Colors.green),
                    
                    // Menampilkan Nama
                    _buildResultRow('Nama:', data.nama, context: context),
                    
                    // Menampilkan Rating
                    _buildResultRow('Rating:', '${data.rating} / 5 ⭐', context: context),
                    
                    // Menampilkan Komentar
                    _buildResultRow('Komentar:', data.komentar, isComment: true, context: context),

                    const SizedBox(height: 30),
                    
                    // Tombol Kembali
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Kembali ke Formulir'),
                        onPressed: () {
                          // JAMINAN RESET: Menggunakan pushReplacementNamed
                          // Menghancurkan halaman hasil dan membuat instance BARU
                          // dari FeedbackFormPage (reset total).
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}