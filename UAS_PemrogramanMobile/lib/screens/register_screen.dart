import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  
  // Dua variabel state untuk masing-masing kolom password
  bool _isObscurePass = true;
  bool _isObscureConfirm = true;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulasi delay register
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        // PERBAIKAN: Tambahkan 'await' karena register() mengembalikan Future<bool>
        bool success = await Provider.of<AppProvider>(context, listen: false).register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );

        // PERBAIKAN: Cek mounted lagi setelah await sebelum update UI
        if (!mounted) return;

        setState(() => _isLoading = false);

        if (success) {
          // Jika sukses, kembali ke login dan beri notifikasi
          Navigator.pop(context); 
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Akun berhasil dibuat! Silakan Login."), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Email sudah terdaftar!"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Akun Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.person_add_alt_1, size: 80, color: Color(0xFF00897B)),
              const SizedBox(height: 20),
              const Text("Bergabung dengan CampusBoard", style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 30),

              // NAMA LENGKAP
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nama Lengkap",
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // EMAIL
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Email wajib diisi";
                  if (!val.contains('@')) return "Email tidak valid";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // PASSWORD UTAMA DENGAN MATA
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscurePass,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscurePass ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => _isObscurePass = !_isObscurePass),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.length < 6) return "Minimal 6 karakter";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // KONFIRMASI PASSWORD DENGAN MATA
              TextFormField(
                controller: _confirmPassController,
                obscureText: _isObscureConfirm,
                decoration: InputDecoration(
                  labelText: "Ulangi Password",
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureConfirm ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val != _passwordController.text) return "Password tidak sama";
                  return null;
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("DAFTAR SEKARANG", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}