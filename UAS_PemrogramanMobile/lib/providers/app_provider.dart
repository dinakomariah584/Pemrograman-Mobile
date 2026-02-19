import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';
import '../services/db_helper.dart';

class AppProvider with ChangeNotifier {
  // ==========================================================
  // 1. STATE USER & OTENTIKASI (Simulasi Backend)
  // ==========================================================
  
  // Database User Sementara (Email : Password)
  final Map<String, String> _userDatabase = {
    'admin@campus.id': 'admin123',
    'mahasiswa@uin.ac.id': '12345678',
  };

  // Database Nama User (Email : Nama Lengkap)
  final Map<String, String> _userNames = {
    'admin@campus.id': 'Administrator',
    'mahasiswa@uin.ac.id': 'Rina Mahasiswa',
  };

  String _username = "Tamu";
  String _email = "";
  bool _isAdmin = false; 

  String get username => _username;
  String get email => _email;
  bool get isAdmin => _isAdmin;

  // FUNGSI BARU: CEK STATUS LOGIN SAAT APLIKASI DIBUKA
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedName = prefs.getString('user_name');

    if (savedEmail != null && savedEmail.isNotEmpty) {
      // Restore Data dari Memori HP
      _email = savedEmail;
      _username = savedName ?? savedEmail.split('@')[0];
      
      // Restore Status Admin
      if (_email.toLowerCase().contains('admin')) {
        _isAdmin = true;
      } else {
        _isAdmin = false;
      }

      // Restore User ke Database Sementara (Agar tidak error logika)
      if (!_userDatabase.containsKey(_email)) {
        _userDatabase[_email] = "session_restored";
        _userNames[_email] = _username;
      }
      
      notifyListeners();
      return true; // User sudah login sebelumnya
    }
    return false; // Belum login
  }

  Future<bool> login(String email, String password) async {
    if (_userDatabase.containsKey(email) && _userDatabase[email] == password) {
      _email = email;
      _username = _userNames[email] ?? email.split('@')[0];
      
      if (email.toLowerCase().contains('admin')) {
        _isAdmin = true;
      } else {
        _isAdmin = false;
      }

      // SIMPAN KE MEMORI HP (PERSISTENT)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', _email);
      await prefs.setString('user_name', _username);

      notifyListeners();
      return true; 
    }
    return false; 
  }

  Future<bool> register(String name, String email, String password) async {
    if (_userDatabase.containsKey(email)) return false;
    
    _userDatabase[email] = password;
    _userNames[email] = name;
    
    notifyListeners();
    return true;
  }

  // FUNGSI LOGOUT YANG BENAR (Hanya satu ini saja)
  Future<void> logout() async {
    _username = "Tamu";
    _email = "";
    _isAdmin = false;

    // HAPUS DATA DARI MEMORI HP
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data sesi

    notifyListeners();
  }

  // RESET PASSWORD (SIMULASI)
  Future<bool> sendResetPasswordLink(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    // Validasi sederhana: harus ada @ dan .
    return (email.contains('@') && email.contains('.'));
  }

  void resetPassword(String email, String newPass) {
    if (_userDatabase.containsKey(email)) {
      _userDatabase[email] = newPass;
      notifyListeners();
    }
  }

  // ==========================================================
  // 2. STATE TEMA (DARK MODE)
  // ==========================================================
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // ==========================================================
  // 3. STATE PENGUMUMAN KAMPUS (API + BUATAN ADMIN)
  // ==========================================================
  List<EventModel> _apiEvents = [];
  final List<EventModel> _adminCreatedEvents = []; // List khusus buatan Admin
  
  bool _isLoadingEvents = false;
  String _errorEvents = '';
  String _selectedCategory = 'Semua';

  // Menggabungkan data API dan data Admin
  List<EventModel> get events {
    List<EventModel> allEvents = [..._adminCreatedEvents, ..._apiEvents];

    if (_selectedCategory == 'Semua') {
      return allEvents;
    } else {
      return allEvents.where((e) => e.category == _selectedCategory).toList();
    }
  }

  bool get isLoadingEvents => _isLoadingEvents;
  String get errorEvents => _errorEvents;
  String get selectedCategory => _selectedCategory;

  // FETCH DATA DARI API
  Future<void> loadEvents() async {
    // Agar tidak reload terus menerus jika data sudah ada
    if (_apiEvents.isNotEmpty) return;

    _isLoadingEvents = true;
    _errorEvents = '';
    notifyListeners();

    try {
      final rawEvents = await ApiService().fetchEvents();
      
      // Inject Data Dummy (Kategori & Tanggal) karena API asli tidak punya
      final categories = ['Akademik', 'Lomba', 'Beasiswa', 'Seminar'];
      final now = DateTime.now();

      _apiEvents = rawEvents.asMap().entries.map((entry) {
        int index = entry.key;
        EventModel e = entry.value;
        // Tanggal simulasi: Hari ini + index hari
        DateTime fakeDate = now.add(Duration(days: index + 1)); 
        
        return EventModel(
          id: e.id,
          title: e.title,
          body: e.body,
          category: categories[index % categories.length],
          date: fakeDate,
        );
      }).toList();
      
      _selectedCategory = 'Semua';

    } catch (e) {
      _errorEvents = e.toString();
    }

    _isLoadingEvents = false;
    notifyListeners();
  }

  void filterEvents(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // KHUSUS ADMIN: Buat Pengumuman Baru
  void addAnnouncement({
    required String title,
    required String description,
    required String category,
    required DateTime date,
  }) {
    if (!_isAdmin) return; // Proteksi: User biasa tidak boleh akses

    final newEvent = EventModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: description,
      category: category,
      date: date,
    );

    // Masukkan ke list Admin (paling atas)
    _adminCreatedEvents.insert(0, newEvent);
    notifyListeners();
  }

  // KHUSUS ADMIN: Hapus Pengumuman
  void deleteAnnouncement(int id) {
    if (!_isAdmin) return;
    
    _adminCreatedEvents.removeWhere((e) => e.id == id);
    _apiEvents.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ==========================================================
  // 4. STATE DATABASE LOKAL (TUGAS & KALENDER PRIBADI)
  // ==========================================================
  List<TaskModel> _tasks = [];
  bool _isLoadingTasks = false;
  
  List<TaskModel> get tasks => _tasks;
  bool get isLoadingTasks => _isLoadingTasks;

  Future<void> loadTasks() async {
    _isLoadingTasks = true;
    notifyListeners();
    _tasks = await DatabaseHelper.instance.readAllTasks();
    _isLoadingTasks = false;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await DatabaseHelper.instance.create(task);
    await loadTasks(); 
  }

  Future<void> updateTask(TaskModel task) async {
    await DatabaseHelper.instance.update(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    await loadTasks();
  }

  // PROTEKSI STATUS: Jika Official, tidak bisa diceklis
  Future<void> toggleTaskStatus(TaskModel task) async {
    // JIKA ACARA RESMI (isOfficial == 1), LANGSUNG RETURN (TOLAK PERUBAHAN)
    if (task.isOfficial == 1) return;

    final newTask = TaskModel(
      id: task.id,
      title: task.title,
      deadline: task.deadline,
      isCompleted: task.isCompleted == 0 ? 1 : 0,
      isOfficial: task.isOfficial, // Pertahankan status asli
    );
    await updateTask(newTask);
  }

  // COPY EVENT KAMPUS KE KALENDER PRIBADI
  Future<void> addEventToCalendar(EventModel event) async {
    String dateString = event.date.toIso8601String().split('T')[0];
    
    final task = TaskModel(
      title: "[${event.category}] ${event.title}", 
      deadline: dateString,
      isCompleted: 0,
      isOfficial: 1, // PENTING: Menandai ini sebagai acara resmi (Read Only)
    );
    
    await addTask(task);
  }
}