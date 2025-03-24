import 'package:mediaexplant/core/utils/auth_storage.dart';
import 'package:mediaexplant/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mediaexplant/features/profile/domain/entities/profile.dart';
import 'package:mediaexplant/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Profile?> getProfile() async {
    final userData = await AuthStorage.getUserData();
    final token = userData['token'];
    if (token == null || token.isEmpty) {
      return null;
    }
    return await remoteDataSource.getProfile(token: token);
  }
}
