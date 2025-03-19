import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/app_colors.dart'; // Ganti dengan path yang sesuai

class KeamananScreen extends StatelessWidget {
  const KeamananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Halaman
            Text(
              'Keamanan Akun Anda',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kelola pengaturan keamanan untuk melindungi akun Anda.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            // Daftar opsi keamanan
            _buildSecurityOption(
              context,
              icon: Icons.lock_outline,
              title: 'Ganti Password',
              description:
                  'Ubah password untuk meningkatkan keamanan akun Anda.',
              onTap: () {
                // Aksi ganti password, misalnya navigasi ke halaman change password
              },
            ),
            _buildSecurityOption(
              context,
              icon: Icons.email_outlined,
              title: 'Ganti Email',
              description:
                  'Ubah alamat email yang terkait dengan akun Anda.',
              onTap: () {
                // Aksi ganti email
              },
            ),
            _buildSecurityOption(
              context,
              icon: Icons.help_outline,
              title: 'Lupa Password',
              description:
                  'Reset password jika Anda lupa password akun Anda.',
              onTap: () {
                // Aksi lupa password
              },
            ),
            const SizedBox(height: 24),
            // Tips Keamanan
            Text(
              'Tips Keamanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Jangan bagikan informasi login Anda kepada siapa pun.\n'
              '• Gunakan password yang kuat dan unik untuk setiap akun.\n'
              '• Perbarui pengaturan keamanan secara berkala.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.text,
              ),
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
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: AppColors.primary,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.text,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.text.withOpacity(0.8),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.text.withOpacity(0.6),
        ),
      ),
    );
  }
}