import 'dart:convert'; // Untuk mengubah data jadi JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Wajib: flutter pub add shared_preferences

// ---------------------------------------------------------------------------
// 1. MODEL DATA (Updated: Tambah toMap & fromMap untuk SharedPreferences)
// ---------------------------------------------------------------------------
class Note {
  String title;
  String content;
  DateTime date;
  String category;

  Note({
    required this.title,
    required this.content,
    required this.date,
    required this.category,
  });

  // Konversi Object Note -> Map (JSON) agar bisa disimpan
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(), // Tanggal disimpan sebagai teks
      'category': category,
    };
  }

  // Konversi Map (JSON) -> Object Note agar bisa dipakai di App
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      category: map['category'],
    );
  }
}

// Global Notifier untuk Tema (Agar bisa diakses dari mana saja)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// ---------------------------------------------------------------------------
// 2. ENTRY POINT
// ---------------------------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load Preferensi Tema sebelum aplikasi mulai
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder mendengarkan perubahan pada themeNotifier
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Catatan Tugas Mahasiswa',
          debugShowCheckedModeBanner: false,
          
          // Tema Terang
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          
          // Tema Gelap (Dark Mode)
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal, 
              brightness: Brightness.dark
            ),
            useMaterial3: true,
          ),
          
          themeMode: currentMode, // Mengikuti settingan user
          home: const HomePage(),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 3. HOME PAGE
// ---------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _allNotes = []; // List kosong awal
  bool _isLoading = true; // Indikator loading saat ambil data
  String _selectedFilter = 'Semua';
  final List<String> _categories = ['Semua', 'Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];

  @override
  void initState() {
    super.initState();
    _loadNotesFromStorage(); // Panggil fungsi load data
  }

  // --- LOGIC SHAREDPREFERENCES (BONUS) ---

  // 1. Simpan Data ke HP
  Future<void> _saveNotesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    // Ubah List<Note> menjadi List<String> (JSON format)
    final String encodedData = jsonEncode(
      _allNotes.map((note) => note.toMap()).toList(),
    );
    await prefs.setString('user_notes', encodedData);
  }

  // 2. Ambil Data dari HP
  Future<void> _loadNotesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('user_notes');

    if (notesString != null) {
      final List<dynamic> decodedData = jsonDecode(notesString);
      setState(() {
        _allNotes = decodedData.map((item) => Note.fromMap(item)).toList();
      });
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  // 3. Toggle Dark Mode & Simpan
  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkNow = themeNotifier.value == ThemeMode.dark;
    
    // Ubah nilai
    themeNotifier.value = isDarkNow ? ThemeMode.light : ThemeMode.dark;
    
    // Simpan ke storage
    await prefs.setBool('isDarkMode', !isDarkNow);
  }

  // --- END LOGIC BONUS ---

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Kuliah':
        return const Icon(Icons.book, color: Colors.blue);
      case 'Organisasi':
        return const Icon(Icons.handshake, color: Colors.orange);
      case 'Pribadi':
        return const Icon(Icons.home, color: Colors.green);
      default:
        return const Icon(Icons.star, color: Colors.purple);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  List<Note> get _filteredNotes {
    if (_selectedFilter == 'Semua') {
      return _allNotes;
    }
    return _allNotes.where((note) => note.category == _selectedFilter).toList();
  }

  Future<void> _addNote() async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (context) => const NoteFormPage()),
    );
    
    if (!mounted) return;

    if (result != null) {
      setState(() {
        _allNotes.add(result);
      });
      _saveNotesToStorage(); // Simpan otomatis setelah nambah
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil ditambahkan')),
      );
    }
  }

  Future<void> _editNote(Note note) async {
    int index = _allNotes.indexOf(note);
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormPage(existingNote: note),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        _allNotes[index] = result;
      });
      _saveNotesToStorage(); // Simpan otomatis setelah edit

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil diperbarui')),
      );
    }
  }

  void _deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _allNotes.remove(note);
              });
              _saveNotesToStorage(); // Simpan otomatis setelah hapus
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan dihapus')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // BONUS: Tombol Toggle Dark Mode
          IconButton(
            icon: Icon(themeNotifier.value == ThemeMode.dark 
                ? Icons.light_mode 
                : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: 'Ganti Tema',
          ),
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              icon: const Icon(Icons.filter_list),
              underline: Container(),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedFilter = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredNotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        _allNotes.isEmpty 
                            ? 'Belum ada catatan.\nKlik + untuk menambah.' 
                            : 'Tidak ada catatan di kategori "$_selectedFilter".',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = _filteredNotes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.grey.shade800 
                              : Colors.grey.shade100,
                          child: _getCategoryIcon(note.category),
                        ),
                        title: Text(
                          note.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(note.date),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    note.category,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () => _editNote(note),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteNote(note),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. FORM PAGE
// ---------------------------------------------------------------------------
class NoteFormPage extends StatefulWidget {
  final Note? existingNote;
  const NoteFormPage({super.key, this.existingNote});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  
  late String _selectedCategory;
  late DateTime _selectedDate;

  final List<String> _inputCategories = ['Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];

  bool get isEditMode => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController = TextEditingController(text: widget.existingNote?.content ?? '');
    _selectedCategory = widget.existingNote?.category ?? 'Kuliah';
    _selectedDate = widget.existingNote?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;
    
    _formKey.currentState!.save();

    final newNote = Note(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: _selectedDate,
      category: _selectedCategory,
    );

    Navigator.pop(context, newNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Catatan' : 'Catatan Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory, 
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                      items: _inputCategories.map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedCategory = val!);
                      },
                      onSaved: (val) {
                        if (val != null) _selectedCategory = val;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Isi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save),
                  label: Text(isEditMode ? 'Simpan Perubahan' : 'Simpan Catatan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}