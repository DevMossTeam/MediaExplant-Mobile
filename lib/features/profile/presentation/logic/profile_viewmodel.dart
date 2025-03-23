import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Menyimpan data user (jika diperlukan untuk tampilan profil)
  Map<String, String?> _userData = {};
  Map<String, String?> get userData => _userData;

  ProfileViewModel() {
    // Secara otomatis periksa status login ketika viewmodel dibuat.
    checkLoginStatus();
  }

  /// Memeriksa status login dengan mengambil data dari AuthStorage.
  Future<void> checkLoginStatus() async {
    _userData = await AuthStorage.getUserData();
    final token = _userData['token'];
    if (token != null && token.isNotEmpty) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }
}