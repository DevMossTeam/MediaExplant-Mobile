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

  /// NEW: menandai apakah sedang proses ON/OFF FCM
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  String? _deviceToken;
  String? get deviceToken => _deviceToken;

  StreamSubscription<String>? _tokenRefreshSubscription;

  SettingNotifikasiViewModel() {
    _initPreferencesAndFCM();
  }

  Future<void> _initPreferencesAndFCM() async {
    final prefs = await SharedPreferences.getInstance();
    _pushNotifications = prefs.getBool('pushNotifications') ?? true;
    debugPrint('[Notifikasi] loadPreferences: $_pushNotifications');

    // Cek status izin notifikasi (tanpa prompt)
    PermissionStatus status = await Permission.notification.status;
    debugPrint('[Notifikasi] current Permission status: $status');

    if (_pushNotifications) {
      if (status != PermissionStatus.granted) {
        // Pref ON tetapi izin belum granted → paksa OFF
        debugPrint(
            '[Notifikasi] Pref=ON tapi permission belum granted. Memaksa OFF.');
        _pushNotifications = false;
        await prefs.setBool('pushNotifications', false);
        await _disableFCM_internal();
      } else {
        await _enableFCM_internal();
      }
    } else {
      await _disableFCM_internal();
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// Perubahan: menerima `BuildContext` untuk menampilkan Snackbar
  Future<void> updatePushNotifications(BuildContext context, bool value) async {
    debugPrint('[Notifikasi] updatePushNotifications: $value');

    // Tunjukkan loading spinner di UI
    _isProcessing = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    try {
      if (value) {
        // 1) Cek status izin saat ini (tanpa prompt)
        PermissionStatus status = await Permission.notification.status;
        debugPrint('[Notifikasi] cek Permission saat toggle: $status');

        // 2) Selalu request permission kembali
        PermissionStatus newStatus = await Permission.notification.request();
        debugPrint('[Notifikasi] hasil requestPermission(): $newStatus');

        if (newStatus == PermissionStatus.permanentlyDenied) {
          // Jika sudah permanentlyDenied:
          // Tampilkan Snackbar dulu, beri delay 3 detik, lalu buka Settings aplikasi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Anda diminta untuk mengaktifkan notifikasi di pengaturan aplikasi. '
                'Mengalihkan dalam 3 detik',
              ),
              duration: Duration(seconds: 3),
            ),
          );

          // Delay 3 detik agar pengguna sempat membaca Snackbar
          await Future.delayed(Duration(seconds: 3));

          // Buka halaman Settings aplikasi
          await openAppSettings();

          // Rollback ke OFF
          _pushNotifications = false;
          await prefs.setBool('pushNotifications', false);
          notifyListeners();
          return;
        }

        if (newStatus != PermissionStatus.granted) {
          debugPrint('[Notifikasi] User menolak izin. Toggle tetap OFF.');
          // Rollback ke OFF
          _pushNotifications = false;
          await prefs.setBool('pushNotifications', false);
          notifyListeners();
          return;
        }

        // 3) Jika izin granted, lanjut enable FCM
        await _enableFCM_internal();
      } else {
        // User mematikan toggle → disable FCM
        await _disableFCM_internal();
      }

      // 4) Simpan state baru ke SharedPreferences
      _pushNotifications = value;
      await prefs.setBool('pushNotifications', value);
      debugPrint('[Notifikasi] SharedPreferences updated: $_pushNotifications');

      notifyListeners();
    } catch (e) {
      debugPrint('[Notifikasi] ❌ Error di updatePushNotifications: $e');
      // Bila perlu, tampilkan Snackbar/Toast error di sini
    } finally {
      // Hentikan loading spinner
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> _enableFCM_internal() async {
    try {
      debugPrint('[Notifikasi] >> Enabling FCM...');

      await _fcm.setAutoInitEnabled(true);
      debugPrint('[Notifikasi] setAutoInitEnabled(true) done.');

      final token = await _fcm.getToken();
      if (token != null) {
        await _updateDeviceToken(token);
      } else {
        debugPrint('[Notifikasi] getToken() returned null.');
      }

      await _tokenRefreshSubscription?.cancel();
      _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh.listen(
        (newToken) async {
          debugPrint('[Notifikasi] onTokenRefresh: $newToken');
          await _updateDeviceToken(newToken);
        },
      );

      await _fcm.subscribeToTopic('all');
      debugPrint('[Notifikasi] subscribeToTopic("all") sukses.');
    } catch (e) {
      debugPrint('[Notifikasi] ❌ Error di _enableFCM_internal(): $e');
    }
  }

  Future<void> _updateDeviceToken(String token) async {
    _deviceToken = token;
    debugPrint('[Notifikasi] 🎫 Got FCM Device Token: $token');
    notifyListeners();

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

  Future<void> _disableFCM_internal() async {
    try {
      debugPrint('[Notifikasi] >> Disabling FCM...');

      await _fcm.setAutoInitEnabled(false);
      debugPrint('[Notifikasi] setAutoInitEnabled(false) done.');

      await _fcm.unsubscribeFromTopic('all');
      debugPrint('[Notifikasi] unsubscribeFromTopic("all") done.');

      await _fcm.deleteToken();
      debugPrint('[Notifikasi] deleteToken() done.');

      await _tokenRefreshSubscription?.cancel();
      _tokenRefreshSubscription = null;

      _deviceToken = null;
      notifyListeners();
    } catch (e) {
      debugPrint('[Notifikasi] ❌ Error di _disableFCM_internal(): $e');
    }
  }

  @override
  void dispose() {
    _tokenRefreshSubscription?.cancel();
    super.dispose();
  }
}
