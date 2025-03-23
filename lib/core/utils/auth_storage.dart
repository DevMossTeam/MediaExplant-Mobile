import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  // Key yang digunakan untuk menyimpan data
  static const _keyToken = 'token';
  static const _keyUID = 'uid';
  static const _keyUsername = 'nama_pengguna';
  static const _keyEmail = 'email';
  static const _keyProfilePic = 'profile_pic';
  static const _keyRole = 'role';
  static const _keyFullName = 'nama_lengkap';

  /// Menyimpan data pengguna ke Shared Preferences.
  /// Data yang disimpan: token, uid, nama pengguna, email, profile_pic (opsional), role, dan nama lengkap.
  static Future<void> saveUserData({
    required String token,
    required String uid,
    required String namaPengguna,
    required String email,
    String? profilePic,
    required String role,
    required String namaLengkap,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUID, uid);
    await prefs.setString(_keyUsername, namaPengguna);
    await prefs.setString(_keyEmail, email);
    if (profilePic != null && profilePic.isNotEmpty) {
      await prefs.setString(_keyProfilePic, profilePic);
    } else {
      await prefs.remove(_keyProfilePic);
    }
    await prefs.setString(_keyRole, role);
    await prefs.setString(_keyFullName, namaLengkap);
  }

  /// Mengambil data pengguna yang tersimpan.
  /// Mengembalikan Map dengan key: token, uid, nama_pengguna, email, profile_pic, role, dan nama_lengkap.
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(_keyToken),
      'uid': prefs.getString(_keyUID),
      'nama_pengguna': prefs.getString(_keyUsername),
      'email': prefs.getString(_keyEmail),
      'profile_pic': prefs.getString(_keyProfilePic),
      'role': prefs.getString(_keyRole),
      'nama_lengkap': prefs.getString(_keyFullName),
    };
  }

  /// Menghapus semua data pengguna dari Shared Preferences.
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUID);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyProfilePic);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyFullName);
  }
}