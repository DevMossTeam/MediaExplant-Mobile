import 'package:flutter/material.dart';
import '../../domain/usecases/forgot_password.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final ForgotPassword forgotPasswordUseCase;

  ForgotPasswordViewModel({required this.forgotPasswordUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _emailSent = false;
  bool get emailSent => _emailSent;

  Future<void> forgotPassword({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    _emailSent = false;
    notifyListeners();

    try {
      await forgotPasswordUseCase(email: email);
      _emailSent = true;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
