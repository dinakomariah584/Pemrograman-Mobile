import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import '../models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Penyimpanan sementara untuk Web (karena SQLite tidak jalan di browser)
  final List<TaskModel> _webTasks = [];
  int _webIdCounter = 1;

  DatabaseHelper._init();

  Future<Database> get database async {
    // Jika dijalankan di Web, lempar error agar masuk ke logika Mock Data
    if (kIsWeb) {
      throw Exception("SQLite tidak didukung di Web. Menggunakan Mock Data.");
    }
    // Jika di Android/iOS, gunakan SQLite
    if (_database != null) return _database!;
    _database = await _initDB('student_planner_v3.db'); // Versi database baru
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Membuat Tabel dengan kolom baru 'isOfficial'
    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      deadline TEXT NOT NULL,
      isCompleted INTEGER NOT NULL,
      isOfficial INTEGER NOT NULL DEFAULT 0
    )
    ''');
  }

  // --- CRUD OPERATIONS ---

  // 1. CREATE (Tambah Data)
  Future<int> create(TaskModel task) async {
    if (kIsWeb) {
      final newTask = TaskModel(
        id: _webIdCounter++,
        title: task.title,
        deadline: task.deadline,
        isCompleted: task.isCompleted,
        isOfficial: task.isOfficial,
      );
      _webTasks.add(newTask);
      return newTask.id!;
    }
    
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  // 2. READ (Baca Semua Data)
  Future<List<TaskModel>> readAllTasks() async {
    if (kIsWeb) {
      return _webTasks;
    }

    final db = await instance.database;
    // Urutkan berdasarkan ID terbaru (Descending)
    final result = await db.query('tasks', orderBy: 'id DESC');
    return result.map((json) => TaskModel.fromMap(json)).toList();
  }

  // 3. UPDATE (Edit Data)
  Future<int> update(TaskModel task) async {
    if (kIsWeb) {
      final index = _webTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _webTasks[index] = task;
        return 1;
      }
      return 0;
    }

    final db = await instance.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // 4. DELETE (Hapus Data)
  Future<int> delete(int id) async {
    if (kIsWeb) {
      _webTasks.removeWhere((t) => t.id == id);
      return 1;
    }

    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}