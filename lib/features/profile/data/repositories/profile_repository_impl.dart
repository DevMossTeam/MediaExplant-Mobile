import 'package:mediaexplant/core/utils/auth_storage.dart';
import 'package:mediaexplant/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mediaexplant/features/profile/data/models/profile_model.dart';
import 'package:mediaexplant/features/profile/domain/entities/profile.dart';
import 'package:mediaexplant/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Profile?> getProfile() async {
    // Ambil data lokal dari AuthStorage
    final localData = await AuthStorage.getUserData();

    // Jika data lokal sudah ada (minimal nama_lengkap dan profile_pic valid), gunakan sebagai fallback
    if (localData.isNotEmpty &&
        (localData['nama_lengkap']?.isNotEmpty ?? false) &&
        (localData['profile_pic']?.isNotEmpty ?? false)) {
      // Data lokal sudah tersedia, kembalikan data lokal tanpa pemanggilan API
      return ProfileModel.fromJson(localData);
    }

    // Ambil token dari data lokal (jika ada)
    final token = localData['token'];
    if (token == null || token.isEmpty) {
      // Jika token tidak ada, kembalikan null
      return null;
    }

    try {
      // Ambil data remote menggunakan token
      final remoteProfile = await remoteDataSource.getProfile(token: token);
      if (remoteProfile != null) {
        // Simpan data remote ke AuthStorage untuk future load instan
        // Pastikan field lainnya seperti uid, nama_pengguna, email, role sudah tersedia dari data lokal
        await AuthStorage.saveUserData(
          token: token,
          uid: localData['uid'] ?? "",
          namaPengguna: localData['nama_pengguna'] ?? "",
          email: localData['email'] ?? "",
          profilePic: remoteProfile.profilePic,
          role: localData['role'] ?? "",
          namaLengkap: remoteProfile.fullName,
        );
        return remoteProfile;
      }
    } catch (e) {
      // Jika terjadi error saat memanggil API, kembalikan data lokal jika tersedia
      if (localData.isNotEmpty) {
        return ProfileModel.fromJson(localData);
      }
    }
    return null;
  }
}