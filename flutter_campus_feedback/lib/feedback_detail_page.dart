// lib/feedback_detail_page.dart
import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'main.dart'; // Akses feedbackList

class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem feedbackItem;
  final int index; // Index di list global untuk operasi penghapusan

  const FeedbackDetailPage({
    super.key,
    required this.feedbackItem,
    required this.index,
  });

  // Fungsi untuk menampilkan dialog konfirmasi dan menghapus data [cite: 16]
  void _deleteFeedback(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Anda yakin ingin menghapus feedback ini secara permanen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(), // Tutup dialog
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Hapus item dari list global
                feedbackList.removeAt(index);
                
                // Notifikasi visual (SnackBar) [cite: 20]
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feedback berhasil dihapus!')),
                );
                
                // Kembali ke daftar (pop 2x: dialog, lalu detail page)
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.pop(context); // Kembali ke FeedbackListPage [cite: 16]
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Feedback'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Tampilkan seluruh isi data mahasiswa [cite: 15]
            ...feedbackItem.toMap().entries.map((entry) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key}:',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                    ),
                    Text(
                      entry.value.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(),
                  ],
                ),
              )
            ),
            const SizedBox(height: 30),
            
            // Tombol "Kembali" [cite: 16]
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigator.pop(context) [cite: 16]
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: const Text('Kembali ke Daftar'),
            ),
            const SizedBox(height: 10),

            // Tombol "Hapus" [cite: 16]
            OutlinedButton(
              onPressed: () => _deleteFeedback(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text('Hapus Feedback', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}