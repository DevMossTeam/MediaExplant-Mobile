class User {
  final String uid;
  final String namaPengguna;
  final String email;
  final String? role; // Tambahkan role opsional jika API menyediakannya

  User({
    required this.uid,
    required this.namaPengguna,
    required this.email,
    this.role, // Role bisa null jika tidak tersedia
  });
}