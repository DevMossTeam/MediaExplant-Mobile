import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/settings/logic/keamanan_viewmodel.dart';

/// Halaman Input & Verifikasi OTP Email Baru (Step 2 ganti email).
class ChangeEmailFormScreen extends StatefulWidget {
  const ChangeEmailFormScreen({Key? key}) : super(key: key);

  @override
  State<ChangeEmailFormScreen> createState() => _ChangeEmailFormScreenState();
}

class _ChangeEmailFormScreenState extends State<ChangeEmailFormScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _sendingOtp = false;
  bool _verifyingOtp = false;
  bool _otpSent = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) timer.cancel();
      setState(() => _secondsLeft--);
    });
  }

  Future<void> _sendNewEmailOtp() async {
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() => _sendingOtp = true);
    final vm = context.read<KeamananViewModel>();
    final ok = await vm.sendNewEmailOtp(_emailController.text.trim());
    setState(() => _sendingOtp = false);

    if (ok) {
      setState(() {
        _otpSent = true;
        _startTimer();
      });
      Fluttertoast.showToast(
        msg: vm.successMessage ?? 'OTP terkirim ke email baru',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Gagal kirim OTP')),
      );
    }
  }

  Future<void> _verifyNewEmailOtp() async {
    if (!_otpFormKey.currentState!.validate()) return;

    setState(() => _verifyingOtp = true);
    final vm = context.read<KeamananViewModel>();
    final ok = await vm.verifyNewEmailOtp(_otpController.text.trim());
    setState(() => _verifyingOtp = false);

    if (ok) {
      Fluttertoast.showToast(
        msg: vm.successMessage ?? 'Email baru berhasil diverifikasi',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'OTP tidak valid')),
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

                // STEP 2a: Input Email Baru
                if (!_otpSent) ...[
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _emailFormKey,
                        child: Column(
                          children: [
                            Text(
                              'Masukkan Email Baru',
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
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: AppColors.primary,
                                ),
                                labelText: 'Email Baru',
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
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email baru wajib diisi';
                                }
                                if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}")
                                    .hasMatch(value.trim())) {
                                  return 'Format email tidak valid';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: (_sendingOtp || vmLoading)
                                    ? null
                                    : _sendNewEmailOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: (_sendingOtp || vmLoading)
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'Kirim OTP Email Baru',
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

                // STEP 2b: Verifikasi OTP Baru
                if (_otpSent) ...[
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
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
                                prefixIcon: const Icon(Icons.confirmation_number,
                                    color: AppColors.primary),
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
                                suffix: _secondsLeft > 0
                                    ? Text('$_secondsLeft s')
                                    : null,
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
                                onPressed: _verifyingOtp
                                    ? null
                                    : _verifyNewEmailOtp, // tidak lagi cek _secondsLeft
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _verifyingOtp
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
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

                            // Tombol "Kirim Ulang OTP" muncul saat timer habis
                            if (_secondsLeft <= 0) ...[
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed:
                                    (_sendingOtp || vmLoading) ? null : _sendNewEmailOtp,
                                child: const Text('Kirim Ulang OTP'),
                              ),
                            ],
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
          tag: 'change_email_logo',
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.email_outlined,
              size: 48,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Ganti Email',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Masukkan alamat email baru & verifikasi OTP',
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
