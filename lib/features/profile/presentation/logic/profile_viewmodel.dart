import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/entities/profile.dart';

class ProfileViewModel extends ChangeNotifier {
  final GetProfile _getProfile;

  ProfileViewModel({required GetProfile getProfile})
      : _getProfile = getProfile {
    _loadUserData();
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Map<String, String?> _userData = {};
  Map<String, String> get userData => _userData.map(
        (key, value) => MapEntry(key, value ?? ''),
      );

  String get fullName {
    final nl = userData['nama_lengkap'];
    final np = userData['nama_pengguna'];
    if (nl != null && nl.isNotEmpty) return nl;
    if (np != null && np.isNotEmpty) return np;
    return 'User';
  }

  String get profilePic {
    final pic = userData['profile_pic'];
    return (pic != null && pic.isNotEmpty)
        ? pic
        : 'https://via.placeholder.com/150';
  }

  Future<void> _loadUserData() async {
    try {
      _userData = await AuthStorage.getUserData();
      debugPrint("Loaded local user data: $_userData");
      final token = _userData['token'];
      _isLoggedIn = token != null && token.isNotEmpty;
    } catch (e, st) {
      debugPrint("Error loading local user data: $e\n$st");
      _userData = {};
      _isLoggedIn = false;
    }

    // Jika user sudah login tapi data belum lengkap, fetch remote.
    if (_isLoggedIn &&
        (_userData['nama_lengkap'] == null ||
            _userData['nama_lengkap']!.isEmpty ||
            _userData['profile_pic'] == null ||
            _userData['profile_pic']!.isEmpty)) {
      try {
        final Profile? remoteProfile = await _getProfile();
        if (remoteProfile != null) {
          await AuthStorage.saveUserData(
            token: _userData['token']!,
            uid: _userData['uid'] ?? '',
            namaPengguna: _userData['nama_pengguna'] ?? '',
            email: _userData['email'] ?? '',
            profilePic: remoteProfile.profilePic,
            role: _userData['role'] ?? '',
            namaLengkap: remoteProfile.fullName,
          );
          _userData = await AuthStorage.getUserData();
          debugPrint("Loaded user data after remote fetch: $_userData");
        }
      } catch (e, st) {
        debugPrint("Error fetching remote profile: $e\n$st");
      }
    }

    notifyListeners();
  }

  Future<void> refreshUserData() async {
    await _loadUserData();
  }
}
