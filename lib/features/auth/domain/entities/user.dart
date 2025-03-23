class User {
  final String uid;
  final String namaPengguna;
  final String email;
  final String? profilePic;    // Bisa null
  final String role;
  final String namaLengkap;

  User({
    required this.uid,
    required this.namaPengguna,
    required this.email,
    this.profilePic,
    required this.role,
    required this.namaLengkap,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      namaPengguna: json['nama_pengguna'],
      email: json['email'],
      profilePic: json['profile_pic'], // Bisa null jika tidak ada
      role: json['role'],
      namaLengkap: json['nama_lengkap'],
    );
  }
}