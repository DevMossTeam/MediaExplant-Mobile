import 'package:flutter/material.dart';

class KeamananScreen extends StatelessWidget {
  const KeamananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keamanan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Halaman
            const Text(
              'Keamanan Akun Anda',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kelola pengaturan keamanan untuk melindungi akun Anda.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Daftar opsi keamanan
            _buildSecurityOption(
              context,
              icon: Icons.lock_outline,
              title: 'Ganti Password',
              description: 'Ubah password untuk meningkatkan keamanan akun Anda.',
              onTap: () {
                // Aksi ganti password, misalnya navigasi ke halaman change password
              },
            ),
            _buildSecurityOption(
              context,
              icon: Icons.email_outlined,
              title: 'Ganti Email',
              description: 'Ubah alamat email yang terkait dengan akun Anda.',
              onTap: () {
                // Aksi ganti email
              },
            ),
            _buildSecurityOption(
              context,
              icon: Icons.help_outline,
              title: 'Lupa Password',
              description: 'Reset password jika Anda lupa password akun Anda.',
              onTap: () {
                // Aksi lupa password
              },
            ),
            const SizedBox(height: 24),
            // Tips Keamanan
            const Text(
              'Tips Keamanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Jangan bagikan informasi login Anda kepada siapa pun.\n'
              '• Gunakan password yang kuat dan unik untuk setiap akun.\n'
              '• Aktifkan verifikasi dua langkah jika tersedia.\n'
              '• Perbarui pengaturan keamanan secara berkala.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk opsi keamanan dengan onTap
  Widget _buildSecurityOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
