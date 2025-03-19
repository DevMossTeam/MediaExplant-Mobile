import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Pastikan dependency flutter_svg sudah ditambahkan di pubspec.yaml
import 'package:mediaexplant/core/utils/app_colors.dart'; // Sesuaikan path jika diperlukan

class TentangScreen extends StatelessWidget {
  const TentangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Aplikasi menggunakan SvgPicture.asset
            Center(
              child: SvgPicture.asset(
                'assets/images/app_logo.svg', // Pastikan asset logo sudah dideklarasikan di pubspec.yaml
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16.0),
            // Nama Aplikasi
            Text(
              'Media Explant',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8.0),
            // Informasi Versi
            Text(
              'Versi 1.0.0',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.text.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24.0),
            // Deskripsi Aplikasi
            Text(
              'Aplikasi ini merupakan solusi terbaik untuk memenuhi kebutuhan informasi dan interaksi di lingkungan kampus. '
              'Dengan antarmuka yang intuitif dan fitur-fitur unggulan, aplikasi ini memudahkan pengguna untuk mendapatkan '
              'berita terkini, mengakses informasi akademik, dan berinteraksi dengan komunitas kampus secara efektif. '
              'Teknologi terkini digunakan untuk memastikan performa yang optimal dan pengalaman pengguna yang memuaskan.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                height: 1.5,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 24.0),
            // Informasi Pengembang
            Text(
              'Dikembangkan oleh:\nDevMoss\nEmail: devmoss@gmail.com\nWebsite: www.mediaexplant.com',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 24.0),
            // Hak Cipta
            Text(
              '© 2025 Media Explant. All rights reserved.',
              style: TextStyle(
                fontSize: 12.0,
                color: AppColors.text.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // Link ke halaman License
            TextButton(
              onPressed: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Media Explant',
                  applicationVersion: '1.0.0',
                  applicationIcon: SvgPicture.asset(
                    'assets/images/app_logo.svg',
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
          ],
        ),
      ),
    );
  }
}
