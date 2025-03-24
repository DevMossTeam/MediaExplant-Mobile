import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/profile/data/models/profile_model.dart';

class ProfileRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  /// Mengambil data profil dari API.
  /// Pastikan untuk mengirimkan token yang valid pada header Authorization.
  Future<ProfileModel?> getProfile({required String token}) async {
    try {
      final headers = {
        "Authorization": "Bearer $token",
      };

      final response = await _apiClient.getData("profile", headers: headers);
      
      // Pastikan response sukses dan terdapat field 'user'
      if (response != null && response["success"] == true && response["user"] != null) {
        final userData = response["user"];
        return ProfileModel.fromJson(userData);
      }
    } catch (e) {
      // Tangani error atau logging jika diperlukan
      throw Exception("Gagal mengambil data profil: $e");
    }

    return null;
  }
}