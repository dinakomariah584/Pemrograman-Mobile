// lib/shopping_item_model.dart

class ShoppingItem {
  String id;
  String name;
  int quantity;
  String category; // Misalnya: Makanan, Minuman, Elektronik
  bool isPurchased; // Status (Sudah dibeli/Belum)

  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    required this.category,
    this.isPurchased = false,
  });

  // Konversi dari Map<String, dynamic> ke Object
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      // Pastikan konversi tipe data yang aman
      quantity: json['quantity'] is int ? json['quantity'] : int.parse(json['quantity'].toString()), 
      category: json['category'] as String,
      isPurchased: json['isPurchased'] as bool,
    );
  }

  // Konversi dari Object ke Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'isPurchased': isPurchased,
    };
  }
}

// Daftar kategori yang tersedia untuk Dropdown
const List<String> availableCategories = [
  'Makanan',
  'Minuman',
  'Elektronik',
  'Peralatan Rumah Tangga',
  'Lainnya',
];