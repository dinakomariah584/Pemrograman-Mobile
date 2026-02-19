import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'task_form_screen.dart';
import 'event_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Muat data saat layar dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadTasks();
      Provider.of<AppProvider>(context, listen: false).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final personalTasks = provider.tasks;
    final officialEvents = provider.events;

    // Ambil string tanggal yang dipilih (Format YYYY-MM-DD)
    final String selectedDateStr = _selectedDay?.toIso8601String().split('T')[0] ?? "";
    
    // 1. Filter Acara Pribadi (Database Lokal)
    final dailyTasks = personalTasks.where((task) {
      return task.deadline == selectedDateStr;
    }).toList();

    // 2. Filter Acara Kampus (API/Admin)
    final dailyEvents = officialEvents.where((event) {
      return event.date.toIso8601String().split('T')[0] == selectedDateStr;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // --- WIDGET KALENDER ---
          Card(
            margin: const EdgeInsets.all(8),
            elevation: 4,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: Color(0xFF00897B), shape: BoxShape.circle),
                markersMaxCount: 1,
              ),
              // LOGIKA PENANDA TITIK (MARKER)
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final dateStr = date.toIso8601String().split('T')[0];
                  
                  // Cek apakah ada acara di tanggal ini?
                  final hasPersonal = personalTasks.any((t) => t.deadline == dateStr);
                  final hasOfficial = officialEvents.any((e) => e.date.toIso8601String().split('T')[0] == dateStr);

                  if (!hasPersonal && !hasOfficial) return null;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasOfficial) 
                        Container(margin: const EdgeInsets.symmetric(horizontal: 1.5), width: 7, height: 7, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                      if (hasPersonal) 
                        Container(margin: const EdgeInsets.symmetric(horizontal: 1.5), width: 7, height: 7, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                    ],
                  );
                },
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Agenda Tanggal Ini:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),

          // --- LIST DATA (GABUNGAN) ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                
                // BAGIAN 1: ACARA RESMI (SUMBER DARI KAMPUS)
                if (dailyEvents.isNotEmpty) ...[
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5), 
                     child: Text("📢 Sumber Resmi Kampus", style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))
                   ),
                   ...dailyEvents.map((event) => Card(
                     color: Colors.blue[50],
                     child: ListTile(
                       leading: const Icon(Icons.school, color: Colors.blue),
                       title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                       subtitle: Text(event.category),
                       onTap: () {
                         // Lihat detail pengumuman
                         Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)));
                       },
                       trailing: IconButton(
                         icon: const Icon(Icons.copy, color: Colors.green),
                         tooltip: "Simpan ke Kalender Pribadi",
                         onPressed: () {
                           provider.addEventToCalendar(event);
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text("Disalin ke kalender pribadi!"), backgroundColor: Colors.green)
                           );
                         },
                       ),
                     ),
                   )),
                ],

                // BAGIAN 2: KALENDER PRIBADI SAYA
                if (dailyTasks.isNotEmpty) ...[
                   const Padding(
                     padding: EdgeInsets.only(top: 10, bottom: 5), 
                     child: Text("👤 Kalender Pribadi Saya", style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold))
                   ),
                   ...dailyTasks.map((task) {
                     // CEK APAKAH INI ACARA RESMI YANG DI-COPY?
                     // (isOfficial == 1 artinya Read Only)
                     bool isOfficialCopy = task.isOfficial == 1;

                     return Dismissible(
                        key: Key(task.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => provider.deleteTask(task.id!),
                        child: Card(
                          // Beri warna latar abu-abu jika itu acara resmi (biar beda)
                          color: isOfficialCopy ? Colors.grey[100] : Colors.white,
                          child: ListTile(
                            leading: isOfficialCopy
                                // Jika RESMI: Tampilkan GEMBOK (User tidak bisa ceklis)
                                ? const Icon(Icons.lock, color: Colors.grey)
                                // Jika PRIBADI: Tampilkan CHECKBOX (User bisa ceklis selesai)
                                : Checkbox(
                                    value: task.isCompleted == 1, 
                                    onChanged: (_) => provider.toggleTaskStatus(task)
                                  ),
                            title: Text(
                              task.title, 
                              style: TextStyle(
                                decoration: task.isCompleted == 1 ? TextDecoration.lineThrough : null,
                                color: isOfficialCopy ? Colors.black87 : Colors.black,
                                fontWeight: isOfficialCopy ? FontWeight.w500 : FontWeight.normal,
                              )
                            ),
                            subtitle: isOfficialCopy 
                                ? const Text("Acara Resmi (Read-Only)", style: TextStyle(fontSize: 10, color: Colors.blueGrey))
                                : null,
                            
                            // Tombol Hapus tetap ada untuk semua jenis
                            trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Konfirmasi hapus
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Hapus Agenda?"),
                                      content: const Text("Agenda ini akan dihapus dari kalender pribadi Anda."),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            provider.deleteTask(task.id!);
                                          }, 
                                          child: const Text("Hapus", style: TextStyle(color: Colors.red))
                                        ),
                                      ],
                                    )
                                  );
                                },
                            ),
                            // Jika diklik, beri info jika itu acara resmi
                            onTap: isOfficialCopy 
                              ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Acara resmi kampus tidak dapat diedit."))
                                  );
                                }
                              : () {
                                  // Jika acara pribadi manual, buka form edit
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)));
                                }, 
                          ),
                        ),
                     );
                   }),
                ],

                // PESAN KOSONG
                if (dailyEvents.isEmpty && dailyTasks.isEmpty)
                   const Padding(
                     padding: EdgeInsets.all(40),
                     child: Column(
                       children: [
                         Icon(Icons.event_busy, size: 50, color: Colors.grey),
                         SizedBox(height: 10),
                         Text("Tidak ada agenda pada tanggal ini.", style: TextStyle(color: Colors.grey)),
                       ],
                     ),
                   ),
              ],
            ),
          ),
        ],
      ),
      
      // TOMBOL TAMBAH MANUAL (Hanya untuk Tugas Pribadi)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00897B),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskFormScreen()));
        },
      ),
    );
  }
}