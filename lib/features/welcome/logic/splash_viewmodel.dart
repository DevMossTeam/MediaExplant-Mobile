import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  /// Fungsi untuk menavigasi dari splash screen ke welcome screen.
  void navigateToWelcome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/welcome');
  }
}