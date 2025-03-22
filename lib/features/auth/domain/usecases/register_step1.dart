// lib/features/auth/domain/usecases/register_step1.dart
import '../repositories/auth_repository.dart';

class RegisterStep1 {
  final AuthRepository repository;
  RegisterStep1(this.repository);

  Future<Map<String, dynamic>> call({
    required String namaLengkap,
    required String namaPengguna,
    required String email,
  }) async {
    return await repository.registerStep1(
      namaLengkap: namaLengkap,
      namaPengguna: namaPengguna,
      email: email,
    );
  }
}
