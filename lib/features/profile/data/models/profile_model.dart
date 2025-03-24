import 'package:mediaexplant/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({required String fullName, required String profilePic})
      : super(fullName: fullName, profilePic: profilePic);

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['nama_lengkap'] ?? 'User',
      profilePic: json['profile_pic'] ?? 'https://via.placeholder.com/150',
    );
  }
}
