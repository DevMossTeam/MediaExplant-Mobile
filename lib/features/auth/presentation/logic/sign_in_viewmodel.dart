import 'package:flutter/material.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/usecases/sign_in.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

class SignInViewModel extends ChangeNotifier {
  final SignIn signInUseCase;

  SignInViewModel({required this.signInUseCase});

  bool _isLoading = false;
  String? _errorMessage;
  AuthResponse? _authResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await signInUseCase(email: email, password: password);
      _authResponse = result;

      // Asumsikan bahwa kelas User memiliki properti berikut:
      // uid, namaPengguna, email, profilePic, role, namaLengkap.
      await AuthStorage.saveUserData(
        token: result.token,
        uid: result.user.uid,
        namaPengguna: result.user.namaPengguna,
        email: result.user.email,
        profilePic: result.user.profilePic,
        role: result.user.role,
        namaLengkap: result.user.namaLengkap,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
