import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/sign_in_viewmodel.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = context.read<SignInViewModel>();
      await viewModel.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // Pastikan widget masih mounted sebelum menggunakan context
      if (!mounted) return;
      if (viewModel.user != null) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Menghilangkan AppBar agar desain mirip XML
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Logo (sesuaikan asset path sesuai kebutuhan)
                Image.asset(
                  'assets/kabare.png',
                  width: 180,
                  height: 90,
                  color: const Color(0xFF5B99E9),
                  colorBlendMode: BlendMode.srcIn,
                ),
                const SizedBox(height: 4),
                // Icon Aplikasi di bawah logo
                Image.asset(
                  'assets/si_vec1.png',
                  width: 180,
                  height: 180,
                ),
                const SizedBox(height: 16),
                // Pesan Sambutan
                const Text(
                  "Ayo masuk dan jangan lewatkan berita penting di kampusmu!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                // Input Username / Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Username atau Email",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Color(0xFF529BFB), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Color(0xFF529BFB), width: 1),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Mohon masukkan username atau email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Input Password dengan toggle visibility
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Color(0xFF529BFB), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Color(0xFF529BFB), width: 1),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mohon masukkan password";
                    }
                    if (value.length < 6) {
                      return "Password minimal 6 karakter";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                // Lupa Password (posisi rata kanan)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: const Text(
                      "Lupa Password?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Tombol Masuk
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // gunakan backgroundColor
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      "Masuk",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Separator dengan teks "Atau"
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Atau",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Tombol Masuk dengan Email
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign_in_with_email');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF1176FA), // gunakan backgroundColor
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      "Masuk dengan Email",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Teks untuk Sign Up
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign_up');
                  },
                  child: const Text(
                    "Belum memiliki akun? Daftar",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
