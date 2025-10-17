import 'package:flutter/material.dart';
import 'dosen_detail_page.dart';

class Dosen {
  final String nama;
  final String nip;
  final String bidang;

  Dosen({
    required this.nama,
    required this.nip,
    required this.bidang,
  });
}

class DosenListPage extends StatelessWidget {
  const DosenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Dosen> daftarDosen = [
      Dosen(
        nama: 'Dr. Ahmad Zulkarnain, M.Kom',
        nip: '19780315 200501 1 002',
        bidang: 'Sistem Informasi',
      ),
      Dosen(
        nama: 'Dra. Siti Rahmawati, M.T',
        nip: '19800422 200902 2 003',
        bidang: 'Rekayasa Perangkat Lunak',
      ),
      Dosen(
        nama: 'Ir. Bambang Hidayat, M.Sc',
        nip: '19760911 200212 1 004',
        bidang: 'Jaringan dan Keamanan',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Dosen'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: daftarDosen.length,
        itemBuilder: (context, index) {
          final dosen = daftarDosen[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                dosen.nama,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(dosen.bidang),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DosenDetailPage(dosen: dosen),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
