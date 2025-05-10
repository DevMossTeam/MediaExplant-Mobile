import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:mediaexplant/core/network/api_client.dart';

class WelcomeViewModel extends ChangeNotifier {
  // Controller dan state untuk onboarding
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  bool isLoading = true;
  Timer? _autoSlideTimer;

  // FCM token, sekarang dipakai via getter
  String? _deviceToken;
  String? get deviceToken => _deviceToken;

  // API client instance
  final ApiClient _apiClient = ApiClient();

  final List<Map<String, String>> pages = [
    {
      "title": "Welcome to MediaExplant",
      "description": "Your personalized portal for the latest news and trends.",
      "lottie": "assets/animations/Welcome.json"
    },
    {
      "title": "Stay Updated",
      "description": "Get the most relevant updates tailored for you.",
      "lottie": "assets/animations/Animation_1742404418041.json"
    },
    {
      "title": "Modern Experience",
      "description": "Enjoy a seamless, interactive experience at your fingertips.",
      "lottie": "assets/animations/Animation_1742404469999.json"
    },
  ];

  WelcomeViewModel() {
    _initFCM();
  }

  /// Panggil di initState (melalui post-frame callback) untuk cek SharedPreferences
  Future<void> init(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('hasSeenWelcome') ?? false;
    if (hasSeen) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
    isLoading = false;
    notifyListeners();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (pageController.hasClients) {
        final next = (currentPage + 1) % pages.length;
        pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onPageChanged(int page) {
    currentPage = page;
    notifyListeners();
    _startAutoSlide(); // reset timer saat user swipe
  }

  Future<void> onGetStarted(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);

    final status = await Permission.notification.request();
    final granted = status.isGranted;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(granted
            ? 'Notification permission granted'
            : 'Notification permission denied'),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pushReplacementNamed(context, '/home');
  }

  /// Inisialisasi FCM: izin, ambil token, kirim, dan listen untuk refresh
  Future<void> _initFCM() async {
    debugPrint('[WelcomeVM] >> Initializing FCM...');
    try {
      final messaging = FirebaseMessaging.instance;

      // 1) Request permission (iOS only matters)
      final settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true,
      );
      debugPrint('[WelcomeVM] Permission: ${settings.authorizationStatus}');

      // 2) Jika diizinkan, ambil token dan update
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await messaging.getToken();
        await _updateDeviceToken(token);
      } else {
        debugPrint('[WelcomeVM] ⚠️ Permission not granted');
      }

      // 3) Listen untuk token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen(_updateDeviceToken);
    } catch (e) {
      debugPrint('[WelcomeVM] ❌ FCM init error: $e');
    }
  }

  /// Simpan token lokal & kirim ke backend
  Future<void> _updateDeviceToken(String? token) async {
    if (token == null) return;
    _deviceToken = token;
    debugPrint('[WelcomeVM] 🎫 Device Token: $token');
    notifyListeners(); // sekarang getter deviceToken digunakan

    await _sendTokenToBackend(token);
  }

  /// Kirim token ke backend Laravel lewat ApiClient.postData
  Future<void> _sendTokenToBackend(String token) async {
    final payload = {
      'device_token': token,
      'device_type': Platform.isAndroid ? 'android' : 'ios',
    };

    try {
      final response = await _apiClient.postData(
        'device-token',
        payload,
      );
      debugPrint('[WelcomeVM] ✅ Token sent: $response');
    } on ApiException catch (e) {
      debugPrint('[WelcomeVM] 🚨 API exception: $e');
    } catch (e) {
      debugPrint('[WelcomeVM] 🚨 Error sending token: $e');
    }
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
