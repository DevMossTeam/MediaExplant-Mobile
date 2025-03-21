import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String uid,
    required String namaPengguna,
    required String email,
  }) : super(uid: uid, namaPengguna: namaPengguna, email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      namaPengguna: json['nama_pengguna'],
      email: json['email'],
    );
  }
}