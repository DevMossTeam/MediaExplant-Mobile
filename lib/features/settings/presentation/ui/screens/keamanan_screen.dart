import 'package:flutter/material.dart';

class KeamananScreen extends StatelessWidget {
  const KeamananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan'),
      ),
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
              'Kami mengutamakan privasi dan keamanan data Anda. Berikut adalah beberapa fitur keamanan yang kami terapkan:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Daftar fitur keamanan
            _buildSecurityFeature(
              icon: Icons.lock,
              title: 'Enkripsi Data',
              description:
                  'Semua data Anda dienkripsi untuk menjaga kerahasiaan dan integritas informasi.',
            ),
            _buildSecurityFeature(
              icon: Icons.shield,
              title: 'Verifikasi Dua Langkah',
              description:
                  'Aktifkan verifikasi dua langkah untuk menambah lapisan perlindungan pada akun Anda.',
            ),
            _buildSecurityFeature(
              icon: Icons.security,
              title: 'Peringatan Aktivitas',
              description:
                  'Dapatkan notifikasi segera jika terdeteksi aktivitas mencurigakan pada akun Anda.',
            ),
            _buildSecurityFeature(
              icon: Icons.fingerprint,
              title: 'Autentikasi Biometrik',
              description:
                  'Gunakan sidik jari atau wajah untuk akses yang cepat dan aman ke dalam aplikasi.',
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
              '• Gunakan password yang kuat dan berbeda untuk setiap akun.\n'
              '• Rutin perbarui aplikasi untuk mendapatkan fitur keamanan terbaru.\n'
              '• Waspadai email atau pesan yang mencurigakan.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan fitur keamanan
  Widget _buildSecurityFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }
}