import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

/// ViewModel untuk Settings: handle login state dan logout
class SettingsViewModel extends ChangeNotifier {
  final ApiClient _apiClient;

  SettingsViewModel({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient() {
    _loadAuthState();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> _loadAuthState() async {
    final data = await AuthStorage.getUserData();
    _isLoggedIn = data['token'] != null && data['token']!.isNotEmpty;
    notifyListeners();
  }

  /// Logout user: panggil endpoint /logout dan hapus data lokal
  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    _errorMessage = '';
    notifyListeners();

    try {
      // Ambil token dari storage
      final data = await AuthStorage.getUserData();
      final token = data['token'] ?? '';

      // Kirim request logout dengan header Authorization
      await _apiClient.postData(
        'logout',
        {},
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Bersihkan local storage
      await AuthStorage.clearUserData();
      _isLoggedIn = false;
      notifyListeners();

      // Navigasi ke halaman login/splash
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _errorMessage = 'Gagal logout: \$e';
      if (kDebugMode) debugPrint('Logout error: \$e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Reset error state jika diperlukan
  void resetError() {
    _errorMessage = '';
    notifyListeners();
  }
}
