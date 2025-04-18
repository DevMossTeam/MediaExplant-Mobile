import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

class UmumViewModel extends ChangeNotifier {
  final ApiClient _apiClient;
  UmumViewModel({required ApiClient apiClient}) : _apiClient = apiClient {
    loadUserData();
  }

  String _username = "";
  String _namaLengkap = "";
  String _role = "";
  String _profilePic = "";
  bool _isLoading = true;

  String get username => _username;
  String get namaLengkap => _namaLengkap;
  String get role => _role;
  String get profilePic => _profilePic;
  bool get isLoading => _isLoading;

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await AuthStorage.getUserData();
      _username = data['nama_pengguna'] ?? "";
      _namaLengkap = data['nama_lengkap'] ?? "";
      _role = data['role'] ?? "";
      _profilePic = data['profile_pic'] ?? "";
    } catch (_) {
      _username = _namaLengkap = _role = _profilePic = "";
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Kirim POST ke /api/profile/update
  Future<void> updateUserData({String? username, String? namaLengkap}) async {
    final current = await AuthStorage.getUserData();
    final token = current['token'] as String? ?? "";
    final payload = {
      if (username != null) 'nama_pengguna': username,
      if (namaLengkap != null) 'nama_lengkap': namaLengkap,
    };
    try {
      final updated = await _apiClient.updateProfile(
        payload,
        headers: { "Authorization": "Bearer $token" },
      );
      await AuthStorage.saveUserData(
        token: token,
        uid: updated['user']['uid'] ?? current['uid'],
        namaPengguna: updated['user']['nama_pengguna'] ?? username ?? current['nama_pengguna'],
        namaLengkap: updated['user']['nama_lengkap'] ?? namaLengkap ?? current['nama_lengkap'],
        email: updated['user']['email'] ?? current['email'],
        profilePic: updated['user']['profile_pic'] ?? current['profile_pic'],
        role: updated['user']['role'] ?? current['role'],
      );
      await loadUserData();
    } catch (e) {
      debugPrint("Error updateUserData: $e");
    }
  }
  
  Future<void> deleteProfileImage() async {
  final current = await AuthStorage.getUserData();
  final token = current['token'] as String? ?? "";
  try {
    final updated = await _apiClient.deleteProfileImage(
      token: token,
      uid: current['uid'] as String,
    );
    await AuthStorage.saveUserData(
      token: token,
      uid: updated['user']['uid'] ?? current['uid'],
      namaPengguna: updated['user']['nama_pengguna'] ?? current['nama_pengguna'],
      namaLengkap: updated['user']['nama_lengkap'] ?? current['nama_lengkap'],
      email: updated['user']['email'] ?? current['email'],
      profilePic: "", // Kosongkan profilePic setelah dihapus
      role: updated['user']['role'] ?? current['role'],
    );
    await loadUserData();
  } catch (e) {
    debugPrint("Error deleteProfileImage: $e");
  }
}

  Future<void> updateProfileImage(File imageFile) async {
    final current = await AuthStorage.getUserData();
    final token = current['token'] as String? ?? "";
    try {
      final updated = await _apiClient.uploadProfileImage(
        token: token,
        uid: current['uid'] as String,
        imageFile: imageFile,
      );
      await AuthStorage.saveUserData(
        token: token,
        uid: updated['user']['uid'] ?? current['uid'],
        namaPengguna: updated['user']['nama_pengguna'] ?? current['nama_pengguna'],
        namaLengkap: updated['user']['nama_lengkap'] ?? current['nama_lengkap'],
        email: updated['user']['email'] ?? current['email'],
        profilePic: updated['user']['profile_pic'] ?? current['profile_pic'],
        role: updated['user']['role'] ?? current['role'],
      );
      await loadUserData();
    } catch (e) {
      debugPrint("Error updateProfileImage: $e");
    }
  }
}