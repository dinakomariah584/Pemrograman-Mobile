// lib/models/task.dart

class Task {
  final String title;
  final String description;
  final bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  // Method untuk membuat salinan task dengan status yang diubah
  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}