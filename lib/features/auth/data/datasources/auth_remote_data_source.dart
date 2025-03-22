import 'package:mediaexplant/core/network/api_client.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<Map<String, dynamic>> signIn({required String email, required String password}) async {
    final response = await apiClient.postData('login', {
      'email': email,
      'password': password,
    });
    // Asumsikan apiClient.postData mengembalikan Map<String, dynamic>
    return response;
  }

  Future<Map<String, dynamic>> signUp({required String username, required String email, required String password}) async {
    final response = await apiClient.postData('register', {
      'username': username,
      'email': email,
      'password': password,
    });
    return response;
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    final response = await apiClient.postData('forgot-password', {
      'email': email,
    });
    return response;
  }
}
