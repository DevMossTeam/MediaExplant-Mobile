import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/core/network/api_client.dart' show ApiException;

class HubungiViewModel extends ChangeNotifier {
  final ApiClient _apiClient;

  /// Inject [ApiClient] agar mudah di‑mock saat testing
  HubungiViewModel({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _sent = false;
  bool get sent => _sent;

  String _responseMessage = '';
  String get responseMessage => _responseMessage;

  /// Kirim pesan ke endpoint `/pesan`
  Future<void> sendMessage({
    required String nama,
    required String email,
    required String pesan,
  }) async {
    _setLoading(true);
    _sent = false;
    _responseMessage = '';
    notifyListeners();

    try {
      final payload = {
        'nama': nama.trim(),
        'email': email.trim(),
        'pesan': pesan.trim(),
      };

      // POST ke /api/pesan
      final result = await _apiClient.postData('pesan', payload);

      if (result['success'] == true) {
        _sent = true;
        _responseMessage =
            result['message'] ?? 'Pesan berhasil dikirim. Terima kasih!';
      } else {
        _sent = false;
        _responseMessage =
            result['message'] ?? 'Gagal mengirim pesan. Silakan coba lagi.';
      }
    } on ApiException catch (e) {
      // Jika server mengembalikan error code (4xx/5xx)
      _sent = false;
      _responseMessage = e.message;
      if (kDebugMode) {
        debugPrint('ApiException sendMessage: $e');
      }
    } on TimeoutException {
      _sent = false;
      _responseMessage = 'Koneksi timeout. Mohon periksa jaringan Anda.';
      if (kDebugMode) {
        debugPrint('TimeoutException sendMessage');
      }
    } catch (e, st) {
      _sent = false;
      _responseMessage = 'Terjadi kesalahan. Silakan coba lagi nanti.';
      if (kDebugMode) {
        debugPrint('Unknown error sendMessage: $e\n$st');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Reset state agar form dapat digunakan ulang
  void reset() {
    _sent = false;
    _responseMessage = '';
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
