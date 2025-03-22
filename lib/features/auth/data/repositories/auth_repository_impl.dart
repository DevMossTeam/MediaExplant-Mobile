import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthResponse> signIn({required String email, required String password}) async {
    final response = await remoteDataSource.signIn(email: email, password: password);
    
    // Periksa apakah API menyatakan success
    if (response['success'] == true) {
      // Konversi data user menggunakan UserModel, lalu ke entitas domain
      final userModel = UserModel.fromJson(response['user']);
      return AuthResponse(
        user: userModel.toEntity(),
        token: response['token'],
      );
    } else {
      throw Exception(response['message'] ?? 'Sign in failed.');
    }
  }

  @override
  Future<AuthResponse> signUp({required String username, required String email, required String password}) async {
    final response = await remoteDataSource.signUp(
      username: username,
      email: email,
      password: password,
    );

    if (response['success'] == true) {
      final userModel = UserModel.fromJson(response['user']);
      return AuthResponse(
        user: userModel.toEntity(),
        token: response['token'],
      );
    } else {
      throw Exception(response['message'] ?? 'Sign up failed.');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final response = await remoteDataSource.forgotPassword(email: email);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Forgot password failed.');
    }
  }
}