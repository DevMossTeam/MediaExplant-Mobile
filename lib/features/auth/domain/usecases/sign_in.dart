import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<User> call({required String email, required String password}) {
    return repository.signIn(email: email, password: password);
  }
}
