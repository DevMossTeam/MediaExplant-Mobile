import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart'; // Ganti dengan path yang sesuai
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/settings/logic/keamanan_viewmodel.dart'; // import ViewModel
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart'; // <-- import fluttertoast

class KeamananScreen extends StatefulWidget {
  const KeamananScreen({Key? key}) : super(key: key);

  @override
  State<KeamananScreen> createState() => _KeamananScreenState();
}

class _KeamananScreenState extends State<KeamananScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<KeamananViewModel>(
      create: (ctx) => KeamananViewModel(apiClient: ctx.read<ApiClient>()),
      child: Consumer<KeamananViewModel>(
        builder: (ctx, vm, _) {
          // Optional: reset messages setiap kali rebuild body
          if (vm.errorMessage != null || vm.successMessage != null) {
            // tampilkan SnackBar kalau perlu
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final msg = vm.errorMessage ?? vm.successMessage!;
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(msg)),
              );
              vm.clearMessages();
            });
          }

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
                    style: TextStyle(fontSize: 16, color: AppColors.text),
                  ),
                  const SizedBox(height: 16),

                  _buildSecurityOption(
                    ctx,
                    icon: Icons.lock_outline,
                    title: 'Ganti Password',
                    description: 'Ubah password untuk meningkatkan keamanan akun Anda.',
                    onTap: () {
                      final vmInstance = ctx.read<KeamananViewModel>();
                      showModalBottomSheet(
                        context: ctx,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => ChangeNotifierProvider.value(
                          value: vmInstance,
                          child: const ChangePasswordSheet(),
                        ),
                      );
                    },
                  ),

                  _buildSecurityOption(
                    ctx,
                    icon: Icons.email_outlined,
                    title: 'Ganti Email',
                    description: 'Ubah alamat email yang terkait dengan akun Anda.',
                    onTap: () {
                      final vmInstance = ctx.read<KeamananViewModel>();
                      showModalBottomSheet(
                        context: ctx,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => ChangeNotifierProvider.value(
                          value: vmInstance,
                          child: const ChangeEmailSheet(),
                        ),
                      );
                    },
                  ),

                  _buildSecurityOption(
                    ctx,
                    icon: Icons.help_outline,
                    title: 'Lupa Password',
                    description: 'Reset password jika Anda lupa password akun Anda.',
                    onTap: () {
                      final vmInstance = ctx.read<KeamananViewModel>();
                      showModalBottomSheet(
                        context: ctx,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => ChangeNotifierProvider.value(
                          value: vmInstance,
                          child: const ForgotPasswordSheet(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
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
                    style: TextStyle(fontSize: 16, height: 1.5, color: AppColors.text),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
        leading: Icon(icon, color: AppColors.primary, size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.text),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 14, color: AppColors.text.withOpacity(0.8)),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.text.withOpacity(0.6)),
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

  // Matikan loading dulu
  if (mounted) setState(() => _loading = false);

  if (ok) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(vm.successMessage ?? "OTP sent to $email")),
    );
    Navigator.pushNamed(context, '/forgot_password_verify_email');
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

class ChangeEmailSheet extends StatefulWidget {
  const ChangeEmailSheet({Key? key}) : super(key: key);

  @override
  State<ChangeEmailSheet> createState() => _ChangeEmailSheetState();
}

class _ChangeEmailSheetState extends State<ChangeEmailSheet> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  bool _loadingSend = false;
  bool _loadingVerify = false;
  bool _otpSent = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
      }
      setState(() => _secondsLeft--);
    });
  }

  String _obfuscateEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) {
      return '${name[0]}***@$domain';
    } else {
      return '${name[0]}***${name[name.length - 1]}@$domain';
    }
  }

  Future<void> _sendVerification() async {
    setState(() => _loadingSend = true);
    final vm = context.read<KeamananViewModel>();
    final ok = await vm.sendChangeEmailOtp(); // Kirim OTP email lama

    if (mounted) {
      setState(() {
        _loadingSend = false;
        if (ok) {
          _otpSent = true;
          _startTimer();
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ok) {
          final email = vm.sentOtpEmail ?? '-';
          final displayed = _obfuscateEmail(email);
          Fluttertoast.showToast(
            msg: 'OTP dikirim ke $displayed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 14,
          );
          _otpFocusNode.requestFocus();
        } else {
          Fluttertoast.showToast(
            msg: vm.errorMessage ?? 'Gagal kirim OTP',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      });
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Masukkan kode OTP terlebih dahulu',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() => _loadingVerify = true);
    final vm = context.read<KeamananViewModel>();
    // Panggil verifyOldEmailOtp, bukan verifyChangeEmailOtp
    final ok = await vm.verifyOldEmailOtp(otp);

    if (mounted) {
      setState(() => _loadingVerify = false);

      if (ok) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: vm.successMessage ?? 'Email lama terverifikasi',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        // Lanjut ke step 2: input email baru
        Navigator.pushNamed(context, '/change_email_form');
      } else {
        Fluttertoast.showToast(
          msg: vm.errorMessage ?? 'OTP tidak valid',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16, left: 16, right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Verifikasi Email Lama',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  keyboardType: TextInputType.number,
                  enabled: _otpSent,
                  decoration: InputDecoration(
                    labelText: 'Kode OTP',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    hintText: _otpSent ? null : 'Kirim OTP terlebih dahulu',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _loadingSend
                  ? const SizedBox(
                      height: 24, width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : GestureDetector(
                      onTap: _secondsLeft > 0 ? null : _sendVerification,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (_otpSent && _secondsLeft > 0)
                                ? Colors.grey
                                : AppColors.primary,
                          ),
                        ),
                        child: Text(
                          (_otpSent && _secondsLeft > 0)
                              ? '$_secondsLeft'
                              : 'Kirim',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (_otpSent && _secondsLeft > 0)
                                ? Colors.grey
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_loadingVerify || !_otpSent) ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _loadingVerify
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Verifikasi',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
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
  bool _loading = false;

  @override
  void initState() {
    super.initState();
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

/// ChangePasswordSheet
Future<void> _changePassword() async {
  if (!_changeFormKey.currentState!.validate()) return;
  setState(() => _loading = true);

  final vm = context.read<KeamananViewModel>();
  final ok = await vm.changePassword(
    currentPassword: _currentPasswordController.text.trim(),
    newPassword: _newPasswordController.text.trim(),
  );

  // Matikan loading dulu
  if (mounted) setState(() => _loading = false);

  if (ok) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(vm.successMessage ?? "Password berhasil diubah")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(vm.errorMessage ?? "Gagal mengubah password")),
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
                onPressed: _loading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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
