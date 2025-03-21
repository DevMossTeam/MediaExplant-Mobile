import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mediaexplant/core/constants/app_colors.dart'; // Pastikan path sudah benar

/// Halaman Sign Up dengan background gradient gelap dan card form pendaftaran yang terang.
/// Jika tombol back ditekan, akan langsung menuju halaman profile.
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
    _namaLengkapController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Fungsi untuk mengirim OTP (One-Time Password) sebagai langkah verifikasi.
  void _sendOTP() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mengirim OTP...")),
      );
      Future.delayed(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP berhasil dikirim!")),
        );
        // Navigasi ke halaman verifikasi OTP setelah OTP dikirim
        Navigator.pushNamed(context, '/sign_up_verify_email');
      });
    }
  }

  /// Fungsi untuk navigasi ke halaman Sign In.
  void _goToSignIn() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Ganti '/profile' dengan route halaman profile yang diinginkan
        Navigator.pushReplacementNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background gradient gelap (sama seperti di halaman Sign In)
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary, // Misalnya merah gelap
                    Colors.red.shade900,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Konten utama yang dapat discroll
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
                    // Header: logo dan teks sambutan untuk pendaftaran.
                    const _SignUpHeaderWidget(),
                    const SizedBox(height: 40),
                    // Card form pendaftaran termasuk navigasi ke Sign In.
                    _SignUpCard(
                      formKey: _formKey,
                      namaLengkapController: _namaLengkapController,
                      usernameController: _usernameController,
                      emailController: _emailController,
                      onSendOTP: _sendOTP,
                      onGoToSignIn: _goToSignIn,
                    ),
                    const SizedBox(height: 40),
                    // Footer: Informasi hak cipta dan kebijakan.
                    const _FooterWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget header untuk halaman Sign Up.
class _SignUpHeaderWidget extends StatelessWidget {
  const _SignUpHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Logo dengan transisi halus menggunakan Hero widget.
          Hero(
            tag: 'signup_logo',
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Lottie.asset(
                'assets/animations/Animation_1742101335442.json',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
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
    );
  }
}

/// Widget card form pendaftaran dengan latar belakang putih.
/// Termasuk juga bagian navigasi "Sudah punya akun? Sign In" di dalam card.
class _SignUpCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController namaLengkapController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final VoidCallback onSendOTP;
  final VoidCallback onGoToSignIn;

  const _SignUpCard({
    Key? key,
    required this.formKey,
    required this.namaLengkapController,
    required this.usernameController,
    required this.emailController,
    required this.onSendOTP,
    required this.onGoToSignIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Input field untuk Nama Lengkap.
              TextFormField(
                controller: namaLengkapController,
                keyboardType: TextInputType.name,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                  labelText: "Nama Lengkap",
                  labelStyle: const TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
              // Input field untuk Username.
              TextFormField(
                controller: usernameController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email, color: AppColors.primary),
                  labelText: "Username",
                  labelStyle: const TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
              // Input field untuk Email.
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: AppColors.primary),
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email wajib diisi";
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Email tidak valid";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              // Tombol "Kirim OTP"
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onSendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Kirim OTP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Navigasi ke halaman Sign In (bagian ini berada di dalam card)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sudah punya akun? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: onGoToSignIn,
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget footer dengan informasi hak cipta.
class _FooterWidget extends StatelessWidget {
  const _FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 10),
        Text(
          "© 2025 MediaExPlant. All rights reserved.",
          style: TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text(
          "Privacy Policy | Terms of Service",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Widget Bottom Sheet untuk Reset Password.
class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final GlobalKey<FormState> _forgotFormKey = GlobalKey<FormState>();
  final TextEditingController _forgotEmailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Meminta fokus segera ketika bottom sheet muncul.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_emailFocus);
    });
  }

  @override
  void dispose() {
    _forgotEmailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_forgotFormKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP sent to ${_forgotEmailController.text}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Menggunakan MediaQuery untuk menghindari overlay keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Form(
        key: _forgotFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _forgotEmailController,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: AppColors.primary),
                labelText: "Enter your email",
                labelStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Email is required";
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Send OTP",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
