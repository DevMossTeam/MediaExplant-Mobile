import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/entities/profile.dart';

class ProfileViewModel extends ChangeNotifier {
  final GetProfile _getProfile;

  ProfileViewModel({required GetProfile getProfile})
      : _getProfile = getProfile {
    _loadUserData(); // langsung load data lokal + remote
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Map<String, String?> _userData = {};
  Map<String, String> get userData =>
      _userData.map((k, v) => MapEntry(k, v ?? ''));

  /// Nama tampilan lengkap atau username fallback
  String get fullName {
    final nl = _userData['nama_lengkap'];
    final np = _userData['nama_pengguna'];
    if (nl != null && nl.trim().isNotEmpty) return nl;
    if (np != null && np.trim().isNotEmpty) return np;
    return 'User';
  }

  /// Isi kolom profile_pic (bisa Base64 Data URI atau URL string), atau "".
  String get profilePic => _userData['profile_pic']?.trim() ?? '';

  /// Jika ada foto (Base64 atau URL), kembalikan MemoryImage/NetworkImage.
  /// Kalau tidak ada, kembalikan null → UI nanti men‐draw huruf+kombinasi warna sendiri.
  ImageProvider? get profileImageProvider {
    final pic = profilePic;
    if (pic.isEmpty) {
      // Tidak ada foto: return null
      return null;
    }
    // Deteksi Data URI Base64
    final dataUri = RegExp(r'^data:image\/[a-zA-Z]+;base64,');
    if (dataUri.hasMatch(pic)) {
      final raw = pic.replaceFirst(dataUri, '');
      final bytes = base64Decode(raw);
      return MemoryImage(bytes);
    }
    // Jika bukan Base64 → asumsikan URL
    return CachedNetworkImageProvider(pic);
  }

  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1) Tampilkan data lokal langsung
      _userData = await AuthStorage.getUserData();
      final token = _userData['token'] ?? '';
      _isLoggedIn = token.isNotEmpty;
      notifyListeners();

      // 2) Jika user login, fetch remote & sync
      if (_isLoggedIn) {
        await _fetchAndSyncRemoteProfile(token);
      }
    } catch (e, st) {
      debugPrint('Error loading user data: $e\n$st');
      _userData = {};
      _isLoggedIn = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchAndSyncRemoteProfile(String token) async {
    try {
      final Profile? remote = await _getProfile();
      if (remote == null) return;

      final hasChanged =
          remote.fullName != (_userData['nama_lengkap'] ?? '') ||
          remote.profilePic != (_userData['profile_pic'] ?? '');

      if (hasChanged) {
        // Overwrite local storage dengan data terbaru
        await AuthStorage.saveUserData(
          token:        token,
          uid:          _userData['uid'] ?? '',
          namaPengguna: _userData['nama_pengguna'] ?? '',
          email:        _userData['email'] ?? '',
          profilePic:   remote.profilePic,
          role:         _userData['role'] ?? '',
          namaLengkap:  remote.fullName,
        );
        // Reload ke memory
        _userData = await AuthStorage.getUserData();
        debugPrint('ProfileViewModel: Remote data synced.');
        notifyListeners();
      } else {
        debugPrint('ProfileViewModel: No changes detected.');
      }
    } catch (e, st) {
      debugPrint('Error fetching remote profile: $e\n$st');
      // Tidak mengubah isLoggedIn – cukup log saja
    }
  }

  /// Untuk pull‐to‐refresh di UI
  Future<void> refreshUserData() async {
    if (!_isLoggedIn) return;

    _isLoading = true;
    notifyListeners();

    final token = _userData['token'] ?? '';
    if (token.isNotEmpty) {
      await _fetchAndSyncRemoteProfile(token);
    }

    _isLoading = false;
    notifyListeners();
  }
}
