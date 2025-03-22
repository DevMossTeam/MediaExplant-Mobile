// lib/features/auth/domain/usecases/register_step3.dart
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class RegisterStep3 {
  final AuthRepository repository;
  RegisterStep3(this.repository);

  Future<AuthResponse> call({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await repository.registerStep3(
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
