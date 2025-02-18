import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    // Simulasikan delay API
    await Future.delayed(const Duration(seconds: 2));
    if (email == "test@example.com" && password == "password") {
      return UserModel(
        id: "1",
        name: "Test User",
        email: email,
      );
    } else {
      throw Exception("Invalid credentials");
    }
  }
}