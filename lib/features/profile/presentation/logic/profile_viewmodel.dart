import 'package:flutter/material.dart';
import '../../domain/entities/profile.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Profile? _profile;
  Profile? get profile => _profile;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileViewModel() {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulasi delay seperti memanggil API
      await Future.delayed(const Duration(seconds: 2));

      // Simulasi data profile yang berhasil diambil
      _profile = Profile(
        id: '123',
        name: 'John Doe',
        email: 'johndoe@example.com',
        avatarUrl: 'https://via.placeholder.com/150',
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
