import '../../domain/entities/user.dart';

class UserModel {
  final String uid;
  final String namaPengguna;
  final String email;
  final String role;
  final String namaLengkap; // Tambahkan field ini

  UserModel({
    required this.uid,
    required this.namaPengguna,
    required this.email,
    required this.role,
    required this.namaLengkap, // Pastikan parameter ini disediakan
  });

  // Konversi dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      namaPengguna: json['nama_pengguna'],
      email: json['email'],
      role: json['role'],
      namaLengkap: json['nama_lengkap'] ?? "", // Pastikan kunci "nama_lengkap" ada di JSON
    );
  }

  // Konversi ke entitas domain
  User toEntity() {
    return User(
      uid: uid,
      namaPengguna: namaPengguna,
      email: email,
      role: role,
      namaLengkap: namaLengkap,
    );
  }
}