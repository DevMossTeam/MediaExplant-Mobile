import 'package:mediaexplant/core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<User> signIn({required String email, required String password}) async {
    final response = await apiClient.postData('login', {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response);
  }

  Future<User> signUp({required String username, required String email, required String password}) async {
    final response = await apiClient.postData('register', {
      'username': username,
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response);
  }

  Future<void> forgotPassword({required String email}) async {
    await apiClient.postData('forgot-password', {
      'email': email,
    });
  }
}