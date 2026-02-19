import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'event_detail_screen.dart';
import 'admin_form_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Muat data jika kosong
      if (Provider.of<AppProvider>(context, listen: false).events.isEmpty) {
        Provider.of<AppProvider>(context, listen: false).loadEvents();
      }
    });
  }

  // PERBAIKAN: Hapus parameter BuildContext context
  Future<void> _confirmDelete(int eventId, AppProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context, // Gunakan context global milik State
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Pengumuman?"),
        content: const Text("Tindakan ini tidak dapat dibatalkan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      provider.deleteAnnouncement(eventId);
      
      // PERBAIKAN UTAMA: Cek mounted sebelum pakai context lagi
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengumuman berhasil dihapus.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final categories = ['Semua', 'Akademik', 'Lomba', 'Beasiswa', 'Seminar'];

    return CustomScrollView(
      slivers: [
        // 1. BANNER & HEADER
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Assalaamu’alaikum wa rahmatullah wa barakaatuh, ${provider.username}!",
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.2),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Text(
                              provider.isAdmin ? "ADMINISTRATOR" : "MAHASISWA",
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF00897B)),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // Search Bar Visual
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 45,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: const [Icon(Icons.search, color: Colors.grey), SizedBox(width: 10), Text("Cari info kampus...", style: TextStyle(color: Colors.grey))]),
                )
              ],
            ),
          ),
        ),

        // 2. JUDUL SEKSI & TOMBOL ADMIN
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Papan Informasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                
                // LOGIC: HANYA ADMIN YANG BISA LIHAT TOMBOL "BUAT BARU"
                if (provider.isAdmin)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminFormScreen()));
                    },
                    icon: const Icon(Icons.add_circle, size: 18, color: Color(0xFF00897B)),
                    label: const Text("Buat Baru", style: TextStyle(color: Color(0xFF00897B), fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ),

        // 3. FILTER CHIPS
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: categories.map((cat) {
                final isSelected = provider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => provider.filterEvents(cat),
                    selectedColor: const Color(0xFF00897B),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // 4. DAFTAR PENGUMUMAN
        provider.isLoadingEvents
          ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          : SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = provider.events[index];
                    
                    return Dismissible(
                      // FITUR 1: GESER UNTUK HAPUS (KHUSUS ADMIN)
                      key: Key(event.id.toString()),
                      direction: provider.isAdmin ? DismissDirection.endToStart : DismissDirection.none,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      confirmDismiss: (direction) => showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Hapus Pengumuman?"),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus")),
                            ],
                          ),
                        ),
                      onDismissed: (_) => provider.deleteAnnouncement(event.id),
                      
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8, offset: const Offset(0, 4))],
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Strip Warna Kategori
                              Container(height: 8, decoration: BoxDecoration(color: _getCategoryColor(event.category), borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                              
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Label Kategori
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getCategoryColor(event.category).withValues(alpha:0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            event.category.toUpperCase(),
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getCategoryColor(event.category)),
                                          ),
                                        ),
                                        
                                        // FITUR 2: TOMBOL SAMPAH (KHUSUS ADMIN)
                                        if (provider.isAdmin)
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                            tooltip: "Hapus Pengumuman",
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            // PERBAIKAN: Panggil fungsi baru tanpa parameter context
                                            onPressed: () => _confirmDelete(event.id, provider),
                                          )
                                        else 
                                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text(event.body, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: provider.events.length,
                ),
              ),
            ),
      ],
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'Akademik': return Colors.blue;
      case 'Lomba': return Colors.orange;
      case 'Beasiswa': return Colors.green;
      case 'Seminar': return Colors.purple;
      default: return Colors.grey;
    }
  }
}