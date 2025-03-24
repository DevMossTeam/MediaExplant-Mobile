import 'package:mediaexplant/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile?> getProfile();
}
