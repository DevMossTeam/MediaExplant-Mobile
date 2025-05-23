import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import class AuthStorage yang sudah kamu buat
import 'auth_storage.dart';

// Variable global userLogin yang menyimpan UID user
String? userLogin;

/// Fungsi untuk load UID dari SharedPreferences ke variable global
Future<void> loadUserLogin() async {
  final userData = await AuthStorage.getUserData();
  userLogin = userData['uid'];
  print('User Login UID: $userLogin');
}
