import '../entities/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> signIn({required String email, required String password});
  Future<AuthResponse> signUp({required String username, required String email, required String password});
  Future<void> forgotPassword({required String email});
}