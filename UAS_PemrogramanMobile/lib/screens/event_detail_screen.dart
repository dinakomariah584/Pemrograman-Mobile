import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../providers/app_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Acara"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Fitur share dummy (simulasi)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Link acara disalin!")),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Gambar/Warna (Visual Header)
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.indigo.shade50,
              child: Center(
                child: Icon(
                  Icons.event_note,
                  size: 80,
                  color: Colors.indigo.shade200,
                ),
              ),
            ),
            
            // 2. Konten Detail
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Chips (Kategori & Tanggal)
                  Row(
                    children: [
                      Chip(
                        label: Text(event.category),
                        backgroundColor: Colors.blue.withValues(alpha :0.1),
                        labelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat('dd MMMM yyyy').format(event.date),
                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // Judul Acara
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(height: 30),
                  
                  // Deskripsi / Body
                  Text(
                    event.body,
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black54),
                  ),
                  const SizedBox(height: 40),

                  // 3. TOMBOL AKSI: SIMPAN KE KALENDER
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.edit_calendar),
                      label: const Text(
                        "Simpan ke Kalender Saya",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // Panggil fungsi Provider untuk menambah ke DB Lokal
                        Provider.of<AppProvider>(context, listen: false).addEventToCalendar(event);
                        
                        // Tampilkan notifikasi sukses
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: const [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 10),
                                Text("Berhasil masuk kalender!"),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}