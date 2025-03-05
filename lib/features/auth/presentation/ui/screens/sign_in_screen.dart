import 'package:flutter/material.dart';

/// Halaman login yang menampilkan form untuk input username/email dan password.
/// Terdapat tiga tombol: Sign In, Sign Up, dan Forgot Password.
/// "Forgot Password?" diletakkan di kanan atas tombol Sign In.
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Global key untuk mengidentifikasi form dan melakukan validasi.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller untuk mengelola input username/email dan password.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variabel untuk mengontrol apakah password ditampilkan atau disembunyikan.
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Pastikan controller di-dispose untuk menghindari memory leak.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Fungsi untuk memproses login.
  /// Fungsi ini melakukan validasi form dan mensimulasikan proses login.
  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // Tampilkan SnackBar untuk memberi umpan balik bahwa proses login sedang berjalan.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signing in...")),
      );
      // Simulasikan delay (misalnya, pemanggilan API) selama 2 detik.
      Future.delayed(const Duration(seconds: 2), () {
        // Di sini bisa ditambahkan logika autentikasi sebenarnya.
        // Misalnya, jika berhasil maka navigasi ke halaman utama.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign in successful!")),
        );
        // Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  /// Fungsi untuk navigasi ke halaman Sign Up.
  void _goToSignUp() {
    Navigator.pushNamed(context, '/sign_up');
  }

  /// Fungsi untuk navigasi ke halaman Forgot Password.
  void _goToForgotPassword() {
    Navigator.pushNamed(context, '/reset_password');
  }

  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar untuk penyesuaian responsif.
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Gunakan Stack agar background gradient dan konten dapat diletakkan secara berlapis.
      body: Stack(
        children: [
          // Latar belakang dengan gradient yang menarik.
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Overlay semi-transparan untuk menambah kesan depth.
          Container(
            height: size.height,
            width: size.width,
            color: Colors.black.withOpacity(0.2),
          ),
          // Konten utama menggunakan SingleChildScrollView agar tidak terpotong saat keyboard muncul.
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bagian logo atau identitas aplikasi.
                  Center(
                    child: Column(
                      children: [
                        // Gunakan Hero widget untuk transisi yang mulus antar halaman.
                        Hero(
                          tag: 'app_logo',
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.lock_outline,
                              size: 50,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Sign in to continue",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Container untuk form login dengan latar belakang putih, sudut membulat, dan bayangan.
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Input field untuk Username atau Email.
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              labelText: "Username or Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your username or email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Input field untuk Password.
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // Tombol untuk mengubah visibilitas password.
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          // Row untuk tombol "Forgot Password?" yang diletakkan di kanan atas tombol Sign In.
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: _goToForgotPassword,
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.redAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Tombol Sign In.
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D47A1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Row untuk "Belum punya akun? Sign Up" di bawah card.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Belum punya akun? ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: _goToSignUp,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Area tambahan (misalnya social login atau informasi lain) dapat ditambahkan di sini.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}