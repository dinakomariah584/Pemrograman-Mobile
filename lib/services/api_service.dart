import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

class ApiService {
  // FIX: URL harus bersih tanpa tanda kurung [] atau ()
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.take(10).map((data) => EventModel.fromJson(data)).toList();
      } else {
        throw Exception('Gagal memuat data API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }
}