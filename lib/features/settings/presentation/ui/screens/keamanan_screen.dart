import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart'; // Ganti dengan path yang sesuai

class KeamananScreen extends StatelessWidget {
  const KeamananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Halaman
            const Text(
              'Keamanan Akun Anda',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kelola pengaturan keamanan untuk melindungi akun Anda.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            // Daftar opsi keamanan
            _buildSecurityOption(
              context,
              icon: Icons.lock_outline,
              title: 'Ganti Password',
              description:
                  'Ubah password untuk meningkatkan keamanan akun Anda.',
              onTap: () {
                // Tampilkan bottom sheet untuk ganti password
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => const ChangePasswordSheet(),
                );
              },
            ),
            _buildSecurityOption(
              context,
              icon: Icons.email_outlined,
              title: 'Ganti Email',
              description:
                  'Ubah alamat email yang terkait dengan akun Anda.',
              onTap: () {
                // Tampilkan bottom sheet untuk ganti email
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => const ChangeEmailSheet(),
                );
              },
            ),
            _buildSecurityOption(
              context,
              icon: Icons.help_outline,
              title: 'Lupa Password',
              description:
                  'Reset password jika Anda lupa password akun Anda.',
              onTap: () {
                // Tampilkan bottom sheet untuk lupa password
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => const ForgotPasswordSheet(),
                );
              },
            ),
            const SizedBox(height: 24),
            // Tips Keamanan
            const Text(
              'Tips Keamanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Jangan bagikan informasi login Anda kepada siapa pun.\n'
              '• Gunakan password yang kuat dan unik untuk setiap akun.\n'
              '• Perbarui pengaturan keamanan secara berkala.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk opsi keamanan dengan onTap
  Widget _buildSecurityOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: AppColors.primary,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.text,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.text.withOpacity(0.8),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.text.withOpacity(0.6),
        ),
      ),
    );
  }
}

/// Bottom sheet untuk Reset Password (Lupa Password)
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
    // Meminta fokus segera setelah bottom sheet muncul.
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
      // Tutup bottom sheet
      Navigator.pop(context);
      // Tampilkan SnackBar sebagai feedback bahwa OTP telah dikirim
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP sent to ${_forgotEmailController.text}"),
        ),
      );
      // Arahkan ke route verifikasi OTP (pastikan route ini sudah didefinisikan di AppRouter)
      Navigator.pushNamed(context, '/forgot_password_verify_email');
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

/// Bottom sheet untuk Ganti Email.
class ChangeEmailSheet extends StatelessWidget {
  const ChangeEmailSheet({Key? key}) : super(key: key);

  void _sendVerification(BuildContext context) {
    // Tutup bottom sheet terlebih dahulu
    Navigator.pop(context);
    // Tampilkan SnackBar sebagai feedback bahwa kode verifikasi telah dikirim
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kode verifikasi telah dikirim ke email Anda.")),
    );
    // Navigasikan ke halaman verifikasi OTP untuk ganti email.
    Navigator.pushNamed(context, '/change_email_verify_email');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Gunakan MediaQuery agar konten tidak tertutup oleh keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Ganti Email",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Apakah Anda yakin ingin mengirim kode verifikasi ke email Anda?",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Batal",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _sendVerification(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Kirim Kode",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Bottom sheet untuk Ganti Password.
class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({Key? key}) : super(key: key);

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final GlobalKey<FormState> _changeFormKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _currentPasswordFocus = FocusNode();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    // Minta fokus pada field current password ketika bottom sheet muncul.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_currentPasswordFocus);
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordFocus.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_changeFormKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password changed successfully"),
        ),
      );
      // TODO: Implementasikan logika ganti password.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Form(
        key: _changeFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Ganti Password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            // Field: Password Saat Ini
            TextFormField(
              controller: _currentPasswordController,
              focusNode: _currentPasswordFocus,
              obscureText: _obscureCurrent,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.lock_outline, color: AppColors.primary),
                labelText: "Password Saat Ini",
                labelStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrent ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrent = !_obscureCurrent;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Password saat ini wajib diisi";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Field: Password Baru
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                labelText: "Password Baru",
                labelStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNew ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNew = !_obscureNew;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Password baru wajib diisi";
                }
                if (value.length < 6) {
                  return "Password baru minimal 6 karakter";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Field: Konfirmasi Password Baru
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                labelText: "Konfirmasi Password",
                labelStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Konfirmasi password wajib diisi";
                }
                if (value != _newPasswordController.text) {
                  return "Password tidak cocok";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Change Password",
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
