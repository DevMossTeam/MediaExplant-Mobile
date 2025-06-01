import 'package:flutter/material.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/usecases/register_step1.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/register_step3.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

class SignUpViewModel extends ChangeNotifier {
  final RegisterStep1 registerStep1UseCase;
  final VerifyOtp verifyOtpUseCase;
  final RegisterStep3 registerStep3UseCase;

  SignUpViewModel({
    required this.registerStep1UseCase,
    required this.verifyOtpUseCase,
    required this.registerStep3UseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _otpVerified = false;
  bool get otpVerified => _otpVerified;

  AuthResponse? _authResponse;
  AuthResponse? get authResponse => _authResponse;

  /// Properti baru: menandai apakah user sudah dianggap “logged in”
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<Map<String, dynamic>> registerStep1({
    required String namaLengkap,
    required String namaPengguna,
    required String email,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await registerStep1UseCase(
        namaLengkap: namaLengkap,
        namaPengguna: namaPengguna,
        email: email,
      );

      if (response['success'] != true) {
        // Pesan dari API diasumsikan sudah dalam Bahasa Indonesia
        _setError(_cleanError(response['message']));
      }

      return response;
    } catch (e) {
      _setError(_cleanError(e.toString()));
      return {'success': false, 'message': _errorMessage};
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await verifyOtpUseCase(email: email, otp: otp);

      if (response['success'] == true) {
        _otpVerified = true;
        notifyListeners();
      } else {
        _setError(_cleanError(response['message']));
      }

      return response;
    } catch (e) {
      _setError(_cleanError(e.toString()));
      return {'success': false, 'message': _errorMessage};
    } finally {
      _setLoading(false);
    }
  }

  /// Sekarang mengembalikan AuthResponse? agar UI bisa langsung cek hasilnya
  Future<AuthResponse?> registerStep3({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final authRes = await registerStep3UseCase(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      _authResponse = authRes;
      notifyListeners();

      // Simpan data pengguna dan token
      await AuthStorage.saveUserData(
        token: authRes.token,
        uid: authRes.user.uid,
        namaPengguna: authRes.user.namaPengguna,
        email: authRes.user.email,
        profilePic: authRes.user.profilePic,
        role: authRes.user.role,
        namaLengkap: authRes.user.namaLengkap,
      );

      // === BAGIAN BARU: Tandai user sebagai “logged in” ===
      _isLoggedIn = true;
      notifyListeners();
      // ===================================================

      return _authResponse;
    } catch (e) {
      _setError(_cleanError(e.toString()));
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Fungsi bantu untuk membersihkan prefix "ApiException..." di depan pesan asli.
  String _cleanError(String raw) {
    return raw.replaceAll(
      RegExp(r'^ApiException.*?:\s*', caseSensitive: false),
      '',
    );
  }
}
