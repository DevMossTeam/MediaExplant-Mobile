import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

/// ViewModel untuk profil pengguna.
/// Memuat data user (token, nama lengkap, foto profil, dll.) dari AuthStorage.
class ProfileViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  /// Menyimpan data user yang diambil dari AuthStorage.
  Map<String, String?> _userData = {};
  Map<String, String?> get userData => _userData;

  /// Getter convenience untuk nama lengkap.
  String? get fullName => _userData['nama_lengkap'];

  /// Getter convenience untuk URL foto profil.
  String? get profilePic => _userData['profile_pic'];

  ProfileViewModel() {
    _loadUserData();
  }

  /// Memuat data user dari AuthStorage.
  /// Jika terjadi error, akan menangkap dan mencetak log error-nya.
  Future<void> _loadUserData() async {
    try {
      _userData = await AuthStorage.getUserData();
      final token = _userData['token'];
      _isLoggedIn = token != null && token.isNotEmpty;
    } catch (e, stacktrace) {
      debugPrint('Error loading user data: $e\n$stacktrace');
      _userData = {};
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  /// Method publik untuk menyegarkan data user.
  Future<void> refreshUserData() async {
    await _loadUserData();
  }
}