class TaskModel {
  final int? id;
  final String title;
  final String deadline;
  final int isCompleted; 
  // Field baru: 1 = Resmi (Read Only), 0 = Pribadi (Editable)
  final int isOfficial; 

  TaskModel({
    this.id, 
    required this.title, 
    required this.deadline, 
    this.isCompleted = 0,
    this.isOfficial = 0, // Defaultnya 0 (Pribadi)
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
    id: json['id'],
    title: json['title'],
    deadline: json['deadline'],
    isCompleted: json['isCompleted'],
    // Baca field baru, jika null anggap 0
    isOfficial: json['isOfficial'] ?? 0, 
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline,
      'isCompleted': isCompleted,
      'isOfficial': isOfficial, // Simpan field baru
    };
  }
}