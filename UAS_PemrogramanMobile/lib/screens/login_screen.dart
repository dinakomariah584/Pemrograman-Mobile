import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';
import 'register_screen.dart'; 
import 'forgot_password_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isObscure = true; // State untuk mata password

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulasi delay visual
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
         // PERBAIKAN: Tambahkan 'await' di sini karena fungsi login bersifat Future
         bool success = await Provider.of<AppProvider>(context, listen: false)
             .login(_emailController.text, _passwordController.text);
         
         if (mounted) {
           setState(() => _isLoading = false);

           if (success) {
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
           } else {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
                 content: Text("Email atau Password salah!"),
                 backgroundColor: Colors.red,
               ),
             );
           }
         }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- BAGIAN LOGO (DARI ASET) ---
                Container(
                  height: 150, 
                  width: 150, 
                  decoration: const BoxDecoration(
                    // shape: BoxShape.circle, // Aktifkan jika ingin bulat
                  ),
                  child: Image.asset(
                    'assets/logo.png', 
                    fit: BoxFit.contain, 
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          Text("Logo belum dipasang", style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                const Text(
                  "CampusBoard", 
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF00897B)
                  )
                ),
                const SizedBox(height: 12),
                
                // Deskripsi Kampus (Sesuai Request)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Pusat informasi terpadu, pengumuman akademik, dan kegiatan kampus Universitas Islam Negeri Sulthan Thaha Saifuddin Jambi.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey, 
                      fontSize: 14, 
                      height: 1.5 
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // FORM EMAIL
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF00897B)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Email wajib diisi";
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(val)) return "Format email tidak valid";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // FORM PASSWORD (DENGAN MATA)
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF00897B)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Password wajib diisi";
                    if (val.length < 6) return "Password minimal 6 karakter";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // TOMBOL MASUK
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("MASUK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                      }, 
                      child: const Text("Lupa Password?", style: TextStyle(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                      }, 
                      child: const Text("Daftar Akun", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00897B))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}