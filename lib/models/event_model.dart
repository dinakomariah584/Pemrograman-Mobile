class EventModel {
  final int id;
  final String title;
  final String body;
  // Field tambahan untuk fitur baru
  String category; 
  DateTime date;

  EventModel({
    required this.id, 
    required this.title, 
    required this.body,
    required this.category,
    required this.date,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // KITA AKAN ISI DEFAULT DULU, NANTI DI-OVERRIDE DI PROVIDER
    return EventModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      category: 'Umum',
      date: DateTime.now(),
    );
  }
}