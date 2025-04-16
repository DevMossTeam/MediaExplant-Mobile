import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

class UmumViewModel extends ChangeNotifier {
  final ApiClient _apiClient;

  UmumViewModel({required ApiClient apiClient})
      : _apiClient = apiClient {
    // Load data user saat inisialisasi
    loadUserData();
  }

  // Variabel private untuk menyimpan data profil
  String _username = "";
  String _namaLengkap = "";
  String _role = "";
  String _profilePic = "";
  bool _isLoading = true;

  // Getter publik
  String get username => _username;
  String get namaLengkap => _namaLengkap;
  String get role => _role;
  String get profilePic => _profilePic;
  bool get isLoading => _isLoading;

  /// Muat data user dari AuthStorage.
  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await AuthStorage.getUserData();
      _username = data['nama_pengguna'] ?? "";
      _namaLengkap = data['nama_lengkap'] ?? "";
      _role = data['role'] ?? "";
      _profilePic = data['profile_pic'] ?? "";
      debugPrint("UmumViewModel loaded data: $data");
    } catch (e, st) {
      debugPrint("Error loading user data: $e\n$st");
      _username = "";
      _namaLengkap = "";
      _role = "";
      _profilePic = "";
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Update profil (username dan nama lengkap) ke backend dan simpan hasilnya ke AuthStorage.
  Future<void> updateUserData({String? username, String? namaLengkap}) async {
    try {
      // Ambil data profil saat ini dari AuthStorage
      final currentData = await AuthStorage.getUserData();
      // Panggil API update profile – kirim token melalui header, bukan di payload.
      final updatedData = await _apiClient.updateProfile({
        'nama_pengguna': username ?? currentData['nama_pengguna'] ?? "",
        'nama_lengkap': namaLengkap ?? currentData['nama_lengkap'] ?? "",
      }, headers: {
        "Authorization": "Bearer ${currentData['token'] ?? ""}"
      });
      // Simpan data yang diperbarui ke AuthStorage
      await AuthStorage.saveUserData(
        token: updatedData['token'] ?? currentData['token'] ?? "",
        uid: updatedData['uid'] ?? currentData['uid'] ?? "",
        namaPengguna: updatedData['nama_pengguna'] ?? username ?? currentData['nama_pengguna'] ?? "",
        email: updatedData['email'] ?? currentData['email'] ?? "",
        profilePic: updatedData['profile_pic'] ?? currentData['profile_pic'] ?? "",
        role: updatedData['role'] ?? currentData['role'] ?? "",
        namaLengkap: updatedData['nama_lengkap'] ?? namaLengkap ?? currentData['nama_lengkap'] ?? "",
      );
      await loadUserData();
    } catch (e, st) {
      debugPrint("Error updating profile: $e\n$st");
      // Anda bisa menampilkan pesan error di UI jika diperlukan.
    }
  }

  /// Update foto profil melalui API.
  /// Pastikan metode uploadProfileImage di ApiClient sudah diimplementasikan!
  Future<void> updateProfileImage(File imageFile) async {
    try {
      final currentData = await AuthStorage.getUserData();
      final updatedData = await _apiClient.uploadProfileImage(
        token: currentData['token'] ?? "",
        uid: currentData['uid'] ?? "",
        imageFile: imageFile,
      );
      await AuthStorage.saveUserData(
        token: updatedData['token'] ?? currentData['token'] ?? "",
        uid: updatedData['uid'] ?? currentData['uid'] ?? "",
        namaPengguna: updatedData['nama_pengguna'] ?? currentData['nama_pengguna'] ?? "",
        email: updatedData['email'] ?? currentData['email'] ?? "",
        profilePic: updatedData['profile_pic'] ?? "",
        role: updatedData['role'] ?? currentData['role'] ?? "",
        namaLengkap: updatedData['nama_lengkap'] ?? currentData['nama_lengkap'] ?? "",
      );
      await loadUserData();
    } catch (e, st) {
      debugPrint("Error updating profile image: $e\n$st");
    }
  }
}
