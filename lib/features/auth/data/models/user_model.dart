import '../../domain/entities/user.dart';

class UserModel {
  final String uid;
  final String namaPengguna;
  final String email;
  final String role;

  UserModel({
    required this.uid,
    required this.namaPengguna,
    required this.email,
    required this.role,
  });

  // Konversi dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      namaPengguna: json['nama_pengguna'],
      email: json['email'],
      role: json['role'],
    );
  }

  // Tambahkan metode toEntity()
  User toEntity() {
    return User(
      uid: uid,
      namaPengguna: namaPengguna,
      email: email,
      role: role,
    );
  }
}