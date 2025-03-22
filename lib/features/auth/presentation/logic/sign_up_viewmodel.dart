import 'package:flutter/material.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/usecases/register_step1.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/register_step3.dart';

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

  Future<Map<String, dynamic>> registerStep1({
    required String namaLengkap,
    required String namaPengguna,
    required String email,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await registerStep1UseCase(
        namaLengkap: namaLengkap,
        namaPengguna: namaPengguna,
        email: email,
      );
      if (response['success'] != true) {
        _errorMessage = response['message'];
      }
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return {'success': false, 'message': _errorMessage};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await verifyOtpUseCase(email: email, otp: otp);
      if (response['success'] == true) {
        _otpVerified = true;
      } else {
        _errorMessage = response['message'];
      }
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return {'success': false, 'message': _errorMessage};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerStep3({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authRes = await registerStep3UseCase(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      _authResponse = authRes;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}