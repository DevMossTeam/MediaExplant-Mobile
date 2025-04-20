import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

/// ViewModel untuk Settings: handle login state dan logout
typedef VoidContextCallback = void Function(BuildContext context);
class SettingsViewModel extends ChangeNotifier {
  final ApiClient _apiClient;

  SettingsViewModel({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient() {
    // Inisiasi dan langganan perubahan auth
    loadAuthState();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Load dan update status login dari storage
  Future<void> loadAuthState() async {
    _setLoading(true);
    try {
      final data = await AuthStorage.getUserData();
      final token = data['token'];
      final newLoggedIn = token != null && token.isNotEmpty;
      if (newLoggedIn != _isLoggedIn) {
        _isLoggedIn = newLoggedIn;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading auth state: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Panggil untuk refresh manual status login jika diperlukan
  Future<void> refreshLoginState() => loadAuthState();

  /// Logout user: panggil endpoint /logout dan hapus data lokal
  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    _errorMessage = '';
    notifyListeners();

    try {
      final data = await AuthStorage.getUserData();
      final token = data['token'] ?? '';

      await _apiClient.postData(
        'logout',
        {},
        headers: {'Authorization': 'Bearer $token'},
      );

      await AuthStorage.clearUserData();
      _isLoggedIn = false;
      notifyListeners();

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _errorMessage = 'Gagal logout: $e';
      if (kDebugMode) debugPrint('Logout error: $e');
      notifyListeners();
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
