class User {
  final String uid;
  final String namaPengguna;
  final String email;
  final String? role; // Role opsional jika tidak tersedia dari API

  const User({
    required this.uid,
    required this.namaPengguna,
    required this.email,
    this.role,
  });
}