import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'shopping_item_model.dart'; // Pastikan file model ini ada

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoppingApp',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Menggunakan Teal sebagai Primary Color
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Colors.grey[50], // Latar belakang abu-abu muda
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal.shade400,
          foregroundColor: Colors.white,
        ),
      ),
      home: const ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> _items = [];
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // --- Fungsi Penyimpanan Lokal (SharedPreferences) ---
  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    String? itemsString = prefs.getString('shopping_items');

    if (itemsString != null) {
      List<dynamic> itemsJson = jsonDecode(itemsString);
      setState(() {
        _items = itemsJson.map((json) => ShoppingItem.fromJson(json)).toList();
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> itemsJson =
        _items.map((item) => item.toJson()).toList();
    String itemsString = jsonEncode(itemsJson);
    await prefs.setString('shopping_items', itemsString);
  }

  // --- Operasi CRUD dan State Management ---
  void _addItem(String name, int quantity, String category) {
    setState(() {
      _items.add(ShoppingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        quantity: quantity,
        category: category,
      ));
    });
    _saveItems();
  }

  void _togglePurchaseStatus(int index) {
    setState(() {
      _items[index].isPurchased = !_items[index].isPurchased;
    });
    _saveItems();
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _saveItems();
  }

  void _updateItem(int index, String name, int quantity, String category) {
    setState(() {
      _items[index].name = name;
      _items[index].quantity = quantity;
      _items[index].category = category;
    });
    _saveItems();
  }

  // --- Widget Dialog untuk Tambah/Edit ---
  void _showAddEditDialog({ShoppingItem? item, int? index}) {
    // ... (Logika dialog tetap sama, hanya tampilan input yang sedikit disesuaikan) ...
    final isEdit = item != null;
    final TextEditingController nameController =
        TextEditingController(text: isEdit ? item.name : '');
    final TextEditingController quantityController =
        TextEditingController(text: isEdit ? item.quantity.toString() : '1');
    String selectedCategory = isEdit ? item.category : availableCategories.first;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text(isEdit ? 'Edit Item' : 'Tambah Item Baru', style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Item',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.label_outline),
                        ),
                        validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: quantityController,
                        decoration: InputDecoration(
                          labelText: 'Jumlah',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.exposure_plus_1),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                            return 'Masukkan jumlah yang valid (> 0)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.category_outlined),
                        ),
                        initialValue: selectedCategory, // Diperbaiki: menggunakan initialValue
                        items: availableCategories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setStateSB(() {
                              selectedCategory = newValue;
                            });
                          }
                        },
                      ),
                    ],
                  ),
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
                      final name = nameController.text;
                      final quantity = int.parse(quantityController.text);
                      final category = selectedCategory;

                      if (isEdit && index != null) {
                        _updateItem(index, name, quantity, category);
                      } else {
                        _addItem(name, quantity, category);
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${isEdit ? 'Item diperbarui' : 'Item ditambahkan'}!'),
                          backgroundColor: Colors.teal,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: Text(isEdit ? 'Update' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper: Menghitung total
  int get _totalCount => _items.length;
  int get _totalPurchasedCount => _items.where((item) => item.isPurchased).length;
  int get _totalUnpurchasedCount => _totalCount - _totalPurchasedCount;

  // Helper: Menentukan ikon kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan': return Icons.local_dining_outlined;
      case 'Minuman': return Icons.local_cafe_outlined;
      case 'Elektronik': return Icons.devices_other_outlined;
      case 'Peralatan Rumah Tangga': return Icons.home_repair_service_outlined;
      default: return Icons.shopping_basket_outlined;
    }
  }

  // --- Widget Utama (UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Belanja'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian 1: Statistik Header yang Keren
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Total Item', 
                        _totalCount.toString(), 
                        Icons.list_alt, 
                        Colors.teal.shade300
                      ),
                      _buildStatCard(
                        'Sudah Dibeli', 
                        _totalPurchasedCount.toString(), 
                        Icons.check_circle_outline, 
                        Colors.green.shade400
                      ),
                      _buildStatCard(
                        'Belum Dibeli', 
                        _totalUnpurchasedCount.toString(), 
                        Icons.pending_actions_outlined, 
                        Colors.orange.shade400
                      ),
                    ],
                  ),
                ),
                
                // Bagian 2: Daftar Item (ListView)
                Expanded(
                  child: _items.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Belum ada item belanja.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final Color cardColor = item.isPurchased ? Colors.green.shade50 : Colors.white;
                            final Color primaryColor = item.isPurchased ? Colors.grey.shade600 : Colors.black87;

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                // Border tipis untuk item yang sudah dibeli
                                side: item.isPurchased ? BorderSide(color: Colors.green.shade200, width: 1) : BorderSide.none,
                              ),
                              color: cardColor,
                              child: ListTile(
                                // Ikon Kategori di sebelah kiri
                                leading: CircleAvatar(
                                  backgroundColor: item.isPurchased ? Colors.green.shade100 : Colors.teal.shade100,
                                  child: Icon(_getCategoryIcon(item.category), color: Colors.teal.shade800, size: 20),
                                ),
                                title: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: item.isPurchased ? TextDecoration.lineThrough : TextDecoration.none,
                                    color: primaryColor,
                                  ),
                                ),
                                subtitle: Text(
                                    '${item.quantity} | Kategori: ${item.category}',
                                    style: TextStyle(color: item.isPurchased ? Colors.grey : Colors.grey.shade600)
                                ),
                                // Checkbox dan tombol aksi di sebelah kanan
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: item.isPurchased,
                                      onChanged: (bool? value) {
                                        _togglePurchaseStatus(index);
                                      },
                                      activeColor: Colors.green,
                                      checkColor: Colors.white,
                                    ),
                                    // Tombol menu aksi (Edit & Delete)
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _showAddEditDialog(item: item, index: index);
                                        } else if (value == 'delete') {
                                          _deleteItem(index);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item dihapus')));
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(value: 'edit', child: Text('Edit Item')),
                                        const PopupMenuItem(value: 'delete', child: Text('Hapus Item', style: TextStyle(color: Colors.red))),
                                      ],
                                      icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                    _togglePurchaseStatus(index); // Toggle status saat tap pada list item
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        tooltip: 'Tambah Item Belanja',
        label: const Text('Tambah Item'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // --- Widget Pembantu: Stat Card ---
  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width / 3.5,
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}