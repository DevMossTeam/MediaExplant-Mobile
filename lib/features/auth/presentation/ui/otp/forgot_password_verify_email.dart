import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/settings/logic/keamanan_viewmodel.dart';

/// Halaman Verifikasi OTP & Reset Password (Forgot Password)
class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  final _otpFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _verifyingOtp = false;
  bool _resettingPassword = false;
  bool _otpVerified = false;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (!_otpFormKey.currentState!.validate()) return;
    setState(() => _verifyingOtp = true);
    final vm = context.read<KeamananViewModel>();
    final ok = await vm.verifyResetPasswordOtp(_otpController.text.trim());
    setState(() => _verifyingOtp = false);

    if (ok) {
      Fluttertoast.showToast(
        msg: vm.successMessage ?? 'OTP valid, silakan buat password baru.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      setState(() => _otpVerified = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'OTP tidak valid'),
        ),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    setState(() => _resettingPassword = true);
    final vm = context.read<KeamananViewModel>();
    final ok = await vm.resetPassword(
      otp: _otpController.text.trim(),
      newPassword: _newPasswordController.text,
      newPasswordConfirmation: _confirmPasswordController.text,
    );
    setState(() => _resettingPassword = false);

    if (ok) {
      Fluttertoast.showToast(
        msg: vm.successMessage ?? 'Password berhasil direset.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Gagal reset password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vmLoading = context.watch<KeamananViewModel>().isLoading;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, Colors.red.shade900],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Header(),
                const SizedBox(height: 30),

                // STEP 1: Verifikasi OTP
                if (!_otpVerified) ...[
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _otpFormKey,
                        child: Column(
                          children: [
                            Text(
                              'Masukkan Kode OTP',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.confirmation_number,
                                  color: AppColors.primary,
                                ),
                                labelText: 'OTP',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'OTP wajib diisi';
                                }
                                if (val.trim().length != 6) {
                                  return 'OTP terdiri dari 6 digit';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: (vmLoading || _verifyingOtp)
                                    ? null
                                    : _verifyOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _verifyingOtp
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Verifikasi OTP',
                                        style: TextStyle(
                                          fontSize: 16,
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
                ],

                // STEP 2: Buat Password Baru
                if (_otpVerified) ...[
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _passwordFormKey,
                        child: Column(
                          children: [
                            Text(
                              'Buat Password Baru',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _newPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primary,
                                ),
                                labelText: 'Password Baru',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Password baru wajib diisi';
                                }
                                if (val.length < 6) {
                                  return 'Password minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primary,
                                ),
                                labelText: 'Konfirmasi Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Konfirmasi password wajib diisi';
                                }
                                if (val != _newPasswordController.text) {
                                  return 'Password tidak cocok';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: (vmLoading || _resettingPassword)
                                    ? null
                                    : _resetPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _resettingPassword
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Reset Password',
                                        style: TextStyle(
                                          fontSize: 16,
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
                ],

                const SizedBox(height: 40),
                const _Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Header dengan ikon dan judul
class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'forgot_password_logo',
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.lock_reset,
              size: 48,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Lupa Password',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Masukkan kode OTP & buat password baru',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

/// Footer dengan copyright
class _Footer extends StatelessWidget {
  const _Footer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 20),
        Text(
          '© 2025 MediaExPlant',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 4),
        Text(
          'Privacy Policy | Terms of Service',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
