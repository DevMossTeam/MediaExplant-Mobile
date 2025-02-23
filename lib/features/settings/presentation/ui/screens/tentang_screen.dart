import 'package:flutter/material.dart';

class TentangScreen extends StatelessWidget {
  const TentangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Aplikasi
            Center(
              child: Image.asset(
                'assets/app_logo.png', // Pastikan asset logo sudah dideklarasikan di pubspec.yaml
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16.0),
            // Nama Aplikasi
            const Text(
              'Nama Aplikasi',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Informasi Versi
            const Text(
              'Versi 1.0.0',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24.0),
            // Deskripsi Aplikasi
            const Text(
              'Deskripsi Aplikasi:\n\n'
              'Aplikasi ini merupakan solusi terbaik untuk memenuhi kebutuhan informasi dan interaksi di lingkungan kampus. '
              'Dengan antarmuka yang intuitif dan fitur-fitur unggulan, aplikasi ini memudahkan pengguna untuk mendapatkan '
              'berita terkini, mengakses informasi akademik, dan berinteraksi dengan komunitas kampus secara efektif. '
              'Teknologi terkini digunakan untuk memastikan performa yang optimal dan pengalaman pengguna yang memuaskan.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            const SizedBox(height: 24.0),
            // Informasi Pengembang
            const Text(
              'Dikembangkan oleh:\nDevMoss\nEmail: devmoss@gmail.com\nWebsite: www.mediaexplant.com',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 24.0),
            // Hak Cipta
            const Text(
              '© 2025 Nama Aplikasi. All rights reserved.',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // Link ke halaman License
            TextButton(
              onPressed: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Nama Aplikasi',
                  applicationVersion: '1.0.0',
                  applicationIcon: Image.asset(
                    'assets/app_logo.png',
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
