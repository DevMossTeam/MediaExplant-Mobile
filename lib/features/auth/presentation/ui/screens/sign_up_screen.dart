import 'package:flutter/material.dart';

/// SignUpScreen merupakan halaman pendaftaran akun.
/// Halaman ini menyediakan tiga input field: Nama Lengkap, Username, dan Email.
/// Terdapat tombol "Kirim OTP" untuk memulai proses verifikasi, dan tombol "Sign In"
/// sebagai alternatif bagi pengguna yang sudah memiliki akun.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Global key untuk mengidentifikasi dan memvalidasi form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller untuk masing-masing input field.
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // Pastikan semua controller di-dispose saat widget dihapus.
    _namaLengkapController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Fungsi untuk mengirim OTP (One-Time Password).
  /// Fungsi ini akan memvalidasi input dan mensimulasikan proses pengiriman OTP.
  void _sendOTP() {
    if (_formKey.currentState!.validate()) {
      // Tampilkan SnackBar sebagai feedback bahwa OTP sedang dikirim.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mengirim OTP...")),
      );
      // Simulasikan delay (misalnya, pemanggilan API) selama 2 detik.
      Future.delayed(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP berhasil dikirim!")),
        );
        // Optionally, navigasi ke halaman verifikasi OTP bisa dilakukan di sini.
        // Navigator.pushNamed(context, '/otp_verification');
      });
    }
  }

  /// Fungsi untuk navigasi ke halaman Sign In.
  void _goToSignIn() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk penyesuaian layout secara responsif.
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Gunakan Stack untuk menampilkan background gradient dan overlay
      // serta konten utama yang dapat di-scroll.
      body: Stack(
        children: [
          // Latar belakang gradient.
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
          // Overlay semi-transparan untuk menambah dimensi visual.
          Container(
            height: size.height,
            width: size.width,
            color: Colors.black.withOpacity(0.2),
          ),
          // Konten utama dengan SingleChildScrollView agar tidak terpotong saat keyboard muncul.
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
                  // Bagian header: logo aplikasi dan teks sambutan.
                  Center(
                    child: Column(
                      children: [
                        // Logo menggunakan Hero widget untuk transisi halus.
                        Hero(
                          tag: 'signup_logo',
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person_add,
                              size: 50,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Buat Akun Baru",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Isi data Anda untuk mendaftar",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Kontainer form pendaftaran dengan latar belakang putih.
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
                          // Input untuk "Nama Lengkap"
                          TextFormField(
                            controller: _namaLengkapController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              labelText: "Nama Lengkap",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Nama Lengkap wajib diisi";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Input untuk "Username"
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.alternate_email),
                              labelText: "Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Username wajib diisi";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Input untuk "Email"
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Email wajib diisi";
                              }
                              // Validasi sederhana format email.
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return "Email tidak valid";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          // Tombol "Kirim OTP" untuk proses verifikasi.
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _sendOTP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D47A1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Kirim OTP",
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
                  // Tombol "Sign In" untuk pengguna yang sudah memiliki akun.
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun? ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: _goToSignIn,
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Informasi tambahan, misalnya persetujuan syarat dan ketentuan.
                  Center(
                    child: Text(
                      "Dengan mendaftar, Anda menyetujui Syarat dan Ketentuan kami.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Area tambahan untuk social sign-up atau informasi lain jika diperlukan.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
