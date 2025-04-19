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
  String? _sentOtpEmail;     // email lama utk ganti email
  String? _pendingNewEmail;  // simpan email baru sementara
  String? _sentResetEmail;   // email utk reset password

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get sentOtpEmail => _sentOtpEmail;
  String? get pendingNewEmail => _pendingNewEmail;
  String? get sentResetEmail => _sentResetEmail;

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

  //────────────────────────────────────────────────
  // 1) CHANGE PASSWORD (sudah OK)
  //────────────────────────────────────────────────

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

  //────────────────────────────────────────────────
  // 2) GANTI EMAIL – STEP 1: Verifikasi email lama
  //────────────────────────────────────────────────

  /// Kirim OTP ke email lama
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
        _sentOtpEmail = data['email'];
        _setSuccess(resp['message'] ?? 'OTP ke email lama terkirim.');
        return true;
      } else {
        _setError(resp['message'] ?? 'Gagal kirim OTP email lama.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  /// Verifikasi OTP email lama
  Future<bool> verifyOldEmailOtp(String otp) async {
    clearMessages();
    _setLoading(true);
    try {
      final data = await AuthStorage.getUserData();
      final token = data['token'] ?? '';
      final resp = await _apiClient.postData(
        'email/verify-old-email-otp',
        {'otp': otp},
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp['success'] == true) {
        _setSuccess(resp['message'] ?? 'Email lama terverifikasi.');
        return true;
      } else {
        _setError(resp['message'] ?? 'OTP email lama tidak valid.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  //────────────────────────────────────────────────
  // 3) GANTI EMAIL – STEP 2: Input & verifikasi email baru
  //────────────────────────────────────────────────

  /// Kirim OTP ke email baru yang di-input user
  Future<bool> sendNewEmailOtp(String newEmail) async {
    clearMessages();
    _setLoading(true);
    try {
      final data = await AuthStorage.getUserData();
      final token = data['token'] ?? '';
      final resp = await _apiClient.postData(
        'email/send-new-email-otp',
        {'new_email': newEmail},
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp['success'] == true) {
        _pendingNewEmail = newEmail;
        _setSuccess(resp['message'] ?? 'OTP ke email baru terkirim.');
        return true;
      } else {
        _setError(resp['message'] ?? 'Gagal kirim OTP email baru.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  /// Verifikasi OTP email baru & simpan email baru
  Future<bool> verifyNewEmailOtp(String otp) async {
    clearMessages();
    _setLoading(true);
    try {
      final data = await AuthStorage.getUserData();
      final token = data['token'] ?? '';
      final resp = await _apiClient.postData(
        'email/verify-new-email-otp',
        {'otp': otp},
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp['success'] == true) {
        _setSuccess(resp['message'] ?? 'Email baru diverifikasi & disimpan.');
        return true;
      } else {
        _setError(resp['message'] ?? 'OTP email baru tidak valid.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  //────────────────────────────────────────────────
  // 4) LUPA PASSWORD: send OTP, verify OTP, reset pw
  //────────────────────────────────────────────────

  /// Kirim OTP untuk reset password
  Future<bool> sendResetPasswordOtp(String email) async {
    clearMessages();
    _setLoading(true);
    try {
      final resp = await _apiClient.postData(
        'password/send-reset-otp',
        {'email': email},
      );
      if (resp['success'] == true) {
        _sentResetEmail = email;
        _setSuccess(resp['message'] ?? 'OTP reset password terkirim.');
        return true;
      } else {
        _setError(resp['message'] ?? 'Gagal kirim OTP reset password.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  /// Verifikasi OTP reset password
  Future<bool> verifyResetPasswordOtp(String otp) async {
    clearMessages();
    _setLoading(true);
    try {
      final resp = await _apiClient.postData(
        'password/verify-reset-otp',
        {
          'email': _sentResetEmail,
          'otp': otp,
        },
      );
      if (resp['success'] == true) {
        _setSuccess(resp['message'] ?? 'OTP reset valid.');
        return true;
      } else {
        _setError(resp['message'] ?? 'OTP reset tidak valid.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }

  /// Reset password setelah OTP terverifikasi
  Future<bool> resetPassword({
    required String otp,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    clearMessages();
    _setLoading(true);
    try {
      final resp = await _apiClient.postData(
        'password/reset',
        {
          'email': _sentResetEmail,
          'otp': otp,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
      if (resp['success'] == true) {
        _setSuccess(resp['message'] ?? 'Password berhasil direset.');
        return true;
      } else {
        _setError(resp['message'] ?? 'Gagal reset password.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    return false;
  }
}
