import 'package:mediaexplant/features/profile/domain/entities/profile.dart';
import 'package:mediaexplant/features/profile/domain/repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<Profile?> call() async {
    return await repository.getProfile();
  }
}