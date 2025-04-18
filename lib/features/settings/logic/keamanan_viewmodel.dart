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

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String msg) {
    _successMessage = msg;
    _errorMessage = null;
    notifyListeners();
  }

  /// 1. Ganti password: kirim ke API `/password/change`
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
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
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (resp['success'] == true) {
        _setSuccess(resp['message'] as String? ?? 'Password berhasil diubah!');
        return true;
      } else {
        _setError(resp['message'] as String? ?? 'Gagal mengubah password.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  /// 2. Kirim OTP ke email terdaftar untuk ganti email.
  ///    API route: POST /email/send-change-otp
  Future<bool> sendChangeEmailOtp() async {
    _setLoading(true);
    try {
      final data = await AuthStorage.getUserData();
      final token = data['token'] ?? '';

      final resp = await _apiClient.postData(
        'email/send-change-otp',
        {}, // tidak perlu payload selain header
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (resp['success'] == true) {
        _setSuccess(resp['message'] as String? ?? 'OTP berhasil dikirim.');
        return true;
      } else {
        _setError(resp['message'] as String? ?? 'Gagal mengirim OTP.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  /// 3. Kirim OTP untuk reset password.
  ///    API route: POST /password/send-reset-otp
  ///    Hanya jika email terdaftar di database.
  Future<bool> sendResetPasswordOtp(String email) async {
    _setLoading(true);
    try {
      final resp = await _apiClient.postData(
        'password/send-reset-otp',
        {'email': email},
      );

      if (resp['success'] == true) {
        _setSuccess(resp['message'] as String? ?? 'OTP berhasil dikirim.');
        return true;
      } else {
        _setError(resp['message'] as String? ?? 'Email tidak ditemukan.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }
}
