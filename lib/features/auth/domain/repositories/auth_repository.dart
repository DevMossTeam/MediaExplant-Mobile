import '../entities/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> signIn({required String email, required String password});
  Future<AuthResponse> signUp({required String username, required String email, required String password});
  Future<void> forgotPassword({required String email});

  // Tambahan untuk pendaftaran multi-step
  Future<Map<String, dynamic>> registerStep1({
    required String namaLengkap,
    required String namaPengguna,
    required String email,
  });
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  });
  Future<AuthResponse> registerStep3({
    required String email,
    required String password,
    required String passwordConfirmation,
  });
}