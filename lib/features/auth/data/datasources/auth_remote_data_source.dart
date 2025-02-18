import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({required String username, required String email, required String password});
  Future<void> forgotPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == "test@example.com" && password == "password") {
      return UserModel(id: "1", name: "Test User", email: email);
    } else {
      throw Exception("Invalid credentials");
    }
  }

  @override
  Future<UserModel> signUp({required String username, required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email != "existing@example.com") {
      return UserModel(id: "2", name: username, email: email);
    } else {
      throw Exception("Email already in use");
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulasi: jika email tidak ditemukan, lempar error
    if (email == "unknown@example.com") {
      throw Exception("Email not found");
    }
    return;
  }
}
