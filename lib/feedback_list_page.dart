// lib/feedback_list_page.dart
import 'package:flutter/material.dart';
import 'feedback_detail_page.dart';
import 'main.dart'; // Akses feedbackList

class FeedbackListPage extends StatefulWidget {
  const FeedbackListPage({super.key});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {

  // Fungsi untuk me-refresh list setelah kembali dari Detail Page
  void _updateList() {
    setState(() {}); // Memaksa widget untuk di-rebuild
  }

  @override
  Widget build(BuildContext context) {
    if (feedbackList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Feedback'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        
        body: const Center(
          child: Text('Belum ada feedback yang tersimpan.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Feedback'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Gunakan ListView.builder [cite: 12]
      body: ListView.builder(
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          final item = feedbackList[index];
          
          // Ikon warna berbeda untuk tipe feedback [cite: 14]
          IconData iconData;
          Color iconColor;
          if (item.jenisFeedback == 'Apresiasi') {
            iconData = Icons.star;
            iconColor = Colors.green;
          } else if (item.jenisFeedback == 'Saran') {
            iconData = Icons.lightbulb_outline;
            iconColor = Colors.orange;
          } else { // Keluhan
            iconData = Icons.warning_amber;
            iconColor = Colors.red;
          }

          // Gunakan Card atau ListTile [cite: 13]
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(iconData, color: iconColor),
              // Nama mahasiswa [cite: 14]
              title: Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              // Fakultas | Nilai kepuasan [cite: 14]
              subtitle: Text('${item.fakultas} | Kepuasan: ${item.nilaiKepuasan.round()}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () async {
                // Tekan salah satu item untuk membuka halaman detail feedback [cite: 14]
                // Gunakan Navigator.push() dan kirimkan objek feedback [cite: 15]
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackDetailPage(
                      feedbackItem: item,
                      index: index,
                    ),
                  ),
                );
                // Panggil _updateList setelah kembali, untuk me-refresh tampilan jika ada penghapusan
                _updateList();
              },
            ),
          );
        },
      ),
    );
  }
}