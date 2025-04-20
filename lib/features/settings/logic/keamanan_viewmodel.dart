import 'package:flutter/foundation.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

class KeamananViewModel extends ChangeNotifier {
  final ApiClient _apiClient;

  KeamananViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  // General state
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // CHANGE EMAIL state
  String? _sentOtpEmail;     // email lama untuk ganti email
  String? _pendingNewEmail;  // email baru sementara

  // FORGOT PASSWORD state
  String? _pendingResetEmail;       // email yang user input di step 1
  bool _isResetOtpVerified = false; // flag OTP sudah diverifikasi

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  String? get sentOtpEmail => _sentOtpEmail;
  String? get pendingNewEmail => _pendingNewEmail;

  String? get pendingResetEmail => _pendingResetEmail;
  bool get isResetOtpVerified => _isResetOtpVerified;

  // Internal setters
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

  /// Clear both success and error messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  //────────────────────────────────────────────────
  // 1) CHANGE PASSWORD
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
  // 2) CHANGE EMAIL – STEP 1: Verifikasi email lama
  //────────────────────────────────────────────────

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
  // 3) CHANGE EMAIL – STEP 2: Input & verifikasi email baru
  //────────────────────────────────────────────────

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
  // 4) LUPA PASSWORD – STEP 1: Kirim OTP
  //────────────────────────────────────────────────

  Future<bool> sendResetPasswordOtp(String email) async {
    clearMessages();
    _setLoading(true);
    try {
      final resp = await _apiClient.postData(
        'password/send-reset-otp',
        {'email': email},
      );
      if (resp['success'] == true) {
        _pendingResetEmail = email;
        _isResetOtpVerified = false;
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

  //────────────────────────────────────────────────
  // 5) LUPA PASSWORD – STEP 2: Verifikasi OTP
  //────────────────────────────────────────────────

  Future<bool> verifyResetPasswordOtp(String otp) async {
    if (_pendingResetEmail == null) {
      _setError('Silakan kirim OTP ke email terlebih dahulu.');
      return false;
    }
    clearMessages();
    _setLoading(true);
    try {
      final resp = await _apiClient.postData(
        'password/verify-reset-otp',
        {
          'email': _pendingResetEmail,
          'otp': otp,
        },
      );
      if (resp['success'] == true) {
        _isResetOtpVerified = true;
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

  //────────────────────────────────────────────────
  // 6) LUPA PASSWORD – STEP 3: Reset Password
  //────────────────────────────────────────────────

  Future<bool> resetPassword({
    required String otp,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (_pendingResetEmail == null) {
      _setError('Silakan kirim OTP ke email terlebih dahulu.');
      return false;
    }
    if (!_isResetOtpVerified) {
      _setError('Silakan verifikasi OTP terlebih dahulu.');
      return false;
    }
    clearMessages();
    _setLoading(true);
    try {
      final resp = await _apiClient.postData(
        'password/reset',
        {
          'email': _pendingResetEmail,
          'otp': otp,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
      if (resp['success'] == true) {
        _setSuccess(resp['message'] ?? 'Password berhasil direset.');
        // Reset forgot-password state
        _pendingResetEmail = null;
        _isResetOtpVerified = false;
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
