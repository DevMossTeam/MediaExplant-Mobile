import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:mediaexplant/core/network/api_client.dart';

class SettingNotifikasiViewModel extends ChangeNotifier {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final ApiClient _apiClient = ApiClient();

  bool _pushNotifications = true;
  bool get pushNotifications => _pushNotifications;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Menyimpan token FCM yang aktif
  String? _deviceToken;
  String? get deviceToken => _deviceToken;

  /// StreamSubscription untuk onTokenRefresh agar bisa dibatalkan
  StreamSubscription<String>? _tokenRefreshSubscription;

  SettingNotifikasiViewModel() {
    _initPreferencesAndFCM();
  }

  /// 1) Baca SharedPreferences → kemudian inisialisasi atau disable FCM
  Future<void> _initPreferencesAndFCM() async {
    final prefs = await SharedPreferences.getInstance();
    _pushNotifications = prefs.getBool('pushNotifications') ?? true;
    debugPrint('[Notifikasi] loadPreferences: $_pushNotifications');

    if (_pushNotifications) {
      // Bila sebelumnya sudah ON, langsung enable FCM
      await _enableFCM_internal();
    } else {
      // Jika sebelumnya OFF, pastikan FCM benar‐benar dinonaktifkan
      await _disableFCM_internal();
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// 2) Saat user toggle ON/OFF di UI
  Future<void> updatePushNotifications(bool value) async {
    debugPrint('[Notifikasi] updatePushNotifications: $value');

    if (value) {
      // a) Request permission sekali saja di sini
      final status = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('[Notifikasi] Permission: ${status.authorizationStatus}');

      if (status.authorizationStatus == AuthorizationStatus.authorized) {
        // b) Aktifkan FCM
        await _enableFCM_internal();
      } else {
        debugPrint('[Notifikasi] User menolak permission notifikasi');
        // Jangan simpan pref jika permission ditolak
        return;
      }
    } else {
      // c) Matikan FCM
      await _disableFCM_internal();
    }

    // d) Simpan flag baru ke SharedPreferences
    _pushNotifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', value);
    debugPrint('[Notifikasi] SharedPreferences updated: $_pushNotifications');

    notifyListeners();
  }

  /// PRIVATE: Langkah‐langkah untuk mengaktifkan FCM
  Future<void> _enableFCM_internal() async {
    try {
      debugPrint('[Notifikasi] >> Enabling FCM...');

      // 1) Aktifkan autoInit (agar FirebaseMessaging dapat generate token baru)
      await _fcm.setAutoInitEnabled(true);
      debugPrint('[Notifikasi] setAutoInitEnabled(true) done.');

      // 2) Ambil token FCM baru
      final token = await _fcm.getToken();
      if (token != null) {
        await _updateDeviceToken(token);
      } else {
        debugPrint('[Notifikasi] getToken() returned null.');
      }

      // 3) Dengar token refresh (cancelling listener yang lama jika ada)
      await _tokenRefreshSubscription?.cancel();
      _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh.listen(
        (newToken) async {
          debugPrint('[Notifikasi] onTokenRefresh: $newToken');
          await _updateDeviceToken(newToken);
        },
      );

      // 4) Subscribe ke topic global (opsional; sesuaikan dengan kebutuhan backend)
      await _fcm.subscribeToTopic('all');
      debugPrint('[Notifikasi] subscribeToTopic("all") sukses.');

    } catch (e) {
      debugPrint('[Notifikasi] ❌ Error di _enableFCM_internal(): $e');
    }
  }

  /// PRIVATE: Kirim token FCM ke backend dan simpan lokal
  Future<void> _updateDeviceToken(String token) async {
    _deviceToken = token;
    debugPrint('[Notifikasi] 🎫 Got FCM Device Token: $token');
    notifyListeners();

    // Kirim token ke backend Laravel di endpoint “device-token”
    final payload = {
      'device_token': token,
      'device_type': Platform.isAndroid ? 'android' : 'ios',
    };
    try {
      final resp = await _apiClient.postData('device-token', payload);
      debugPrint('[Notifikasi] ✅ Token dikirim ke server: $resp');
    } on Exception catch (e) {
      debugPrint('[Notifikasi] 🚨 Gagal kirim token ke server: $e');
    }
  }

  /// PRIVATE: Langkah‐langkah untuk menonaktifkan FCM
  Future<void> _disableFCM_internal() async {
    try {
      debugPrint('[Notifikasi] >> Disabling FCM...');

      // 1) Matikan autoInit agar FCM tidak membuat token baru otomatis
      await _fcm.setAutoInitEnabled(false);
      debugPrint('[Notifikasi] setAutoInitEnabled(false) done.');

      // 2) Unsubscribe dari topik (jika sebelumnya subscribe)
      await _fcm.unsubscribeFromTopic('all');
      debugPrint('[Notifikasi] unsubscribeFromTopic("all") done.');

      // 3) Delete token di device
      await _fcm.deleteToken();
      debugPrint('[Notifikasi] deleteToken() done.');

      // 4) Batalkan listener onTokenRefresh jika ada
      await _tokenRefreshSubscription?.cancel();
      _tokenRefreshSubscription = null;

      // 5) Clear token lokal
      _deviceToken = null;
      notifyListeners();

    } catch (e) {
      debugPrint('[Notifikasi] ❌ Error di _disableFCM_internal(): $e');
    }
  }

  @override
  void dispose() {
    // Batalkan subscription onTokenRefresh agar tidak memanggil callback setelah dispose
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    super.dispose();
  }
}
