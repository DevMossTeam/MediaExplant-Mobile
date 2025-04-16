import 'package:flutter/foundation.dart';  // Untuk debugPrint
import 'package:mediaexplant/features/profile/domain/entities/profile.dart';
import 'package:mediaexplant/features/profile/domain/repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<Profile?> call() async {
    try {
      return await repository.getProfile();
    } catch (e, st) {
      debugPrint("GetProfile Error: $e\n$st");
      return null;
    }
  }
}