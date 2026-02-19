import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/app_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  // Fix: Menambahkan super.key
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _dateController.text = widget.task!.deadline;
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final deadline = _dateController.text;
      final provider = Provider.of<AppProvider>(context, listen: false);

      if (widget.task == null) {
        provider.addTask(TaskModel(title: title, deadline: deadline));
      } else {
        provider.updateTask(TaskModel(
          id: widget.task!.id,
          title: title,
          deadline: deadline,
          isCompleted: widget.task!.isCompleted,
        ));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? "Tambah Tugas" : "Edit Tugas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Tugas/Mata Kuliah', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Harus diisi' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tenggat Waktu', 
                  border: OutlineInputBorder(), 
                  suffixIcon: Icon(Icons.calendar_today)
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (val) => val!.isEmpty ? 'Harus diisi' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  // Fix: Properti style diletakkan sebelum child
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                  child: const Text("Simpan"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}