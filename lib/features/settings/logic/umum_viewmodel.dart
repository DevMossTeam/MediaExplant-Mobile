import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';

class UmumViewModel extends ChangeNotifier {
  final ApiClient _apiClient;

  UmumViewModel({ required ApiClient apiClient })
    : _apiClient = apiClient {
    loadUserData();
  }

  // —————————————————————
  // Data user + originalUsername
  // —————————————————————
  late String _originalUsername;    // simpan username awal
  String     _username    = "";
  String     _namaLengkap = "";
  String     _role        = "";
  String     _profilePic  = "";

  bool _isLoading = true;

  // —————————————————————
  // State validasi username
  // —————————————————————
  bool   _isCheckingUsername   = false;
  bool   _isUsernameAvailable  = false;
  String _usernameErrorMessage = "";

  Timer? _debounceTimer;

  // —————————————————————
  // Getters publik
  // —————————————————————
  String get username            => _username;
  String get namaLengkap         => _namaLengkap;
  String get role                => _role;
  String get profilePic          => _profilePic;
  bool   get isLoading           => _isLoading;

  bool   get isCheckingUsername  => _isCheckingUsername;
  bool   get isUsernameAvailable => _isUsernameAvailable;
  String get usernameError       => _usernameErrorMessage;

  /// Tombol Simpan aktif jika:
  /// 1) tidak loading global
  /// 2) tidak ada error
  bool get canSave =>
      !_isLoading && _usernameErrorMessage.isEmpty;

  // —————————————————————
  // Load data & reset state
  // —————————————————————
  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await AuthStorage.getUserData();
      _originalUsername       = data['nama_pengguna'] ?? "";
      _username               = _originalUsername;
      _namaLengkap            = data['nama_lengkap']  ?? "";
      _role                   = data['role']         ?? "";
      _profilePic             = data['profile_pic']  ?? "";

      // Reset validasi (username awal dianggap tersedia)
      _isUsernameAvailable    = true;
      _usernameErrorMessage   = "";
    } catch (_) {
      _originalUsername = _username = "";
      _namaLengkap = _role = _profilePic = "";
      _isUsernameAvailable  = false;
      _usernameErrorMessage = "";
    }

    _isLoading = false;
    notifyListeners();
  }

  // —————————————————————
  // Debounce + cek username
  // —————————————————————
  void onUsernameChanged(String raw) {
    final value = raw.trim();
    _username             = value;
    _usernameErrorMessage = "";
    _isUsernameAvailable  = false;
    _debounceTimer?.cancel();

    // 1) jika kosong → langsung error
    if (value.isEmpty) {
      _usernameErrorMessage = "Username tidak boleh kosong.";
      notifyListeners();
      return;
    }

    // 2) jika sama dengan original → skip server, valid
    if (value == _originalUsername) {
      _isUsernameAvailable  = true;
      _usernameErrorMessage = "";
      notifyListeners();
      return;
    }

    // 3) debounce cek ke server setelah 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _checkUsername(value);
    });

    notifyListeners();
  }

 Future<void> _checkUsername(String username) async {
  if (username.isEmpty) {
    _usernameErrorMessage = "Username tidak boleh kosong.";
    _isUsernameAvailable = false;
    notifyListeners();
    return;
  }

  // Kalau sama dengan username awal, anggap available
  if (username == _originalUsername) {
    _isUsernameAvailable = true;
    _usernameErrorMessage = "";
    notifyListeners();
    return;
  }

  _isCheckingUsername = true;
  notifyListeners();

  try {
    final current = await AuthStorage.getUserData();
    final token = current['token'] as String? ?? "";
    final available = await _apiClient.checkUsernameAvailability(
      token: token,
      username: username,
    );

    if (available) {
      _isUsernameAvailable = true;
      _usernameErrorMessage = "";
    } else {
      _isUsernameAvailable = false;
      _usernameErrorMessage = "Username sudah dipakai.";
    }
  } catch (e) {
    _isUsernameAvailable = false;
    _usernameErrorMessage = "Gagal mengecek username.";
  } finally {
    _isCheckingUsername = false;
    notifyListeners();
  }
}


  // —————————————————————
  // Update profile teks
  // —————————————————————
  Future<void> updateUserData({
    String? username,
    String? namaLengkap,
  }) async {
    if (!canSave) return;

    final current = await AuthStorage.getUserData();
    final token   = current['token'] as String? ?? "";

    final payload = <String, dynamic>{
      if (username    != null) 'nama_pengguna': username.trim(),
      if (namaLengkap != null) 'nama_lengkap' : namaLengkap.trim(),
    };

    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _apiClient.updateProfile(
        payload,
        token: token,
      );

      // Sync kembali ke local storage
      await AuthStorage.saveUserData(
        token:        token,
        uid:          updated['user']['uid']           ?? current['uid'],
        namaPengguna: updated['user']['nama_pengguna'] ?? username  ?? current['nama_pengguna'],
        namaLengkap:  updated['user']['nama_lengkap']  ?? namaLengkap ?? current['nama_lengkap'],
        email:        updated['user']['email']         ?? current['email'],
        profilePic:   updated['user']['profile_pic']   ?? current['profile_pic'],
        role:         updated['user']['role']          ?? current['role'],
      );

      // Reload & reset originalUsername
      await loadUserData();

    } catch (e) {
      debugPrint("Error updateUserData: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // —————————————————————
  // Hapus foto profil
  // —————————————————————
  Future<void> deleteProfileImage() async {
    final current = await AuthStorage.getUserData();
    final token   = current['token'] as String? ?? "";

    try {
      final updated = await _apiClient.deleteProfileImage(token: token);

      await AuthStorage.saveUserData(
        token:        token,
        uid:          updated['user']['uid']           ?? current['uid'],
        namaPengguna: updated['user']['nama_pengguna'] ?? current['nama_pengguna'],
        namaLengkap:  updated['user']['nama_lengkap']  ?? current['nama_lengkap'],
        email:        updated['user']['email']         ?? current['email'],
        profilePic:   "", // clear
        role:         updated['user']['role']          ?? current['role'],
      );

      await loadUserData();
    } catch (e) {
      debugPrint("Error deleteProfileImage: $e");
    }
  }

  // —————————————————————
  // Upload foto profil
  // —————————————————————
  Future<void> updateProfileImage(File imageFile) async {
    final current = await AuthStorage.getUserData();
    final token   = current['token'] as String? ?? "";

    try {
      final updated = await _apiClient.uploadProfileImage(
        token:     token,
        imageFile: imageFile,
      );

      await AuthStorage.saveUserData(
        token:        token,
        uid:          updated['user']['uid']           ?? current['uid'],
        namaPengguna: updated['user']['nama_pengguna'] ?? current['nama_pengguna'],
        namaLengkap:  updated['user']['nama_lengkap']  ?? current['nama_lengkap'],
        email:        updated['user']['email']         ?? current['email'],
        profilePic:   updated['user']['profile_pic']   ?? current['profile_pic'],
        role:         updated['user']['role']          ?? current['role'],
      );

      await loadUserData();
    } catch (e) {
      debugPrint("Error updateProfileImage: $e");
    }
  }
}
