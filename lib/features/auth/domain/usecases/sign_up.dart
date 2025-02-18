import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<User> call({
    required String username,
    required String email,
    required String password,
  }) {
    return repository.signUp(username: username, email: email, password: password);
  }
}