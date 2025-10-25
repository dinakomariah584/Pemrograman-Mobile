// lib/feedback_form_page.dart
// Mengabaikan peringatan 'groupValue' dan 'onChanged' yang deprecated di RadioListTile 
// agar kode tetap bersih dan sesuai dengan spesifikasi tugas yang meminta RadioListTile.
// ignore_for_file: deprecated_member_use 

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model/feedback_item.dart';
import 'feedback_list_page.dart';
import 'main.dart'; // Akses feedbackList

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _scaffoldContextKey = GlobalKey(); // Key untuk Builder

  // Controller untuk TextField Nama dan NIM
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();

  // State variables lainnya
  String? _fakultas; // Tetap nullable karena merupakan Dropdown
  double _nilaiKepuasan = 3.0;
  String? _jenisFeedback = ''; 
  bool _setujuSyarat = false;
  final List<String> _fasilitas = [];
  
  // Opsi Dropdown dan Checkbox
  final List<String> fakultasOptions = ['Tarbiyah & Keguruan', 'Syariah', 'Ushuluddin & Studi Agama','Adab & Humaniora', 'Dakwah', 'Ekonomi & Bisnis Islam', 'Sains dan Teknologi', 'Kedokteran'];
  final Map<String, bool> fasilitasOptions = {
    'Perpustakaan': false,
    'Kantin': false,
    'Akses Internet': false,
    'Gedung Kuliah': false,
  };

  @override
  void dispose() { 
    _namaController.dispose();
    _nimController.dispose();
    super.dispose();
  }
  
  // Fungsi Notifikasi Kegagalan Validasi (Muncul jika ada field wajib kosong)
  void _showValidationFailDialog([String? customMessage]) {
    final safeContext = _scaffoldContextKey.currentContext;

    if (safeContext == null) {
      return;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: safeContext, 
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Validasi Gagal! 🛑'),
            content: Text(customMessage ?? 'Mohon lengkapi semua field yang wajib diisi (berlabel merah) sebelum menyimpan feedback.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Tutup'),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          );
        },
      );
    });
  }

  // Tampilkan AlertDialog konfirmasi (untuk Switch)
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan Persetujuan'),
          content: const Text('Anda harus mengaktifkan "Setuju Syarat & Ketentuan" sebelum menyimpan feedback.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    // 1. Cek validasi FormFields (Nama, NIM, Fakultas)
    if (_formKey.currentState == null) {
      return; 
    }
    
    if (!_formKey.currentState!.validate()) {
      _showValidationFailDialog(); 
      return; 
    }
    
    // 2. Validasi Wajib Manual: Fasilitas (Minimal satu harus dipilih)
    if (_fasilitas.isEmpty) {
      _showValidationFailDialog('Mohon pilih minimal satu Fasilitas yang Dinilai.');
      return;
    }
    
    // 3. Validasi Wajib Manual: Jenis Feedback (Walaupun ada default, ini memastikan user 'memilih')
    if (_jenisFeedback == null || _jenisFeedback!.trim().isEmpty) {
        _showValidationFailDialog('Mohon pilih Jenis Feedback.');
        return;
    }

    // 4. Validasi Wajib: Switch Setuju Syarat & Ketentuan harus aktif
    if (!_setujuSyarat) {
      _showTermsDialog();
      return;
    }

    // SEMUA VALIDASI SUKSES
    
    // 5. Buat objek FeedbackItem 
    final newFeedback = FeedbackItem(
      nama: _namaController.text, 
      nim: _nimController.text,   
      fakultas: _fakultas ?? 'Tidak Ada', 
      fasilitas: List.from(_fasilitas),
      nilaiKepuasan: _nilaiKepuasan,
      jenisFeedback: _jenisFeedback ?? 'Tidak Ada', 
      setujuSyarat: _setujuSyarat,
    );

    // 6. Simpan data
    feedbackList.add(newFeedback);

    // 7. Tampilkan SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback berhasil disimpan! ✅')),
    );
    
    // 8. Bersihkan Form setelah submit (Opsional)
    _namaController.clear();
    _nimController.clear();
    setState(() {
      _fakultas = null;
      _nilaiKepuasan = 3.0;
      _jenisFeedback = 'Saran'; // Reset ke default
      _setujuSyarat = false;
      _fasilitas.clear();
      fasilitasOptions.updateAll((key, value) => false); 
    });


    // 9. Navigasi ke FeedbackListPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FeedbackListPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: Builder( 
          key: _scaffoldContextKey, 
          builder: (BuildContext innerContext) { 
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
            // Nama Mahasiswa - TextField (Wajib)
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Mahasiswa *'),
              validator: (value) {
               if (value == null || value.trim().isEmpty) { 
                 return 'Nama ini wajib diisi!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // NIM - TextField (Wajib)
            TextFormField(
              controller: _nimController,
              decoration: const InputDecoration(labelText: 'NIM *'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Validasi angka
              validator: (value) {
                if (value == null || value.trim().isEmpty) { 
                   return 'NIM ini wajib diisi!';
                }
                  return null;
              },
            ),
            const SizedBox(height: 16),

            // Fakultas - Dropdown Button FormField (Wajib)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Fakultas *'),
              value: _fakultas, 
              items: fakultasOptions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (value) => setState(() => _fakultas = value),
              // Validator ini sekarang akan menampilkan pesan error
              validator: (value) => value == null ? 'Fakultas wajib dipilih' : null,
            ),
            const SizedBox(height: 20),

            // Fasilitas yang Dinilai - CheckboxListTile (Wajib)
            const Text('Fasilitas yang Dinilai (Pilih minimal satu) *:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...fasilitasOptions.keys.map((key) {
              return CheckboxListTile(
                title: Text(key),
                value: fasilitasOptions[key],
                onChanged: (bool? value) {
                  setState(() {
                    fasilitasOptions[key] = value!;
                    if (value) {
                      _fasilitas.add(key);
                    } else {
                      _fasilitas.remove(key);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 20),

            // Nilai Kepuasan - Slider 
            Text('Nilai Kepuasan: ${_nilaiKepuasan.round()} (Skala 1-5)'),
            Slider(
              value: _nilaiKepuasan,
              min: 1,
              max: 5,
              divisions: 4,
              label: _nilaiKepuasan.round().toString(),
              onChanged: (double value) {
                setState(() => _nilaiKepuasan = value); // Mengelola state
              },
            ),
            const SizedBox(height: 20),

            // Jenis Feedback - RadioListTile (Wajib)
            const Text('Jenis Feedback (Pilih salah satu) *:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...['Saran', 'Keluhan', 'Apresiasi'].map((jenis) {
              return RadioListTile<String>(
                title: Text(jenis),
                value: jenis,
                groupValue: _jenisFeedback,
                onChanged: (value) {
                  setState(() => _jenisFeedback = value);
                },
              );
            }),
            const SizedBox(height: 20),

            // Setuju Syarat & Ketentuan - Switch (Wajib)
            SwitchListTile(
              title: const Text('Setuju Syarat & Ketentuan *'),
              value: _setujuSyarat,
              onChanged: (bool value) {
                setState(() => _setujuSyarat = value);
              },
            ),
            const SizedBox(height: 30),

            // Tombol "Simpan Feedback" ElevatedButton
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Simpan Feedback'),
            ),
            const SizedBox(height: 40),
          ],
            );
          }
        ),
      ),
    );
  }
}