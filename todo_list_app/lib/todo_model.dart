import 'dart:convert';

class Todo {
  String id;
  String title;
  bool isCompleted; // Menandai status selesai [cite: 462]
  DateTime createdAt;

  Todo({
    required this.id, // ID unik [cite: 460]
    required this.title, // Judul todo [cite: 461]
    this.isCompleted = false, // Default: belum selesai [cite: 462, 468]
    required this.createdAt, // Waktu pembuatan [cite: 463]
  });

  // Konversi dari Map ke Object (untuk membaca dari storage) [cite: 470]
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Konversi dari Object ke Map (untuk menyimpan ke storage) [cite: 478]
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}