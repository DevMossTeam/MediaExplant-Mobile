import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';
import 'package:mediaexplant/features/profile/presentation/logic/profile_viewmodel.dart';
import 'package:mediaexplant/features/settings/logic/settings_viewmodel.dart';
import '../../logic/sign_in_viewmodel.dart';
import '../otp/forgot_password_verify_email.dart';
import '../../../../settings/logic/keamanan_viewmodel.dart';

/// Halaman Sign In dengan background gradient gelap dan card login terang.
/// Jika tombol back ditekan, akan langsung menuju halaman profile.
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> _signIn() async {
  if (_formKey.currentState!.validate()) {
    final signInViewModel = context.read<SignInViewModel>();

    // Tampilkan SnackBar "Signing in..."
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Signing in..."),
        duration: Duration(seconds: 1),
      ),
    );

    await signInViewModel.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Hide SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    await loadUserLogin();

    // Debug: Ambil dan tampilkan data AuthStorage
    final authData = await AuthStorage.getUserData();
    debugPrint("AuthStorage Data after signIn: $authData");

    

    if (signInViewModel.errorMessage != null) {
      // Tampilkan pesan error jika terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(signInViewModel.errorMessage!),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (signInViewModel.authResponse != null) {
      // 1. Refresh profile data
      await context.read<ProfileViewModel>().refreshUserData();

      // 2. **Refresh SettingsViewModel** agar SettingsScreen tahu sudah login
      await context.read<SettingsViewModel>().refreshLoginState();

      // 3. Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login berhasil!"),
          duration: Duration(seconds: 1),
        ),
      );

      // 4. Navigasi ke home
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}


  /// Navigasi ke halaman Sign Up.
  void _goToSignUp() {
    Navigator.pushNamed(context, '/sign_up');
  }

  /// Tampilkan bottom sheet untuk reset password.
  void _showForgotPasswordBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Agar keyboard tidak menutup konten
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const ForgotPasswordSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Navigasi ke halaman home jika tombol back ditekan
        Navigator.pushReplacementNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background gradient
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Colors.red.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Konten utama
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: size.height * 0.1,
                ),
                child: Column(
                  children: [
                    const _HeaderWidget(),
                    const SizedBox(height: 40),
                    _LoginCard(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      onTogglePassword: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onSignIn: _signIn,
                      onForgotPassword: _showForgotPasswordBottomSheet,
                      onSignUp: _goToSignUp,
                    ),
                    const SizedBox(height: 30),
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

/// Widget header dengan logo dan pesan sambutan.
class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo menggunakan Hero untuk transisi halus
        Hero(
          tag: 'app_logo',
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Lottie.asset(
              'assets/animations/Animation_1742099923119.json',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
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
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }
}

/// Widget card login dengan latar belakang terang.
class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSignIn;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;

  const _LoginCard({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onSignIn,
    required this.onForgotPassword,
    required this.onSignUp,
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
              // Field untuk username atau email
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                  labelText: "Username or Email",
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
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? "Please enter your username or email"
                    : null,
              ),
              const SizedBox(height: 20),
              // Field untuk password
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                  labelText: "Password",
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.primary,
                    ),
                    onPressed: onTogglePassword,
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
              const SizedBox(height: 10),
              // Tombol Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onForgotPassword,
                  borderRadius: BorderRadius.circular(8),
                  splashColor: AppColors.primary.withOpacity(0.2),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Tombol Sign In
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Navigasi ke halaman Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Belum punya akun? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: onSignUp,
                    child: const Text(
                      "Sign Up",
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
  bool _loading = false;

  @override
  void initState() {
    super.initState();
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

/// ForgotPasswordSheet
Future<void> _sendOtp() async {
  if (!_forgotFormKey.currentState!.validate()) return;
  setState(() => _loading = true);

  final vm = context.read<KeamananViewModel>();
  final email = _forgotEmailController.text.trim();
  final ok = await vm.sendResetPasswordOtp(email);

  if (mounted) setState(() => _loading = false);

  if (ok) {
    // tutup bottom sheet
    Navigator.pop(context);
    // langsung push ke layar verifikasi, TAPI bungkus dengan provider
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ChangeNotifierProvider.value(
      value: vm,
      child: const ForgotPasswordVerifyEmailScreen(),
    ),
  ),
);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(vm.errorMessage ?? "Gagal mengirim OTP")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16, left: 16, right: 16,
      ),
      child: Form(
        key: _forgotFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
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
                prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                labelText: "Enter your email",
                labelStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return "Email is required";
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return "Enter a valid email";
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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