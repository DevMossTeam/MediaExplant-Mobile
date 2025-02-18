import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_up.dart';

class SignUpViewModel extends ChangeNotifier {
  final SignUp signUpUseCase;

  SignUpViewModel({required this.signUpUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await signUpUseCase(username: username, email: email, password: password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}