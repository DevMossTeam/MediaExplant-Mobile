import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/features/auth/presentation/logic/sign_up_viewmodel.dart';

/// Layar verifikasi OTP untuk Sign Up.
/// Setelah OTP diverifikasi dengan benar, pengguna akan dinavigasikan ke halaman Sign Up Input.
/// Jika tombol back ditekan dua kali dalam 2 detik, pengguna akan diarahkan ke halaman Sign In.
class SignUpVerifyEmailScreen extends StatefulWidget {
  final String email;
  const SignUpVerifyEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<SignUpVerifyEmailScreen> createState() => _SignUpVerifyEmailScreenState();
}

class _SignUpVerifyEmailScreenState extends State<SignUpVerifyEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  DateTime? _lastBackPressTime;

  /// Fungsi untuk verifikasi OTP menggunakan viewmodel.
  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      final signUpVM = Provider.of<SignUpViewModel>(context, listen: false);

      // Memanggil usecase verifyOtp dari viewmodel.
      final response = await signUpVM.verifyOtp(
        email: widget.email,
        otp: _otpController.text.trim(),
      );

      if (response['success'] == true) {
        // Navigasi ke halaman Sign Up Input setelah OTP berhasil diverifikasi.
        Navigator.pushNamed(
          context,
          '/sign_up_input_screen',
          arguments: widget.email,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "OTP tidak valid, silakan coba lagi.")),
        );
      }
    }
  }

  /// Fungsi back dengan snackbar konfirmasi.
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tekan kembali lagi untuk ke Halaman Masuk"),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    Navigator.pushReplacementNamed(context, '/login');
    return false;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Mendengarkan perubahan loading dari viewmodel.
    final isVerifying = context.watch<SignUpViewModel>().isLoading;
    
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // Background gradient konsisten dengan tema aplikasi.
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                Colors.red.shade900,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: size.height * 0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _VerifyHeader(),
                    const SizedBox(height: 40),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                "Masukkan OTP",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.black87),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.confirmation_number,
                                    color: AppColors.primary,
                                  ),
                                  labelText: "OTP",
                                  labelStyle: const TextStyle(color: Colors.black54),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.black38),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "OTP wajib diisi";
                                  }
                                  if (value.trim().length != 6) {
                                    return "OTP harus 6 digit";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isVerifying ? null : _verifyOtp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: isVerifying
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "Verifikasi OTP",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const _FooterWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget header untuk halaman verifikasi OTP.
class _VerifyHeader extends StatelessWidget {
  const _VerifyHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Logo menggunakan Hero untuk transisi halus.
          Hero(
            tag: 'signup_logo',
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Lottie.asset(
                'assets/animations/Animation_1742101335442.json',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Verifikasi Email",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Masukkan OTP yang dikirim ke email Anda",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Widget footer dengan informasi hak cipta.
class _FooterWidget extends StatelessWidget {
  const _FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 10),
        Text(
          "© 2025 MediaExPlant. All rights reserved.",
          style: TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text(
          "Kebijakan Privasi | Syarat Layanan",
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
