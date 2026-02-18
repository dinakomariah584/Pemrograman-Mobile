import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'todo_model.dart'; 

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        // 1. Tema Gelap untuk tampilan modern
        brightness: Brightness.dark, 
        primarySwatch: Colors.blueGrey, // Menggunakan BlueGrey
        scaffoldBackgroundColor: Colors.grey[900], // Latar belakang sangat gelap
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          elevation: 0,
        ),
        // Warna aksen untuk FAB dan Checkbox
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent[400], 
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.blueAccent.shade400,
          secondary: Colors.blueAccent.shade400,
        ),
      ),
      home: const TodoListScreen(),
    );
  }
}

enum FilterStatus { all, completed, incomplete }

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];
  FilterStatus _filter = FilterStatus.all; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Load data saat aplikasi dibuka
  }
  
  // --- Fungsi Penyimpanan Lokal (SharedPreferences) ---

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');

    if (todosString != null) {
      List<dynamic> todosJson = jsonDecode(todosString);
      setState(() {
        _todos = todosJson.map((json) => Todo.fromJson(json)).toList();
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> todosJson =
        _todos.map((todo) => todo.toJson()).toList();
    String todosString = jsonEncode(todosJson);
    await prefs.setString('todos', todosString);
  }

  // --- Operasi CRUD dan State Management ---
  
  void _addTodo(String title) {
    setState(() {
      _todos.add(Todo(id: DateTime.now().toString(), title: title, createdAt: DateTime.now()));
    });
    _saveTodos();
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
    _saveTodos();
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _saveTodos();
  }

  void _updateTodo(int index, String newTitle) {
    setState(() {
      _todos[index].title = newTitle;
    });
    _saveTodos();
  }

  // --- Logika Filter ---

  List<Todo> get _filteredTodos {
    List<Todo> filteredList;
    switch (_filter) {
      case FilterStatus.completed:
        filteredList = _todos.where((todo) => todo.isCompleted).toList();
        break;
      case FilterStatus.incomplete:
        filteredList = _todos.where((todo) => !todo.isCompleted).toList();
        break;
      case FilterStatus.all:
      default:
        filteredList = _todos;
        break;
    }
    // Mengurutkan: yang belum selesai di atas, lalu berdasarkan waktu
    filteredList.sort((a, b) {
      if (a.isCompleted && !b.isCompleted) return 1;
      if (!a.isCompleted && b.isCompleted) return -1;
      return b.createdAt.compareTo(a.createdAt); // Urutkan terbaru di atas
    });
    return filteredList;
  }

  // --- Widget Dialog untuk Tambah/Edit ---

  void _showAddEditDialog({Todo? todo, int? index}) {
    final isEdit = todo != null;
    final TextEditingController controller =
        TextEditingController(text: isEdit ? todo.title : '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(isEdit ? 'Edit Tugas' : 'Tambah Tugas Baru', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Judul Tugas',
                labelStyle: TextStyle(color: Colors.blueAccent),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade600)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (value) => value!.isEmpty ? 'Judul tidak boleh kosong' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (isEdit && index != null) {
                    _updateTodo(index, controller.text);
                  } else {
                    _addTodo(controller.text);
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(isEdit ? 'Tugas diperbarui' : 'Tugas ditambahkan!'),
                      backgroundColor: Colors.blueAccent,
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.shade400,
                foregroundColor: Colors.white,
              ),
              child: Text(isEdit ? 'Update' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  // --- Widget Utama (UI) ---

  @override
  Widget build(BuildContext context) {
    final displayTodos = _filteredTodos; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Tugas', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          // Dropdown untuk Filter
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<FilterStatus>(
              value: _filter,
              icon: const Icon(Icons.filter_list, color: Colors.blueAccent),
              underline: Container(), 
              onChanged: (FilterStatus? newValue) {
                if (newValue != null) {
                  setState(() {
                    _filter = newValue;
                  });
                }
              },
              items: const [
                DropdownMenuItem(value: FilterStatus.all, child: Text('Semua Tugas')),
                DropdownMenuItem(value: FilterStatus.completed, child: Text('Selesai')),
                DropdownMenuItem(value: FilterStatus.incomplete, child: Text('Belum Selesai')),
              ],
              dropdownColor: Colors.grey[800],
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : displayTodos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.blueAccent.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        'Semua tugas telah diselesaikan!',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tidak ada tugas yang tertunda. Saatnya beristirahat.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  itemCount: displayTodos.length, 
                  itemBuilder: (context, index) {
                    final todo = displayTodos[index];
                    final originalIndex = _todos.indexWhere((t) => t.id == todo.id);

                    // Menentukan warna dan opacity berdasarkan status
                    final Color cardColor = todo.isCompleted ? Colors.grey.shade800! : Colors.grey[850]!;
                    final Color textColor = todo.isCompleted ? Colors.grey.shade500! : Colors.white;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        color: cardColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: todo.isCompleted ? BorderSide(color: Colors.green.shade600!, width: 1) : BorderSide.none,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          // Leading: Status Tugas
                          leading: IconButton(
                            icon: Icon(
                              todo.isCompleted
                                  ? Icons.check_circle_rounded // Ikon Selesai
                                  : Icons.circle_outlined, // Ikon Belum Selesai
                              color: todo.isCompleted ? Colors.green.shade600 : Colors.blueAccent.shade400,
                              size: 28,
                            ),
                            onPressed: () {
                              if (originalIndex != -1) {
                                  _toggleTodoStatus(originalIndex); 
                              }
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: Colors.grey.shade600,
                            ),
                          ),
                          subtitle: Text(
                            'Dibuat: ${todo.createdAt.day}/${todo.createdAt.month}/${todo.createdAt.year}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          // Trailing: Tombol Edit dan Delete
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_outlined, color: Colors.grey.shade500),
                                onPressed: () {
                                  if (originalIndex != -1) {
                                      _showAddEditDialog(todo: todo, index: originalIndex);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () {
                                  if (originalIndex != -1) {
                                      _deleteTodo(originalIndex); 
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Tugas dihapus'),
                                          backgroundColor: Colors.redAccent,
                                      ));
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                              if (originalIndex != -1) {
                                  _showAddEditDialog(todo: todo, index: originalIndex);
                              }
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        tooltip: 'Tambah Tugas Baru',
        label: const Text('Tambah Tugas'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}