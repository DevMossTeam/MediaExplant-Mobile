import 'package:flutter/foundation.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

class KeamananViewModel extends ChangeNotifier {
  final ApiClient _apiClient;

  KeamananViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _sentOtpEmail;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get sentOtpEmail => _sentOtpEmail;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String msg) {
    _successMessage = msg;
    _errorMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    clearMessages();
    _setLoading(true);
    try {
      final data = await AuthStorage.getUserData();
      final token = data['token'] ?? '';
      final resp = await _apiClient.postData(
        'password/change',
        {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp['success'] == true) {
        _setSuccess(resp['message'] ?? 'Password berhasil diubah!');
        return true;
      } else {
        _setError(resp['message'] ?? 'Gagal mengubah password.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  Future<bool> sendChangeEmailOtp() async {
    clearMessages();
    _setLoading(true);
    try {
      final data = await AuthStorage.getUserData();
      final token = data['token'] ?? '';
      final resp = await _apiClient.postData(
        'email/send-change-otp',
        {},
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp['success'] == true) {
        _sentOtpEmail = data['email']; // ✅ set email yang dipakai kirim OTP
        _setSuccess(resp['message'] ?? 'OTP berhasil dikirim.');
        return true;
      } else {
        _setError(resp['message'] ?? 'Gagal mengirim OTP.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  Future<bool> verifyChangeEmailOtp(String otp) async {
    clearMessages();
    _setLoading(true);
    try {
      final data = await AuthStorage.getUserData();
      final token = data['token'] ?? '';
      final resp = await _apiClient.postData(
        'email/verify-change-otp',
        {'otp': otp},
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp['success'] == true) {
        _setSuccess(resp['message'] ?? 'Verifikasi berhasil.');
        return true;
      } else {
        _setError(resp['message'] ?? 'OTP tidak valid.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  Future<bool> sendResetPasswordOtp(String email) async {
    clearMessages();
    _setLoading(true);
    try {
      final resp = await _apiClient.postData(
        'password/send-reset-otp',
        {'email': email},
      );
      if (resp['success'] == true) {
        _setSuccess(resp['message'] ?? 'OTP berhasil dikirim.');
        return true;
      } else {
        _setError(resp['message'] ?? 'Email tidak ditemukan.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }
}