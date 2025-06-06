import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart'; // Sesuaikan path jika diperlukan

class TentangScreen extends StatelessWidget {
  const TentangScreen({super.key});

  // Widget untuk informasi utama aplikasi dalam sebuah Card.
  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang Aplikasi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aplikasi ini merupakan solusi terbaik untuk memenuhi kebutuhan informasi dan interaksi di lingkungan kampus. '
              'Dengan antarmuka yang intuitif dan fitur-fitur unggulan, aplikasi ini memudahkan pengguna untuk mendapatkan '
              'berita terkini, mengakses informasi akademik, dan berinteraksi dengan komunitas kampus secara efektif. '
              'Teknologi terkini digunakan untuk memastikan performa yang optimal dan pengalaman pengguna yang memuaskan.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Dikembangkan oleh:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'DevMoss\nEmail: devmoss@gmail.com\nWebsite: www.mediaexplant.com',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        backgroundColor: AppColors.primary,
        // Jadikan ikon panah (back button) berwarna putih
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tentang',
          style: TextStyle(
            // Buat font sedikit lebih tebal dan berwarna putih
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20, // sesuaikan ukuran jika diinginkan
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Aplikasi (gunakan Image.asset untuk PNG)
            Center(
              child: Image.asset(
                'assets/images/app_logo.png', // Pastikan ini ada dan sudah dideklarasikan di pubspec.yaml
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            // Nama Aplikasi
            const Center(
              child: Text(
                'Media Explant',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Versi Aplikasi
            Center(
              child: Text(
                'Versi 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.text.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Card informasi utama aplikasi
            _buildInfoCard(context),
            const SizedBox(height: 24),
            // Hak Cipta
            Center(
              child: Text(
                '© 2025 Media Explant. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.text.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            // Link ke halaman License
            Center(
              child: TextButton(
                onPressed: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Media Explant',
                    applicationVersion: '1.0.0',
                    applicationIcon: Image.asset(
                      'assets/images/app_logo.png', // Gunakan asset yang sama
                      width: 50,
                      height: 50,
                    ),
                  );
                },
                child: const Text(
                  'Lihat Lisensi',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
