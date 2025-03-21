import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in.dart';

class SignInViewModel extends ChangeNotifier {
  final SignIn signInUseCase;

  SignInViewModel({required this.signInUseCase});

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await signInUseCase(email: email, password: password);
      _user = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
