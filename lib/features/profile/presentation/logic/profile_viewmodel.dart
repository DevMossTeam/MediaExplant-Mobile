import 'package:flutter/material.dart';
import 'package:mediaexplant/features/profile/domain/entities/profile.dart';
import 'package:mediaexplant/features/profile/domain/usecases/get_profile.dart';
import 'package:mediaexplant/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mediaexplant/features/profile/data/repositories/profile_repository_impl.dart';

/// ViewModel untuk profil pengguna.
/// Mengambil data profil melalui use case yang mengakses data dari API (dengan bantuan AuthStorage).
class ProfileViewModel extends ChangeNotifier {
  Profile? _profile;
  Profile? get profile => _profile;

  /// Status login, true jika data profil tersedia.
  bool get isLoggedIn => _profile != null;

  final GetProfile _getProfile;

  ProfileViewModel()
      : _getProfile = GetProfile(
          ProfileRepositoryImpl(
            remoteDataSource: ProfileRemoteDataSource(),
          ),
        ) {
    // Memuat data profil saat inisialisasi
    loadProfile();
  }

  /// Memuat data profil pengguna.
  Future<void> loadProfile() async {
    try {
      _profile = await _getProfile();
    } catch (e) {
      // Tangani error jika terjadi kegagalan pengambilan data
      _profile = null;
    }
    notifyListeners();
  }

  /// Menyegarkan data profil pengguna.
  Future<void> refreshProfile() async {
    await loadProfile();
  }

  /// Getter convenience untuk nama lengkap.
  String get fullName => _profile?.fullName ?? 'User';

  /// Getter convenience untuk URL foto profil.
  String get profilePic =>
      _profile?.profilePic ?? 'https://via.placeholder.com/150';
}