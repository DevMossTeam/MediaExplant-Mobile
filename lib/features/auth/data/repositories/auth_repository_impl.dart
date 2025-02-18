import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> signIn({required String email, required String password}) {
    return remoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<User> signUp({required String username, required String email, required String password}) {
    return remoteDataSource.signUp(username: username, email: email, password: password);
  }

  @override
  Future<void> forgotPassword({required String email}) {
    return remoteDataSource.forgotPassword(email: email);
  }
}