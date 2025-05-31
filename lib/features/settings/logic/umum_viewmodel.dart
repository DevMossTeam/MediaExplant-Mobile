import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  String     _profilePic  = "";     // raw Data URI / URL

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

  /// Raw string Data URI Base64 atau URL
  String get profilePic          => _profilePic;

  bool   get isLoading           => _isLoading;
  bool   get isCheckingUsername  => _isCheckingUsername;
  bool   get isUsernameAvailable => _isUsernameAvailable;
  String get usernameError       => _usernameErrorMessage;

  bool get canSave =>
      !_isLoading && _usernameErrorMessage.isEmpty;

  // —————————————————————
  // ImageProvider untuk foto profil (nullable)
  // —————————————————————
  ImageProvider? get profileImageProvider {
    final pic = _profilePic.trim();
    if (pic.isEmpty) {
      // Tidak ada foto → kembalikan null
      return null;
    }

    // Jika Data URI Base64 (misalnya "data:image/png;base64,...")
    final dataUri = RegExp(r'^data:image\/[a-zA-Z]+;base64,');
    if (dataUri.hasMatch(pic)) {
      final raw = pic.replaceFirst(dataUri, '');
      final bytes = base64Decode(raw);
      return MemoryImage(bytes);
    }

    // Bukan Base64 → asumsikan URL jaringan
    return CachedNetworkImageProvider(pic);
  }

  // —————————————————————
  // Load data & reset state
  // —————————————————————
  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await AuthStorage.getUserData();
      _originalUsername     = data['nama_pengguna'] ?? "";
      _username             = _originalUsername;
      _namaLengkap          = data['nama_lengkap']  ?? "";
      _role                 = data['role']         ?? "";
      _profilePic           = data['profile_pic']  ?? "";

      _isUsernameAvailable  = true;
      _usernameErrorMessage = "";
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

    if (value.isEmpty) {
      _usernameErrorMessage = "Username tidak boleh kosong.";
      notifyListeners();
      return;
    }
    if (value == _originalUsername) {
      _isUsernameAvailable  = true;
      _usernameErrorMessage = "";
      notifyListeners();
      return;
    }
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
    if (username == _originalUsername) {
      _isUsernameAvailable = true;
      _usernameErrorMessage = "";
      notifyListeners();
      return;
    }

    _isCheckingUsername = true;
    notifyListeners();

    try {
      final current  = await AuthStorage.getUserData();
      final token    = current['token'] as String? ?? "";
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

      // Sync ke AuthStorage
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
  // Upload foto profil (file → Base64)
  // —————————————————————
  Future<void> updateProfileImage(File imageFile) async {
    final current = await AuthStorage.getUserData();
    final token   = current['token'] as String? ?? "";

    try {
      final updated = await _apiClient.uploadProfileImage(
        token:     token,
        imageFile: imageFile,
      );

      // Simpan Data URI (API mengembalikan data URI Base64)
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
