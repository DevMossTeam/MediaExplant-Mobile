import 'package:mediaexplant/core/network/api_client.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<Map<String, dynamic>> signIn({required String email, required String password}) async {
    final response = await apiClient.postData('login', {
      'email': email,
      'password': password,
    });
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

  Future<Map<String, dynamic>> registerStep1({required String namaLengkap, required String namaPengguna, required String email}) async {
    final response = await apiClient.postData('register-step1', {
      'nama_lengkap': namaLengkap,
      'nama_pengguna': namaPengguna,
      'email': email,
    });
    return response;
  }

  Future<Map<String, dynamic>> verifyOtp({required String email, required String otp}) async {
    final response = await apiClient.postData('verify-otp', {
      'email': email,
      'otp': otp,
    });
    return response;
  }

  Future<Map<String, dynamic>> registerStep3({required String email, required String password, required String password_confirmation}) async {
    final response = await apiClient.postData('register-step3', {
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation,
    });
    return response;
  }
}