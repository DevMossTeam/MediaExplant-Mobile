import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in.dart';

class SignInViewModel extends ChangeNotifier {
  final SignIn signInUseCase;

  SignInViewModel({required this.signInUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await signInUseCase(email: email, password: password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}