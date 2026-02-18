// lib/model/feedback_item.dart

class FeedbackItem {
  final String nama;
  final String nim;
  final String fakultas;
  final List<String> fasilitas;
  final double nilaiKepuasan;
  final String jenisFeedback;
  final bool setujuSyarat;

  FeedbackItem({
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.fasilitas,
    required this.nilaiKepuasan,
    required this.jenisFeedback,
    required this.setujuSyarat,
  });

  // Helper method untuk menampilkan data di halaman detail
  Map<String, dynamic> toMap() {
    return {
      'Nama Mahasiswa': nama,
      'NIM': nim,
      'Fakultas': fakultas,
      'Fasilitas yang Dinilai': fasilitas.join(', '),
      'Nilai Kepuasan (1-5)': nilaiKepuasan.round(),
      'Jenis Feedback': jenisFeedback,
      'Setuju Syarat & Ketentuan': setujuSyarat ? 'Ya' : 'Tidak',
    };
  }
}