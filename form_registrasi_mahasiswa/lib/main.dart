import 'package:flutter/material.dart';
 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menghitung nilai alpha (0-255) untuk opasitas
    int alpha5 = (255 * 0.05).round();
    int alpha10 = (255 * 0.1).round();
    int alpha30 = (255 * 0.3).round();

    const Color primaryBlue = Color(0xFF2196F3);

    return MaterialApp(
      title: 'Form Registrasi Mahasiswa Kreatif',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: primaryBlue.withAlpha(alpha5),
          hoverColor: primaryBlue.withAlpha(alpha10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryBlue.withAlpha(alpha30), width: 1),
          ),
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
             border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: primaryBlue.withAlpha(alpha5),
            hoverColor: primaryBlue.withAlpha(alpha10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryBlue.withAlpha(alpha30), width: 1),
            ),
            labelStyle: TextStyle(color: Colors.grey[700]),
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
        ),
      ),
      home: const MultiStepStudentForm(),
    );
  }
}

class MultiStepStudentForm extends StatefulWidget {
  const MultiStepStudentForm({super.key});

  @override
  State<MultiStepStudentForm> createState() => _MultiStepStudentFormState();
}

class _MultiStepStudentFormState extends State<MultiStepStudentForm> {
  final GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep2 = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedMajor;
  int _semester = 1;
  final List<String> _hobbies = ['Programming', 'Design', 'Reading', 'Sports'];
  final Map<String, bool> _selectedHobbies = {
    'Programming': false,
    'Design': false,
    'Reading': false,
    'Sports': false,
  };
  bool _isAgreed = false; // State variable for the Switch

  final List<String> _majors = [
    'Sistem Informasi',
    'Teknik Informatika',
    'Manajemen',
    'Akuntansi'
  ];

  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _continueStep() {
    bool isValid = false;
    if (_currentStep == 0) {
      isValid = _formKeyStep1.currentState!.validate();
    } else if (_currentStep == 1) {
      isValid = _formKeyStep2.currentState!.validate() && _isAgreed;

      if (isValid && _selectedHobbies.values.where((v) => v).isEmpty) {
        isValid = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Hobi wajib dipilih minimal satu!'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }

    if (isValid) {
      setState(() {
        if (_currentStep < _steps().length - 1) {
          _currentStep += 1;
        } else {
          _submitForm();
        }
      });
    }
  }

  void _cancelStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep -= 1;
      }
    });
  }

  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registrasi Berhasil! Nama: ${_nameController.text}'),
        backgroundColor: Colors.green,
      ),
    );
    debugPrint('Nama: ${_nameController.text}');
    debugPrint('Email: ${_emailController.text}');
    debugPrint('Nomor HP: ${_phoneController.text}');
    debugPrint('Jurusan: $_selectedMajor');
    debugPrint('Semester: $_semester');
    debugPrint('Hobi: ${_selectedHobbies.keys.where((k) => _selectedHobbies[k]!).join(', ')}');
    debugPrint('Persetujuan: $_isAgreed');
  }

  List<Step> _steps() {
    // Menghitung nilai alpha (0-255) untuk opasitas
    int alpha20 = (255 * 0.2).round();
    const Color primaryBlue = Color(0xFF2196F3);

    return [
      Step(
        title: const Text('Data Dasar', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Informasi pribadi Anda'),
        content: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKeyStep1,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person, color: primaryBlue),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Aktif',
                      prefixIcon: Icon(Icons.email, color: primaryBlue),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Email wajib diisi';
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor HP',
                      prefixIcon: Icon(Icons.phone, color: primaryBlue),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) return 'Nomor HP wajib diisi';
                      if (double.tryParse(value) == null) {
                        return 'Masukkan hanya angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Jurusan',
                      prefixIcon: Icon(Icons.school, color: primaryBlue),
                    ),
                    hint: const Text('Pilih Jurusan'),
                    items: _majors
                        .map((String major) => DropdownMenuItem<String>(
                              value: major,
                              child: Text(major),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMajor = newValue;
                      });
                    },
                    validator: (value) =>
                        _selectedMajor == null ? 'Jurusan wajib dipilih' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Minat & Konfirmasi', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Informasi tambahan dan persetujuan'),
        content: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKeyStep2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Semester', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Slider(
                    min: 1,
                    max: 8,
                    divisions: 7,
                    value: _semester.toDouble(),
                    label: _semester.toString(),
                    onChanged: (v) => setState(() => _semester = v.toInt()),
                    activeColor: primaryBlue,
                    inactiveColor: primaryBlue.withAlpha(alpha20),
                  ),
                  Text('Semester yang dipilih: $_semester', style: const TextStyle(fontSize: 15, color: Colors.grey)),
                  const SizedBox(height: 25),
                  const Text('Pilih Hobi (Minimal 1)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ..._hobbies.map((String hobby) {
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(hobby),
                      value: _selectedHobbies[hobby],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedHobbies[hobby] = value!;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return primaryBlue;
                          }
                          return Colors.grey;
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 25),
                  SwitchListTile(
                    title: const Text('Saya setuju dengan syarat & ketentuan', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _isAgreed,
                    onChanged: (v) => setState(() => _isAgreed = v),
                    activeTrackColor: Colors.green,
                  ),
                  // FIX ERROR: Mengganti 'agree' menjadi '_isAgreed'
                  if (!_isAgreed) 
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Anda harus menyetujui terlebih dahulu',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Kirim data registrasi Anda'),
        content: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ringkasan Data Anda:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryBlue)),
                const Divider(height: 20, thickness: 1),
                _buildSummaryRow(Icons.person, 'Nama', _nameController.text),
                _buildSummaryRow(Icons.email, 'Email', _emailController.text),
                _buildSummaryRow(Icons.phone, 'Nomor HP', _phoneController.text),
                _buildSummaryRow(Icons.school, 'Jurusan', _selectedMajor ?? 'Belum Dipilih'),
                _buildSummaryRow(Icons.calendar_today, 'Semester', _semester.toString()),
                _buildSummaryRow(Icons.interests, 'Hobi', _selectedHobbies.keys.where((k) => _selectedHobbies[k]!).join(', ')),
                _buildSummaryRow(Icons.check_circle, 'Persetujuan', _isAgreed ? 'Disetujui' : 'Belum Disetujui'),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Terima kasih telah melakukan registrasi!',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2196F3);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Registrasi Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _continueStep,
        onStepCancel: _cancelStep,
        steps: _steps(),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: details.onStepContinue,
                    icon: Icon(_currentStep == _steps().length - 1
                        ? Icons.check_circle
                        : Icons.arrow_forward),
                    label: Text(_currentStep == _steps().length - 1
                        ? 'Selesai'
                        : 'Lanjut'),
                  ),
                ),
                const SizedBox(width: 10),
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: details.onStepCancel,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Kembali'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryBlue,
                        side: const BorderSide(color: primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}