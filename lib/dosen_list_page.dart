import 'package:flutter/material.dart';
import 'dosen_detail_page.dart';

class Dosen {
  final String nama;
  final String nip;
  final String bidang;
  final String foto;

  Dosen({
    required this.nama,
    required this.nip,
    required this.bidang,
    required this.foto,
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
        foto: 'assets/images/dosen1.jpg',
      ),
      Dosen(
        nama: 'Dra. Siti Rahmawati, M.T',
        nip: '19800422 200902 2 003',
        bidang: 'Rekayasa Perangkat Lunak',
        foto: 'assets/images/dosen2.jpg',
      ),
      Dosen(
        nama: 'Ir. Bambang Hidayat, M.Sc',
        nip: '19760911 200212 1 004',
        bidang: 'Jaringan dan Keamanan',
        foto: 'assets/images/dosen3.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Dosen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: daftarDosen.length,
        itemBuilder: (context, index) {
          final dosen = daftarDosen[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DosenDetailPage(dosen: dosen),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Image.asset(
                      dosen.foto,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dosen.nama,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            dosen.bidang,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "NIP: ${dosen.nip}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.deepPurple),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
