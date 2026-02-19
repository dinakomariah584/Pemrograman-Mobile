import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController(); 
  final _newPassController = TextEditingController(); 
  final _formKey = GlobalKey<FormState>();
  
  // State untuk mengontrol tampilan
  // 0: Input Email
  // 1: Input OTP & Password Baru
  int _currentStep = 0;
  bool _isLoading = false;
  
  // State mata password
  bool _isObscure = true;
  
  // Kode OTP Simulasi (Hardcoded untuk demo)
  final String _mockOTP = "1234"; 

  // Tahap 1: Kirim OTP (Simulasi)
  void _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Cek apakah email ada di database dummy via Provider
      bool exists = await Provider.of<AppProvider>(context, listen: false)
          .sendResetPasswordLink(_emailController.text);
      
      setState(() => _isLoading = false);

      if (exists) {
        setState(() => _currentStep = 1); // Pindah ke langkah input OTP
        
        // TAMPILKAN OTP DI POP-UP (KARENA TIDAK ADA SERVER EMAIL ASLI)
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Email Terkirim (Simulasi)"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Karena ini demo offline, silakan gunakan kode OTP berikut:"),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _mockOTP, 
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 5),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup & Masukkan Kode"),
                )
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email tidak ditemukan dalam database!"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // Tahap 2: Verifikasi OTP & Ganti Password
  void _verifyAndReset() {
    if (_formKey.currentState!.validate()) {
      // 1. Cek Apakah OTP Benar?
      if (_otpController.text != _mockOTP) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kode OTP Salah! Coba '1234'"), backgroundColor: Colors.red),
        );
        return;
      }

      // 2. Simpan Password Baru ke Provider
      Provider.of<AppProvider>(context, listen: false)
          .resetPassword(_emailController.text, _newPassController.text);
      
      // 3. Tampilkan Sukses & Kembali ke Login
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => Container(
          padding: const EdgeInsets.all(30),
          height: 300,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text("Password Berhasil Diubah!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B), 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15)
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup Sheet
                    Navigator.pop(context); // Kembali ke Login Screen
                  },
                  child: const Text("LOGIN SEKARANG", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: _currentStep == 0 ? _buildStepOne() : _buildStepTwo(),
        ),
      ),
    );
  }

  // Tampilan 1: Input Email
  Widget _buildStepOne() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_reset, size: 100, color: Color(0xFF00897B)),
        const SizedBox(height: 30),
        const Text(
          "Lupa Password?", 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Masukkan email Anda. Kami akan mengirimkan kode OTP untuk mereset password.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email Terdaftar",
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (val) {
             if (val == null || !val.contains('@')) return "Email tidak valid";
             return null;
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("KIRIM KODE OTP"),
          ),
        ),
      ],
    );
  }

  // Tampilan 2: Input OTP & Password Baru
  Widget _buildStepTwo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Verifikasi OTP", 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Kode OTP telah dikirim ke ${_emailController.text}",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        
        // Input OTP
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 5, fontWeight: FontWeight.bold),
          maxLength: 4,
          decoration: InputDecoration(
            labelText: "Kode OTP",
            hintText: "----",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            counterText: "",
          ),
          validator: (val) => val!.length != 4 ? "OTP harus 4 digit" : null,
        ),
        const SizedBox(height: 20),
        
        // PASSWORD BARU DENGAN MATA (Updated Feature)
        TextFormField(
          controller: _newPassController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: "Password Baru",
            prefixIcon: const Icon(Icons.lock_open),
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (val) => val!.length < 6 ? "Minimal 6 karakter" : null,
        ),
        const SizedBox(height: 24),
        
        SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton(
            onPressed: _verifyAndReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("UBAH PASSWORD"),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _currentStep = 0;
              _otpController.clear();
            });
          }, 
          child: const Text("Kirim Ulang / Ganti Email"),
        )
      ],
    );
  }
}