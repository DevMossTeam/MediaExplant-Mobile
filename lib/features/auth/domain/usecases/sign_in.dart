import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<AuthResponse> call({required String email, required String password}) {
    return repository.signIn(email: email, password: password);
  }
}